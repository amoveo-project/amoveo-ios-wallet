//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 EXANTE. All rights reserved.
//

#import "AmoveoWalletGenerator.h"
#import "AmoveoInnerWallet.h"
#import "SecureData.h"
#include "bip39.h"

#define MNEMONIC_STRENGTH    (128 / 8)

@implementation AmoveoWalletGenerator {

}

+ (AmoveoInnerWallet *)createWithMnemonic:(NSString *)mnemonic {
    return [[AmoveoInnerWallet alloc] initWithMnemonicPhrase:mnemonic];
}

+ (AmoveoInnerWallet *)createWithRandomMnemonic {
    SecureData* data = [SecureData secureDataWithLength:MNEMONIC_STRENGTH];
    int result = SecRandomCopyBytes(kSecRandomDefault, data.length, data.mutableBytes);
    if (result != noErr) { return nil; }

    NSString *mnemonicPhrase = [NSString stringWithCString:mnemonic_from_data(data.bytes, (int)data.length) encoding:NSUTF8StringEncoding];
    return [[AmoveoInnerWallet alloc] initWithMnemonicPhrase:mnemonicPhrase];
}

+ (AmoveoInnerWallet *)createWithPrivateKey:(NSString *)privateHexKey {
    return [[AmoveoInnerWallet alloc] initWithPrivateHexKey:privateHexKey];
}

@end
