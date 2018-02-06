//
//  NetworkConfig.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkUtils : NSObject

@property (copy, nonatomic) NSString *environment;
@property (copy, nonatomic) NSDictionary *configData;

/**
 服务端域名配置文件名
 */
@property (copy, nonatomic) NSString *domainPlistName;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

+ (NetworkUtils *)networkUtils;
- (NSString *)getDataForKey:(NSString *)key;

@end
