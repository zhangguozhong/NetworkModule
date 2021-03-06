//
//  NetworkModuleManager.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXXRequest.h"

@interface XXNetworkClient : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

+ (XXNetworkClient *)sharedInstance;

/**
 取消指定的网络请求任务
 
 @param request 封装过的请求对象包含请求的方法、参数等
 */
- (void)cancelNetworkTask:(XXXRequest *)request;

/**
 取消所有网络请求任务
 
 @param requests 所有封装过的请求对象包含请求的方法、参数等
 */
- (void)cancelNetworkTasks:(NSArray<XXXRequest *> *)requests;

/**
 执行网络请求
 
 @param request 请求对象包含请求的方法、参数等
 */
- (void)startRequest:(XXXRequest *)request;

@end
