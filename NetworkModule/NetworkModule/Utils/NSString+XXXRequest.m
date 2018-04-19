//
//  NSString+XXXRequest.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/4/18.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "NSString+XXXRequest.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (XXXRequest)

- (NSString *)stringToSignature {
    const char * input = [self UTF8String]; // UTF8的转码
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [outputString appendFormat:@"%02x", result[i]];
    }
    
    return outputString;
}

@end
