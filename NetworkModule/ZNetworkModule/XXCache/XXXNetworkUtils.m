//
//  XXXNetworkUtils.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/6/18.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "XXXNetworkUtils.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation XXXNetworkUtils

+ (NSString *)md5StringFromString:(NSString *)string {
    NSParameterAssert(string != nil && [string length] > 0);
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

@end
