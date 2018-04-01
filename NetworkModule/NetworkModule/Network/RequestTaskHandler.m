//
//  NetworkModuleManager.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "RequestTaskHandler.h"
#import "APIClient.h"
#import "AppContext.h"
#import <pthread/pthread.h>

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

@interface RequestTaskHandler(){
    pthread_mutex_t _lock;
}
@property (strong, nonatomic) NSMutableDictionary *requestTaskRecords;
@end

@implementation RequestTaskHandler

+ (RequestTaskHandler *)taskHandler {
    static RequestTaskHandler *taskHandler;
    static dispatch_once_t taskOnceToken;
    dispatch_once(&taskOnceToken, ^{
        taskHandler = [[self alloc] init];
    });
    return taskHandler;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}


/**
 执行网络请求

 @param requestObject 请求对象包含请求的方法、参数等
 */
- (void)doNetworkTaskWithRequestObject:(BaseRequestObject *)requestObject {
    NSString *requestMethod = [requestObject requestMethod];
    NSDictionary *requestParams = [requestObject requestParams];
    NSString *requestUrl = [self buildRequestUrl:requestObject];
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerWithRequestObject:requestObject];
    
    requestObject.requestDataTask = [self dataTaskWithHTTPMethod:requestMethod requestUrl:requestUrl  parameters:requestParams requestSerializer:requestSerializer];
    Lock();
    [self.requestTaskRecords setObject:requestObject forKey:@(requestObject.requestDataTask.taskIdentifier)];
    Unlock();
    [requestObject.requestDataTask resume];
}


/**
 创建requestSerializer对象

 @param requestObject 请求对象requestObject
 @return requestSerializer对象
 */
- (AFHTTPRequestSerializer *)requestSerializerWithRequestObject:(BaseRequestObject *)requestObject {
    AFHTTPRequestSerializer *requestSerializer;
    if (requestObject.requestSerializerType == RequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    else if (requestObject.requestSerializerType == RequestSerializerTypeHTTP) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    requestSerializer.timeoutInterval = [requestObject requestTimeoutInterval];
    return requestSerializer;
}


/**
 根据请求方法、参数等创建网络请求任务

 @param method 请求方法（POST、GET等）
 @param parameters 请求参数
 @param requestSerializer 用于生成request对象
 @return 返回NSURLSessionDataTask对象
 */
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method requestUrl:(NSString *)requestUrl parameters:(NSDictionary *)parameters requestSerializer:(AFHTTPRequestSerializer *)requestSerializer {
    __block NSURLSessionDataTask *requestDataTask = nil;
    NSURLRequest *request = [requestSerializer requestWithMethod:method URLString:requestUrl parameters:parameters error:nil];
    requestDataTask = [[APIClient httpClient] dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
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
    Lock();
    BaseRequestObject *requestObject = [self.requestTaskRecords objectForKey:@(requestDataTask.taskIdentifier)];
    Unlock();
    requestObject.responseObject = [self handleResponseObject:responseObject];
    requestObject.error = error;
    
    if (error) {
        if ([NSThread isMainThread]) {
            if (requestObject.hasErrorBlock) {
                requestObject.hasErrorBlock(requestObject);
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (requestObject.hasErrorBlock) {
                    requestObject.hasErrorBlock(requestObject);
                }
            });
        }
    }else {
        @autoreleasepool {
            [requestObject requestCompletionPreprocessor];
        }
        if ([NSThread isMainThread]) {
            if (requestObject.completionBlock) {
                requestObject.completionBlock(requestObject);
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (requestObject.completionBlock) {
                    requestObject.completionBlock(requestObject);
                }
            });
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self cancelNetworkTask:requestObject];
    });
}


/**
 格式化返回结果

 @param responseObject 返回结果
 @return 格式化返回结果
 */
- (id)handleResponseObject:(id)responseObject {
    id resultObject = responseObject;
    if ([responseObject isKindOfClass:[NSData class]]) {
        NSError *error;
        resultObject = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if (error) {
            resultObject = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }
    }else if ([responseObject isKindOfClass:[NSString class]]) {
        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        resultObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (error) {
            resultObject = responseObject;
        }
    }
    
    return resultObject;
}


/**
 生成请求url字符串

 @param requestObject 封装好的请求对象
 @return 返回请求的url字符串
 */
- (NSString *)buildRequestUrl:(BaseRequestObject *)requestObject {
    NSString *requestUrl = [requestObject requestUrl];
    NSURL *tempUrl = [NSURL URLWithString:requestUrl];
    if (tempUrl && tempUrl.scheme && tempUrl.host) {
        return requestUrl;
    }
    
    NSString *domainUrl;
    if ([requestObject respondsToSelector:@selector(baseUrl)] && [requestObject baseUrl]) {
        domainUrl = [requestObject baseUrl];
    } else {
        domainUrl = [AppContext appContext].domain;
    }
    
    tempUrl = [NSURL URLWithString:domainUrl];
    if (domainUrl.length > 0 && ![domainUrl hasPrefix:@"/"]) {
        tempUrl = [tempUrl URLByAppendingPathComponent:@""];
    }
    
    return [NSURL URLWithString:requestUrl relativeToURL:tempUrl].absoluteString;
}


/**
 用于保存所有创建的网络请求任务

 @return 字典对象
 */
- (NSMutableDictionary *)requestTaskRecords {
    if (!_requestTaskRecords) {
        NSMutableDictionary *requestTaskRecords = [NSMutableDictionary dictionary];
        _requestTaskRecords = requestTaskRecords;
    }
    return _requestTaskRecords;
}


/**
 取消所有网络请求任务

 @param requestObjects 所有封装过的请求对象包含请求的方法、参数等
 */
- (void)cancelNetworkTasks:(NSArray<BaseRequestObject *> *)requestObjects {
    if (requestObjects && requestObjects.count > 0) {
        [requestObjects enumerateObjectsUsingBlock:^(BaseRequestObject * _Nonnull requestObject, NSUInteger idx, BOOL * _Nonnull stop) {
            [self cancelNetworkTask:requestObject];
        }];
    }
}


/**
 取消指定的网络请求任务

 @param requestObject 封装过的请求对象包含请求的方法、参数等
 */
- (void)cancelNetworkTask:(BaseRequestObject *)requestObject {
    Lock();
    [requestObject.requestDataTask cancel];
    [requestObject cleanBlocks];
    [self.requestTaskRecords removeObjectForKey:@(requestObject.requestDataTask.taskIdentifier)];
    Unlock();
}
@end
