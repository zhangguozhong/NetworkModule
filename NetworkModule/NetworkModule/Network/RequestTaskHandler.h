//
//  NetworkModuleManager.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"

@interface RequestTaskHandler : NSObject

+ (RequestTaskHandler *)taskHandler;

/**
 取消指定的网络请求任务
 
 @param requestObject 封装过的请求对象包含请求的方法、参数等
 */
- (void)cancelNetworkTask:(BaseRequestObject *)requestObject;

/**
 取消所有网络请求任务
 
 @param requestObjects 所有封装过的请求对象包含请求的方法、参数等
 */
- (void)cancelNetworkTasks:(NSArray <BaseRequestObject *> *)requestObjects;

/**
 执行网络请求
 
 @param requestObject 请求对象包含请求的方法、参数等
 */
- (void)startWithRequestObject:(BaseRequestObject *)requestObject;

@end
