//
//  NetworkRequestObject.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseRequestObject;

typedef NS_OPTIONS(NSUInteger, RequestSerializerType) {
    RequestSerializerTypeHTTP = 0,
    RequestSerializerTypeJSON
};


@protocol RequestObjectDelegate <NSObject>

- (NSString *)requestMethod;
- (id)requestParams; //请求参数
- (NSUInteger)requestSerializerType;
- (NSString *)requestUrl; //请求的接口名称

@optional
- (NSString *)baseUrl; //请求的接口域名地址
- (BOOL)shouldRequestCompletionCacheData; //是否开启缓存，默认不开启
- (BOOL)writeCacheAsynchronously;
- (NSTimeInterval)cacheTimeInterval; //缓存过期时间
- (NSTimeInterval)requestTimeoutInterval; // 每个请求的超时时间
- (NSDictionary *)headerFieldValueDictionary; // 设置该请求的请求头

@end


@protocol RequestParametersDelegate <NSObject>

/**
 配置参数方法

 @param requestObject 请求对象
 @return 所配置的参数
 */
- (id)requestParamsWithRequestObject:(BaseRequestObject *)requestObject;

@end


/**
 请求回调协议
 */
@protocol RequestCallBackDelegate <NSObject>

- (void)requestCompleteWithRequestObject:(BaseRequestObject *)requestObject withErrorInfo:(NSError *)errorInfo;

@end


@interface BaseRequestObject : NSObject<RequestObjectDelegate>

@property (nonatomic) id responseObject; // 返回数据
@property (strong,nonatomic) NSURLSessionDataTask *requestDataTask; // 该请求的requestTask对象
@property (assign, nonatomic) BOOL ignoreCache; // 忽略缓存
@property (weak, nonatomic) id<RequestCallBackDelegate> delegate; //回调委托对象
@property (weak,nonatomic) id<RequestParametersDelegate> paramsDelegate; //配置参数委托对象


- (void)taskStart;
- (NSString *)cacheVersion; // 设置此次缓存的版本，默认与appVersion一致
- (void)requestCompletionPreprocessor;


@end
