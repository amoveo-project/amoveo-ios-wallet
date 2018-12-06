//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 EXANTE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Signature;

@interface Cancellable : NSObject

- (void)cancel;

@end

@interface AmoveoInnerWallet : NSObject

@property (nonatomic, readonly) NSString *mnemonicPhrase;
@property (nonatomic, readonly) NSString *address;

- (instancetype)initWithMnemonicPhrase: (NSString*)mnemonicPhrase;
- (instancetype)initWithPrivateHexKey:(NSString *)privateHexKey;
- (NSString *)privateKeyInExportFormat;

+ (BOOL)isValidMnemonicPhrase: (NSString*)phrase;

- (Cancellable*)encryptSecretStorageJSON:(NSString *)password callback:(void (^)(NSString *))callback;
+ (Cancellable*)decryptSecretStorageJSON:(NSString *)json password:(NSString *)password callback:(void (^)(AmoveoInnerWallet *, NSError *))callback;

- (Signature *)signDigest:(NSData *)digestData;
- (NSData *)serializeToDER:(Signature *)signature;

@end
