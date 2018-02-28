//
//  NetworkRequestObject.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequestProtocol.h"
@class NetworkRequestObject;

typedef NS_OPTIONS(NSUInteger, RequestSerializerType) {
    RequestSerializerTypeHTTP = 0,
    RequestSerializerTypeJSON
};

@protocol RequestTaskParamsDelegate<NSObject>

/**
 配置参数方法

 @param requestObject 请求对象
 @return 所配置的参数
 */
- (id)requestTaskParamsWithRequestObject:(NetworkRequestObject *)requestObject;

@end

typedef void(^CompletionBlock)(NetworkRequestObject *requestObject);
typedef void(^HasErrorBlock)(NetworkRequestObject *requestObject);

@interface NetworkRequestObject : NSObject<NetworkRequestProtocol>

/**
 保存网络请求成功的结果
 */
@property (nonatomic) id responseObject;
@property (strong, nonatomic) NSError *error;

@property (strong,nonatomic) NSURLSessionDataTask *requestDataTask;

/**
 配置参数委托对象
 */
@property (nonatomic,weak) id<RequestTaskParamsDelegate> requestParamsDelegate;

@property (copy,nonatomic,readonly) CompletionBlock completionBlock;
@property (copy,nonatomic,readonly) HasErrorBlock hasErrorBlock;


/**
 配置网络回调事件

 @param completionBlock 请求成功block回调
 @param hasErrorBlock 请求失败block回调
 */
- (void)setCompletionBlock:(CompletionBlock)completionBlock andHasErrorBlock:(HasErrorBlock)hasErrorBlock;

- (void)cleanBlocks;
- (void)taskStart;


@end
