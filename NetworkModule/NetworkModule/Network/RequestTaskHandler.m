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

 @param baseRequest 请求对象包含请求的方法、参数等
 */
- (void)startWithRequestObject:(BaseRequest *)baseRequest onCompleteBlock:(void (^)(id, NSError *))onCompleteBlock {
    NSString *requestMethod = [baseRequest requestMethod];
    NSDictionary *requestParams = [baseRequest requestParams];
    NSString *requestUrl = [self buildRequestUrl:baseRequest];
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerWithRequestObject:baseRequest];
    
    baseRequest.requestDataTask = [self dataTaskWithHTTPMethod:requestMethod requestUrl:requestUrl  parameters:requestParams requestSerializer:requestSerializer onCompleteBlock:onCompleteBlock];
    Lock();
    [self.requestTaskRecords setObject:baseRequest forKey:@(baseRequest.requestDataTask.taskIdentifier)];
    Unlock();
    [baseRequest.requestDataTask resume];
}


/**
 创建requestSerializer对象

 @param baseRequest 请求对象requestObject
 @return requestSerializer对象
 */
- (AFHTTPRequestSerializer *)requestSerializerWithRequestObject:(BaseRequest *)baseRequest {
    AFHTTPRequestSerializer *requestSerializer;
    if (baseRequest.requestSerializerType == RequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    else if (baseRequest.requestSerializerType == RequestSerializerTypeHTTP) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    requestSerializer.timeoutInterval = [baseRequest requestTimeoutInterval]; // 请求超时时间
    NSDictionary *headerFieldValueDictionary = [baseRequest headerFieldValueDictionary] ?: [AppContext appContext].headerFieldValueDictionary;
    // 加入请求头
    if (headerFieldValueDictionary) {
        [headerFieldValueDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull objValue, BOOL * _Nonnull stop) {
            if ([key isKindOfClass:NSString.class] && [objValue isKindOfClass:NSString.class]) {
                [requestSerializer setValue:objValue forHTTPHeaderField:key];
            }
        }];
    }
    
    return requestSerializer;
}


/**
 根据请求方法、参数等创建网络请求任务

 @param method 请求方法（POST、GET等）
 @param parameters 请求参数
 @param requestSerializer 用于生成request对象
 @return 返回NSURLSessionDataTask对象
 */
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method requestUrl:(NSString *)requestUrl parameters:(NSDictionary *)parameters requestSerializer:(AFHTTPRequestSerializer *)requestSerializer onCompleteBlock:(void (^)(id, NSError *))onCompleteBlock {
    __block NSURLSessionDataTask *requestDataTask = nil;
    NSURLRequest *request = [requestSerializer requestWithMethod:method URLString:requestUrl parameters:parameters error:nil];
    requestDataTask = [[APIClient httpClient] dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                       {
                           [self handleRequestResult:requestDataTask responseObject:responseObject error:error onCompleteBlock:onCompleteBlock];
                       }];
    
    return requestDataTask;
}


/**
 处理网络请求返回数据，并触发回调

 @param requestDataTask 网络请求任务对象
 @param responseObject 返回的数据对象
 @param error 网络错误信息
 */
- (void)handleRequestResult:(NSURLSessionDataTask *)requestDataTask responseObject:(id)responseObject error:(NSError *)error onCompleteBlock:(void (^)(id, NSError *))onCompleteBlock {
    Lock();
    BaseRequest *baseRequest = [self.requestTaskRecords objectForKey:@(requestDataTask.taskIdentifier)];
    id fetchResultData = [self handleResponseObject:responseObject];
    Unlock();
    
    if (!error){
        if (onCompleteBlock) {
            onCompleteBlock(fetchResultData,nil);
        }
        @autoreleasepool {
            [baseRequest requestCompletionPreprocessor];
        }
    }
    else{
        if (onCompleteBlock) {
            onCompleteBlock(fetchResultData,error);
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cancelNetworkTask:baseRequest];
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

 @param baseRequest 封装好的请求对象
 @return 返回请求的url字符串
 */
- (NSString *)buildRequestUrl:(BaseRequest *)baseRequest {
    NSString *requestUrl = [baseRequest requestUrl];
    NSURL *tempUrl = [NSURL URLWithString:requestUrl];
    if (tempUrl && tempUrl.scheme && tempUrl.host) {
        return requestUrl;
    }
    
    NSString *domainUrl;
    if ([baseRequest respondsToSelector:@selector(baseUrl)] && [baseRequest baseUrl]) {
        domainUrl = [baseRequest baseUrl];
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

 @param baseRequests 所有封装过的请求对象包含请求的方法、参数等
 */
- (void)cancelNetworkTasks:(NSArray<BaseRequest*> *)baseRequests {
    if (baseRequests && baseRequests.count > 0) {
        [baseRequests enumerateObjectsUsingBlock:^(BaseRequest * _Nonnull baseRequest, NSUInteger idx, BOOL * _Nonnull stop) {
            [self cancelNetworkTask:baseRequest];
        }];
    }
}


/**
 取消指定的网络请求任务

 @param baseRequest 封装过的请求对象包含请求的方法、参数等
 */
- (void)cancelNetworkTask:(BaseRequest *)baseRequest {
    Lock();
    [baseRequest.requestDataTask cancel];
    baseRequest.paramsDelegate = nil;
    [self.requestTaskRecords removeObjectForKey:@(baseRequest.requestDataTask.taskIdentifier)];
    Unlock();
}
@end
