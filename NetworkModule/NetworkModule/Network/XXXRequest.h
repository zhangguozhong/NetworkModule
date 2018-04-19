//
//  NetworkRequestObject.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXXRequestConfiguration.h"

typedef NS_OPTIONS(NSUInteger, RequestSerializerType) {
    RequestSerializerTypeHTTP = 0,
    RequestSerializerTypeJSON
};


@protocol XXXRequestDelegate <NSObject>
@required
- (NSString *)requestMethod;
- (id)requestParams; //请求参数
- (NSUInteger)requestSerializerType;
- (NSString *)requestUrl; //请求的接口名称

@optional
- (NSString *)baseUrl; //请求的接口域名地址
- (NSTimeInterval)requestTimeoutInterval; // 每个请求的超时时间
- (NSDictionary *)headerFieldValueDictionary; // 设置该请求的请求头

@end


@protocol XXXRequestParametersDelegate <NSObject>
/**
 配置请求参数方法
 */
@required
- (id)paramsWithRequest:(XXXRequest *)baseRequest;

@end


@protocol XXXRequestDataReformer <NSObject>

/**
 格式化返回结果协议方法
 */
@required
- (id)request:(XXXRequest *)request reformData:(NSDictionary *)data;

@end

@interface XXXRequest : NSObject <XXXRequestDelegate>

@property (strong, nonatomic) NSURLSessionDataTask *requestDataTask; // 该请求的requestTask对象
@property (assign, nonatomic) BOOL ignoreCache; // 忽略缓存
@property (assign, nonatomic) NSInteger timedOutCount; // 超时次数
@property (weak, nonatomic) id<XXXRequestParametersDelegate> paramsDelegate; //配置参数委托对象

- (void)startWithBlock:(XXCallbackWithRequestBlock)callbackWithRequestBlock;
- (id)fetchDataWithReformer:(id<XXXRequestDataReformer>)reformer;


@end
