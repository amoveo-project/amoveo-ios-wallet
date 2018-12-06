//
// Created by Igor Efremov on 25/10/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

#import "Base64EncodeDecodeUtil.h"


@implementation Base64EncodeDecodeUtil {

}

+ (NSData *)decodeBase64:(NSString*)value {
    return [[NSData alloc] initWithBase64EncodedString: value options: 0];
}

@end
