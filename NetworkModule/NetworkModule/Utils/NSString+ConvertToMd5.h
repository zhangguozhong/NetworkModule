//
//  NSString+Md5.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/4/1.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ConvertToMd5)

/**
 生成md5加密后的字符串

 @return 32位加密过的字符串（小写）
 */
- (NSString *)stringToMd5;


@end
