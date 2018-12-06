//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 EXANTE. All rights reserved.
//

#import "AmoveoInnerWallet.h"
#import "bip39.h"
#import "SecureData.h"
#import "bip32.h"
#import "curves.h"
#import "secp256k1.h"

#include "crypto_scrypt.h"
#include "aes.h"

#import "Signature.h"

static NSErrorDomain ErrorDomain = @"com.amoveowallet.WalletError";

static const NSInteger kAccountErrorJSONInvalid = -1;
static const NSInteger kAccountErrorJSONUnsupportedKeyDerivationFunction = -3;
static const NSInteger kAccountErrorJSONUnsupportedCipher = -4;
static const NSInteger kAccountErrorJSONInvalidParameter = -5;
static const NSInteger kAccountErrorMnemonicMismatch = -6;
static const NSInteger kAccountErrorWrongPassword = -10;
static const NSInteger kAccountErrorCancelled = -20;
static const NSInteger kAccountErrorUnknownError = -50;

NSObject *getPath(NSObject *object, NSString *path, Class expectedClass) {

    for (NSString *component in [[path lowercaseString] componentsSeparatedByString:@"/"]) {
        if (![object isKindOfClass:[NSDictionary class]]) { return nil; }

        BOOL found = NO;
        for (NSString *childKey in [(NSDictionary*)object allKeys]) {
            if ([component isEqualToString:[childKey lowercaseString]]) {
                found = YES;
                object = ((NSDictionary *) object)[childKey];
                break;
            }
        }
        if (!found) { return nil; }
    }

    if (![object isKindOfClass:expectedClass]) {
        return nil;
    }

    return object;
}

NSData *getHexData(NSString *unprefixedHexString) {
    if (![unprefixedHexString hasPrefix:@"0x"]) {
        unprefixedHexString = [@"0x" stringByAppendingString:unprefixedHexString];
    }
    return [SecureData hexStringToData:unprefixedHexString];
}

NSData *ensureDataLength(NSString *hexString, NSUInteger length) {
    if (![hexString isKindOfClass:[NSString class]]) { return nil; }
    NSData *data = [SecureData hexStringToData:[@"0x" stringByAppendingString:hexString]];
    if ([data length] != length) { return nil; }
    return data;
}

@interface Cancellable ()
@end


@implementation Cancellable {
    BOOL _cancelled;
    void (^_cancelCallback)(void);
}

- (instancetype)initWithCancelCallback: (void (^)(void))cancelCallback {
    self = [super init];
    if (self) {
        _cancelCallback = cancelCallback;
    }
    return self;
}

- (void)cancel {
    if (!_cancelled && _cancelCallback) {
        _cancelled = YES;
        _cancelCallback();
    }
}

@end

@implementation AmoveoInnerWallet {
    SecureData *_privateKey;
    NSData *_mnemonicData;
}

- (instancetype)initWithMnemonicPhrase: (NSString*)mnemonicPhrase {
    const char* phraseStr = [mnemonicPhrase cStringUsingEncoding:NSUTF8StringEncoding];
    if (!mnemonic_check(phraseStr)) { return nil; }

    SecureData *seed = [SecureData secureDataWithLength:(512 / 8)];
    mnemonic_to_seed(phraseStr, "", seed.mutableBytes, NULL);

    HDNode node;
    hdnode_from_seed([seed bytes], (int)[seed length], SECP256K1_NAME, &node);

    hdnode_private_ckd(&node, (0x80000000 | (44)));   // 44'  - BIP 44 (purpose field)
    hdnode_private_ckd(&node, (0x80000000 | (488)));  // 488' - VEO (see SLIP 44)
    hdnode_private_ckd(&node, (0x80000000 | (0)));    // 0'   - Account 0
    hdnode_private_ckd(&node, 0);                     // 0    - External
    hdnode_private_ckd(&node, 0);                     // 0    - Slot #0

    SecureData *privateKey = [SecureData secureDataWithLength:32];
    memcpy(privateKey.mutableBytes, node.private_key, 32);

    self = [self initWithPrivateKey:privateKey.data];
    if (self) {
        _mnemonicPhrase = mnemonicPhrase;

        SecureData *fullData = [SecureData secureDataWithLength:MAXIMUM_BIP39_DATA_LENGTH];
        int length = data_from_mnemonic([_mnemonicPhrase cStringUsingEncoding:NSUTF8StringEncoding], fullData.mutableBytes);

        _mnemonicData = [fullData subdataToIndex:length].data;
    }

    // Wipe the node
    memset(&node, 0, sizeof(node));

    return self;
}

