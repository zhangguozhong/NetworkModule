//
//  NetworkConfig.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppContext : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

+ (AppContext *)appContext;

@property (copy, nonatomic) NSString *domain; //域名
@property (copy, nonatomic, readonly) NSString *appVersion; // app版本号
@property (copy, nonatomic) NSString *sessionToken; // 用于判断是否登录
@property (copy, nonatomic) NSString *apiVersion; // api版本，可以用于做api版本兼容
@property (copy, nonatomic) NSString *cachePath;
@property (strong, nonatomic) NSDictionary *requestHeaders; // 请求头信息

@property (copy, nonatomic, readonly) NSString *systemName;
@property (copy, nonatomic, readonly) NSString *systemVersion;


@end
