//
//  NSString+Md5.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/4/1.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "NSString+ConvertToMd5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Md5)

- (NSString *)stringToMd5 {
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
