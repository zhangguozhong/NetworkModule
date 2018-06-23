//
//  XXXCacheMetadata.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/6/17.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXXCacheMetadata : NSObject <NSSecureCoding>

@property (copy, nonatomic) NSString *apiVersion;
@property (strong, nonatomic) NSDate *cacheCreateTime;
@property (copy, nonatomic) NSString *appVersion;

@end
