//
//  NetworkModuleManager.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface RequestTaskHandler : NSObject

+ (RequestTaskHandler *)taskHandler;

/**
 取消指定的网络请求任务
 
 @param baseRequest 封装过的请求对象包含请求的方法、参数等
 */
- (void)cancelNetworkTask:(BaseRequest *)baseRequest;

/**
 取消所有网络请求任务
 
 @param baseRequests 所有封装过的请求对象包含请求的方法、参数等
 */
- (void)cancelNetworkTasks:(NSArray <BaseRequest *> *)baseRequests;

/**
 执行网络请求
 
 @param baseRequest 请求对象包含请求的方法、参数等
 */
- (void)startWithRequestObject:(BaseRequest *)baseRequest onCompleteBlock:(void(^)(id result, NSError *error))onCompleteBlock;

@end
