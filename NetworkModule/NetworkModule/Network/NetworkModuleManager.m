//
//  NetworkModuleManager.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "NetworkModuleManager.h"
#import "NetworkClient.h"
#import "NetworkConfig.h"
#import <pthread/pthread.h>

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

@interface NetworkModuleManager(){
    pthread_mutex_t _lock;
}
@property (strong, nonatomic) NSMutableDictionary *dispatchTable;
@end

@implementation NetworkModuleManager

+ (NetworkModuleManager *)networkTaskSender {
    static NetworkModuleManager *networkTaskSender;
    static dispatch_once_t senderOnceToken;
    dispatch_once(&senderOnceToken, ^{
        networkTaskSender = [[self alloc] init];
    });
    return networkTaskSender;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}


/**
 发起一个网络请求

 @param requestObject 请求对象包含请求的方法、参数等
 */
- (void)doNetworkTaskWithRequestObject:(NetworkRequestObject *)requestObject {
    NSString *strMethod = [requestObject method];
    NSDictionary *requestParams = [requestObject requestParams];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    requestObject.requestDataTask = [self dataTaskWithHTTPMethod:strMethod parameters:requestParams requestSerializer:requestSerializer];
    Lock();
    [self.dispatchTable setObject:requestObject forKey:@(requestObject.requestDataTask.taskIdentifier)];
    Unlock();
    [requestObject.requestDataTask resume];
}


/**
 根据请求方法、参数等创建网络请求任务

 @param method 请求方法（POST、GET等）
 @param parameters 请求参数
 @param requestSerializer 用于生成request对象
 @return 返回NSURLSessionDataTask对象
 */
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method parameters:(NSDictionary *)parameters requestSerializer:(AFHTTPRequestSerializer *)requestSerializer {
    __block NSURLSessionDataTask *requestDataTask = nil;
    NSString *urlString = [NetworkConfig shareConfig].domain;
    
    NSURLRequest *request = [requestSerializer requestWithMethod:method URLString:urlString parameters:parameters error:nil];
    requestDataTask = [[NetworkClient networkClient] dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                       {
                           [self handleRequestResult:requestDataTask responseObject:responseObject error:error];
                       }];
    
    return requestDataTask;
}


/**
 处理网络请求返回数据，并触发回调

 @param requestDataTask 网络请求任务对象
 @param responseObject 返回的数据对象
 @param error 网络错误信息
 */
- (void)handleRequestResult:(NSURLSessionDataTask *)requestDataTask responseObject:(id)responseObject error:(NSError *)error {
    //处理回调，比如session过期，需要重新登录，可以发出已退出登录的通知，然后方便处理。
    Lock();
    NetworkRequestObject *requestObject = [self.dispatchTable objectForKey:@(requestDataTask.taskIdentifier)];
    Unlock();
    
    if (error && requestObject.failBlock) {
        requestObject.failBlock(error);
    }else{
        if (requestObject.successBlock) {
            if ([responseObject isKindOfClass:[NSData class]]) {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            }
            requestObject.successBlock(responseObject);
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cancelNetworkTask:requestObject];
    });
}


/**
 用于保存所有创建的网络请求任务

 @return 字典对象
 */
- (NSMutableDictionary *)dispatchTable {
    if (!_dispatchTable) {
        NSMutableDictionary *dispatchTable = [NSMutableDictionary dictionary];
        _dispatchTable = dispatchTable;
    }
    return _dispatchTable;
}


/**
 取消所有网络请求任务

 @param requestObjects 所有封装过的请求对象包含请求的方法、参数等
 */
- (void)cancelNetworkTasks:(NSArray<NetworkRequestObject *> *)requestObjects {
    if (requestObjects && requestObjects.count>0) {
        [requestObjects enumerateObjectsUsingBlock:^(NetworkRequestObject * _Nonnull requestObject, NSUInteger idx, BOOL * _Nonnull stop) {
            [self cancelNetworkTask:requestObject];
        }];
    }
}


/**
 取消指定的网络请求任务

 @param requestObject 封装过的请求对象包含请求的方法、参数等
 */
- (void)cancelNetworkTask:(NetworkRequestObject *)requestObject {
    Lock();
    [requestObject.requestDataTask cancel];
    [self.dispatchTable removeObjectForKey:@(requestObject.requestDataTask.taskIdentifier)];
    Unlock();
}

@end