- (instancetype)initWithPrivateHexKey:(NSString *)privateHexKey {
    if (privateHexKey.length != 64) { return nil; }

    NSString *preparedPK;
    if (![privateHexKey hasPrefix: @"0x"]) {
        preparedPK = [@"0x" stringByAppendingString: privateHexKey];
    } else {
        preparedPK = privateHexKey;
    }

    self = [self initWithPrivateKey: [SecureData secureDataWithHexString: preparedPK].data];
    if (self) {
    }

    return self;
}

- (instancetype)initWithPrivateKey:(NSData *)privateKey {
    if (privateKey.length != 32) { return nil; }

    self = [super init];
    if (self) {
        _privateKey = [SecureData secureDataWithData:privateKey];

        SecureData *publicKey = [SecureData secureDataWithLength:65];
        ecdsa_get_public_key65(&secp256k1, _privateKey.bytes, publicKey.mutableBytes);
        _address = [[publicKey data] base64EncodedStringWithOptions: 0];
    }

    return self;
}

+ (BOOL)isValidMnemonicPhrase:(NSString *)phrase {
    return (mnemonic_check([phrase cStringUsingEncoding:NSUTF8StringEncoding]));
}

+ (instancetype)accountWithMnemonicData: (NSData*)data {
    const char* phrase = mnemonic_from_data([data bytes], (int)[data length]);
    return [[AmoveoInnerWallet alloc] initWithMnemonicPhrase:[NSString stringWithCString:phrase encoding:NSUTF8StringEncoding]];
}

