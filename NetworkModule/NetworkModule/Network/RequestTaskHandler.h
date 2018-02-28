//
//  NetworkModuleManager.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequestObject.h"

@interface RequestTaskHandler : NSObject

+ (RequestTaskHandler *)taskHandler;

/**
 取消指定的网络请求任务
 
 @param requestObject 封装过的请求对象包含请求的方法、参数等
 */
- (void)cancelNetworkTask:(NetworkRequestObject *)requestObject;

/**
 取消所有网络请求任务
 
 @param requestObjects 所有封装过的请求对象包含请求的方法、参数等
 */
- (void)cancelNetworkTasks:(NSArray <NetworkRequestObject *> *)requestObjects;

/**
 执行网络请求
 
 @param requestObject 请求对象包含请求的方法、参数等
 */
- (void)doNetworkTaskWithRequestObject:(NetworkRequestObject *)requestObject;

@end
