//
//  RequestProtocol.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/4/8.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestProtocol <NSObject>

@required

- (NSString *)requestMethod;
- (id)requestParams; //请求参数
- (NSUInteger)requestSerializerType;
- (NSString *)requestUrl; //请求的接口名称


@optional

- (NSString *)baseUrl; //请求的接口域名地址
- (BOOL)shouldRequestCompletionCacheData; //是否开启缓存，默认不开启
- (NSTimeInterval)cacheTimeInterval; //缓存过期时间
- (NSTimeInterval)requestTimeoutInterval; // 每个请求的超时时间
- (NSDictionary *)headerFieldValueDictionary; // 设置该请求的请求头


@end
