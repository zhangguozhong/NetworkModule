//
//  NetworkRequestObject.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NetworkRequestObject;

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

@end

@protocol RequestParametersDelegate <NSObject>

/**
 配置参数方法

 @param requestObject 请求对象
 @return 所配置的参数
 */
- (id)requestParamsWithRequestObject:(NetworkRequestObject *)requestObject;

@end

typedef void(^CompletionBlock)(NetworkRequestObject *requestObject);
typedef void(^HasErrorBlock)(NetworkRequestObject *requestObject);

@interface NetworkRequestObject : NSObject<RequestObjectDelegate>

/**
 接口返回数据
 */
@property (nonatomic) id responseObject;
@property (strong, nonatomic) NSError *error;

@property (strong,nonatomic) NSURLSessionDataTask *requestDataTask;

@property (copy,nonatomic,readonly) CompletionBlock completionBlock;
@property (copy,nonatomic,readonly) HasErrorBlock hasErrorBlock;


/**
 配置参数委托对象
 */
@property (weak,nonatomic) id<RequestParametersDelegate> paramsDelegate;


/**
 配置网络回调事件

 @param completionBlock 请求成功block回调
 @param hasErrorBlock 请求失败block回调
 */
- (void)setCompletionBlock:(CompletionBlock)completionBlock andHasErrorBlock:(HasErrorBlock)hasErrorBlock;


/**
 开始网络请求

 @param completionBlock 请求成功block回调
 @param hasErrorBlock 请求失败block回调
 */
- (void)startWithCompletionBlock:(CompletionBlock)completionBlock andHasErrorBlock:(HasErrorBlock)hasErrorBlock;

- (void)cleanBlocks;
- (void)taskStart;


@end
