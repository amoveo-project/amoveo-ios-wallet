//
// Created by Igor Efremov on 18/10/2018.
// Copyright (c) 2018 EXANTE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AmoveoInnerWallet;

@interface AmoveoWalletGenerator : NSObject

+ (AmoveoInnerWallet *)createWithRandomMnemonic;
+ (AmoveoInnerWallet *)createWithMnemonic:(NSString *)mnemonic;
+ (AmoveoInnerWallet *)createWithPrivateKey:(NSString *)privateHexKey;

@end