- (Cancellable*)encryptSecretStorageJSON:(NSString *)password callback:(void (^)(NSString *))callback {

    void (^sendResult)(NSString*) = ^(NSString *result) {
        dispatch_async(dispatch_get_main_queue(), ^() {
            callback(result);
        });
    };

    // Convert password to NFKC form
    NSData *passwordData = [[password precomposedStringWithCompatibilityMapping] dataUsingEncoding:NSUTF8StringEncoding];
    const uint8_t *passwordBytes = [passwordData bytes];

    NSUUID *uuid = [NSUUID UUID];

    SecureData *iv = [SecureData secureDataWithLength:16];
    {
        int failure = SecRandomCopyBytes(kSecRandomDefault, (int)iv.length, iv.mutableBytes);
        if (failure) {
            sendResult(nil);
            return nil;
        }
    }

    SecureData *salt = [SecureData secureDataWithLength:32];;
    {
        int failure = SecRandomCopyBytes(kSecRandomDefault, (int)salt.length, salt.mutableBytes);
        if (failure) {
            sendResult(nil);
            return nil;
        }
    }

    int r = 8;
    int p = 1;
    int n = 65536;

    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[@"address"] = self.address;
    json[@"id"] = [uuid UUIDString];
    json[@"version"] = @3;

    NSMutableDictionary *amoveo = [NSMutableDictionary dictionary];
    json[@"amoveo"] = amoveo;

    NSMutableDictionary *crypto = [NSMutableDictionary dictionary];
    json[@"Crypto"] = crypto;

    crypto[@"kdfparams"] = @{
            @"p": @(p),
            @"r": @(r),
            @"n": @(n),
            @"dklen": @([salt length]),
            @"salt": [[salt hexString] substringFromIndex:2],
    };
    crypto[@"kdf"] = @"scrypt";
    crypto[@"cipherparams"] = @{
            @"iv": [[iv hexString] substringFromIndex:2],
    };
    crypto[@"cipher"] = @"aes-128-ctr";

    // Set amoveo parameters
    amoveo[@"client"] = @"Amoveo_Wallet";
    amoveo[@"version"] = @"1.0";

    __block char stop = 0;

    Cancellable *cancellable = [[Cancellable alloc] initWithCancelCallback:^() {
        stop = 1;
    }];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^() {

        // Get the key to encrypt with from the password and salt
        SecureData *derivedKey = [SecureData secureDataWithLength:64];
        int status = crypto_scrypt(passwordBytes, (int)passwordData.length, salt.bytes, salt.length, n, r, p, derivedKey.mutableBytes, derivedKey.length, &stop);

        // Bad scrypt parameters
        if (status) {
            sendResult(nil);
            return;
        }

        SecureData *cipherText = [SecureData secureDataWithLength:32];
        {
            unsigned char counter[16];
            memcpy(counter, iv.bytes, MIN(iv.length, sizeof(counter)));

            SecureData *encryptionKey = [derivedKey subdataWithRange:NSMakeRange(0, 16)];

            aes_encrypt_ctx context;
            aes_encrypt_key128(encryptionKey.bytes, &context);

            AES_RETURN aesStatus = aes_ctr_encrypt([self->_privateKey bytes],
                    [cipherText mutableBytes],
                                                   (int)self->_privateKey.length,
                    counter,
                    &aes_ctr_cbuf_inc,
                    &context);

            if (aesStatus != EXIT_SUCCESS) {
                sendResult(nil);
                return;
            }
        }

        crypto[@"ciphertext"] = [[cipherText hexString] substringFromIndex:2];

        if (self->_mnemonicData) {
            SecureData *mnemonicCounter = [SecureData secureDataWithLength:16];;
            {
                int failure = SecRandomCopyBytes(kSecRandomDefault, (int)mnemonicCounter.length, [mnemonicCounter mutableBytes]);
                if (failure) {
                    sendResult(nil);
                    return;
                }
            }

            SecureData *mnemonicCiphertext = [SecureData secureDataWithLength:self->_mnemonicData.length];

            // We are using a different key, so it is safe to use the same IV
            unsigned char counter[16];
            memcpy(counter, mnemonicCounter.bytes, MIN(mnemonicCounter.length, sizeof(counter)));

            aes_encrypt_ctx context;
            aes_encrypt_key256([derivedKey subdataWithRange:NSMakeRange(32, 32)].bytes, &context);

            AES_RETURN aesStatus = aes_ctr_encrypt([self->_mnemonicData bytes],
                    [mnemonicCiphertext mutableBytes],
                                                   (int)self->_mnemonicData.length,
                    counter,
                    &aes_ctr_cbuf_inc,
                    &context);

            if (aesStatus != EXIT_SUCCESS) {
                sendResult(nil);
                return;
            }

            amoveo[@"mnemonicCounter"] = [[mnemonicCounter hexString] substringFromIndex:2];
            amoveo[@"mnemonicCiphertext"] = [[mnemonicCiphertext hexString] substringFromIndex:2];
        }


        // Compute the MAC
        {
            SecureData *macCheck = [SecureData secureDataWithCapacity:(16 + 32)];
            [macCheck append:[derivedKey subdataWithRange:NSMakeRange(16, 16)]];
            [macCheck append:cipherText];
            crypto[@"mac"] = [[[macCheck KECCAK256] hexString] substringFromIndex:2];
        }

        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
        if (error) {
            NSLog(@"Account: Error decoding JSON - %@", error);
            sendResult(nil);
            return;
        }


        sendResult([[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    });

    return cancellable;
}

+ (Cancellable*)decryptSecretStorageJSON:(NSString *)json password:(NSString *)password callback:(void (^)(AmoveoInnerWallet *, NSError *))callback {

    void (^sendError)(NSInteger, NSString*) = ^(NSInteger errorCode, NSString *reason) {
        dispatch_async(dispatch_get_main_queue(), ^() {
            callback(nil, [NSError errorWithDomain:ErrorDomain code:errorCode userInfo:@{@"reason": reason}]);
        });
    };

    NSError *error = nil;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];

    if (error) {
        sendError(kAccountErrorJSONInvalid, [error description]);
        return nil;
    }

    NSString *expectedAddress = (NSString*)getPath(data, @"address", [NSString class]);
    if (!expectedAddress) {
        sendError(kAccountErrorJSONInvalidParameter, [NSString stringWithFormat:@"invalidAddress(%@)", expectedAddress]);
        return nil;
    }

    NSString *kdf = (NSString*)getPath(data, @"crypto/kdf", [NSString class]);
    NSData *salt = getHexData((NSString*)getPath(data, @"crypto/kdfparams/salt", [NSString class]));
    int n = [(NSNumber*)getPath(data, @"crypto/kdfparams/n", [NSNumber class]) intValue];
    int p = [(NSNumber*)getPath(data, @"crypto/kdfparams/p", [NSNumber class]) intValue];
    int r = [(NSNumber*)getPath(data, @"crypto/kdfparams/r", [NSNumber class]) intValue];
    int dkLen = [(NSNumber*)getPath(data, @"crypto/kdfparams/dklen", [NSNumber class]) intValue];
    if (![kdf isEqualToString:@"scrypt"] || salt.length == 0 || !n || !p || !r || dkLen != 32) {
        sendError(kAccountErrorJSONUnsupportedKeyDerivationFunction, @"Invalid KDF parameters");
        return nil;
    }

    NSString *cipher = (NSString*)getPath(data, @"crypto/cipher", [NSString class]);
    NSData *iv = getHexData((NSString*)getPath(data, @"crypto/cipherparams/iv", [NSString class]));
    NSData *cipherText = getHexData((NSString*)getPath(data, @"crypto/ciphertext", [NSString class]));
    if (![cipher isEqualToString:@"aes-128-ctr"] || iv.length != 16 || cipherText.length != 32) {
        sendError(kAccountErrorJSONUnsupportedCipher, @"Invalid cipher parameters");
        return nil;
    }

    NSData *mac = getHexData((NSString*)getPath(data, @"crypto/mac", [NSString class]));
    if (mac.length != 32) {
        sendError(kAccountErrorJSONInvalidParameter, [NSString stringWithFormat:@"Bad MAC length (%d)", (int)(mac.length)]);
        return nil;
    }

    // Convert password to NFKC form
    NSData *passwordData = [[password precomposedStringWithCompatibilityMapping] dataUsingEncoding:NSUTF8StringEncoding];
    const uint8_t *passwordBytes = [passwordData bytes];

    __block char stop = 0;

    Cancellable *cancellable = [[Cancellable alloc] initWithCancelCallback:^() {
        stop = 1;
    }];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^() {
        // Get the key to encrypt with from the password and salt
        SecureData *derivedKey = [SecureData secureDataWithLength:64];
        int status = crypto_scrypt(passwordBytes, (int)passwordData.length, salt.bytes, salt.length, n, r, p, derivedKey.mutableBytes, derivedKey.length, &stop);

        // Bad scrypt parameters
        if (status) {
            if (status == -2) {
                sendError(kAccountErrorCancelled, @"Cancelled");
                return;
            }
            NSString *reason = [NSString stringWithFormat:@"Invalid scrypt parameter (salt=%@, N=%d, r=%d, p=%d, dekLen=%d)",
                                                          salt, n, r, p, (int)derivedKey.length];
            sendError(kAccountErrorJSONInvalidParameter, reason);
            return;
        }

        // Check the MAC
        {
            SecureData *macCheck = [SecureData secureDataWithCapacity:(16 + 32)];
            [macCheck append:[derivedKey subdataWithRange:NSMakeRange(16, 16)]];
            [macCheck appendData:cipherText];

            if (![[macCheck KECCAK256] isEqual:mac]) {
                sendError(kAccountErrorWrongPassword, @"Wrong Password");
                return;
            }
        }

        SecureData *privateKey = [SecureData secureDataWithLength:32];

        {
            SecureData *encryptionKey = [derivedKey subdataWithRange:NSMakeRange(0, 16)];
            unsigned char counter[16];
            [iv getBytes:counter length:iv.length];

            // CTR uses encrypt to decrypt
            aes_encrypt_ctx context;
            aes_encrypt_key128(encryptionKey.bytes, &context);

            AES_RETURN aesStatus = aes_ctr_decrypt(cipherText.bytes,
                    privateKey.mutableBytes,
                    (int)privateKey.length,
                    counter,
                    &aes_ctr_cbuf_inc,
                    &context);

            if (aesStatus != EXIT_SUCCESS) {
                sendError(kAccountErrorUnknownError, @"AES Error");
                return;
            }
        }

        AmoveoInnerWallet *innerWallet = [[AmoveoInnerWallet alloc] initWithPrivateKey:privateKey.data];
        if (![innerWallet.address isEqualToString:expectedAddress]) {
            sendError(kAccountErrorJSONInvalidParameter, @"Address mismatch");
            return;
        }

        // Check for an mnemonic phrase
        NSDictionary *amoveoData = data[@"amoveo"];
        if ([amoveoData isKindOfClass:[NSDictionary class]] && [amoveoData[@"version"] isEqual:@"1.0"]) {

            NSData *mnemonicCounter = ensureDataLength(amoveoData[@"mnemonicCounter"], 16);
            NSData *mnemonicCiphertext = ensureDataLength(amoveoData[@"mnemonicCiphertext"], 16);
            if (mnemonicCounter && mnemonicCiphertext) {

                SecureData *mnemonicData = [SecureData secureDataWithLength:[mnemonicCiphertext length]];

                unsigned char counter[16];
                [mnemonicCounter getBytes:counter length:mnemonicCounter.length];

                aes_encrypt_ctx context;
                aes_encrypt_key256([derivedKey subdataWithRange:NSMakeRange(32, 32)].bytes, &context);

                AES_RETURN aesStatus = aes_ctr_decrypt([mnemonicCiphertext bytes],
                        [mnemonicData mutableBytes],
                        (int)mnemonicData.length,
                        counter,
                        &aes_ctr_cbuf_inc,
                        &context);

                if (aesStatus != EXIT_SUCCESS) {
                    sendError(kAccountErrorUnknownError, @"AES Error");
                    return;
                }

                if(mnemonicData) {
                    AmoveoInnerWallet *mnemonicWallet = [AmoveoInnerWallet accountWithMnemonicData: mnemonicData.data];
                    if (![mnemonicWallet.address isEqualToString:innerWallet.address]) {
                        sendError(kAccountErrorMnemonicMismatch, @"Mnemonic Mismatch");
                        return;
                    }

                    innerWallet = mnemonicWallet;
                }
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^() {
            callback(innerWallet, nil);
        });
    });

    return cancellable;
}

- (NSString *)privateKeyInExportFormat {
    if([_privateKey data]) {
        return [_privateKey hexStringWithPrefix: false];
    }

    return nil;
}


- (Signature *)signDigest:(NSData *)digestData {
    if (digestData.length != 32) { return nil; }

    SecureData *signatureData = [SecureData secureDataWithLength:64];
    uint8_t pby;
    ecdsa_sign_digest(&secp256k1, [_privateKey bytes], digestData.bytes, signatureData.mutableBytes, &pby, NULL);

    return [Signature signatureWithData: [signatureData data] v: pby];
}

// TODO: Move to Signature class
- (NSData*)serializeToDER:(Signature *)signature {
    SecureData *data = [[SecureData alloc] init];
    [data appendData: signature.r];
    [data appendData: signature.s];

    uint8_t der[72];
    int len = ecdsa_sig_to_der(data.bytes, der);
    return [[NSData alloc] initWithBytes:der length:len];
}

@end
