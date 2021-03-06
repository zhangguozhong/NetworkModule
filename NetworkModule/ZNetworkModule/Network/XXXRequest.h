//
//  NetworkRequestObject.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "XXXBaseRequest.h"
@class XXXRequest;
typedef void(^XXCallbackWithRequestBlock)(NSError *error);

typedef NS_OPTIONS(NSUInteger, RequestSerializerType) {
    RequestSerializerTypeHTTP = 0,
    RequestSerializerTypeJSON
};

typedef NS_OPTIONS(NSUInteger, ResponseSerializerType) {
    ResponseSerializerTypeHTTP = 0,
    ResponseSerializerTypeJSON = 1,
    ResponseSerializerTypeXML
};


@protocol XXXRequestDelegate <NSObject>

@required
- (NSString *)requestMethod;
- (id)requestParams; //请求参数
- (NSString *)requestUrl; //请求的接口名称

@optional
- (NSString *)baseUrl; //请求的接口域名地址
- (NSString *)apiVersion;//接口版本
- (NSUInteger)requestSerializerType;
- (NSUInteger)responseSerializerType;
- (NSTimeInterval)requestTimeoutInterval; //每个请求的超时时间
- (NSTimeInterval)cacheInVaild;//缓存有效期
- (NSDictionary *)headerFieldValueDictionary;

@end


@protocol XXXRequestDataReformer <NSObject>

/**
 格式化返回结果协议方法
 */
@required
- (id)request:(XXXRequest *)request reformData:(NSDictionary *)data;

@end

@interface XXXRequest : XXXBaseRequest<XXXRequestDelegate>

@property (strong, nonatomic) NSURLSessionDataTask *requestDataTask; //该请求的requestTask对象
@property (assign, nonatomic) BOOL ignoreCache; //忽略缓存
@property (assign, nonatomic) NSInteger timedOutCount; //超时次数
@property (copy, nonatomic) XXCallbackWithRequestBlock completionBlock;

@property (nonatomic) id fetchedRawData;
@property (nonatomic, strong) NSData *responseObject;
@property (nonatomic, strong) NSError *error;

- (instancetype)initWithRequestParams:(id)requestParams;
- (void)start;
- (id)fetchDataWithReformer:(id<XXXRequestDataReformer>)reformer;


@end
