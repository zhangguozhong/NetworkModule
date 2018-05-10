//
//  NetworkModuleManager.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "XXNetworkClient.h"
#import "XXAPIClient.h"
#import "XXAppContext.h"
#import <pthread/pthread.h>
#import "XXXRequestConfiguration.h"

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

@interface XXNetworkClient() {
    pthread_mutex_t _lock;
}

@property (strong, nonatomic) NSMutableDictionary *requestTaskRecords;
@end

@implementation XXNetworkClient

+ (XXNetworkClient *)sharedInstance {
    static XXNetworkClient *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
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

 @param request 请求对象包含请求的方法、参数等
 */
- (void)startRequest:(XXXRequest *)request completion:(void (^)(id, NSError *))completion {
    NSString *requestMethod = [request requestMethod];
    NSDictionary *requestParams = [request requestParams];
    NSString *requestUrl = [self buildRequestUrl:request];
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerWithRequestObject:request];
    
    request.requestDataTask = [self dataTaskWithHTTPMethod:requestMethod requestUrl:requestUrl  parameters:requestParams requestSerializer:requestSerializer completion:completion];
    Lock();
    [self.requestTaskRecords setObject:request forKey:@(request.requestDataTask.taskIdentifier)];
    Unlock();
    [request.requestDataTask resume];
}


/**
 创建requestSerializer对象

 @param request 请求对象XXXRequest
 @return requestSerializer对象
 */
- (AFHTTPRequestSerializer *)requestSerializerWithRequestObject:(XXXRequest *)request {
    AFHTTPRequestSerializer *requestSerializer;
    if (request.requestSerializerType == RequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    else if (request.requestSerializerType == RequestSerializerTypeHTTP) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    requestSerializer.timeoutInterval = [request requestTimeoutInterval]; //请求超时时间
    NSDictionary *headerFieldValueDictionary = [request headerFieldValueDictionary] ?: [XXAppContext appContext].headerFieldValueDictionary;
    // 加入请求头
    if (headerFieldValueDictionary) {
        [headerFieldValueDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull objValue, BOOL * _Nonnull stop) {
            if ([key isKindOfClass:NSString.class] && [objValue isKindOfClass:NSString.class]) {
                [requestSerializer setValue:objValue forHTTPHeaderField:key];
            }
        }];
    }
    // 是否登录
    if ([XXAppContext appContext].accessToken) {
        [requestSerializer setValue:[XXAppContext appContext].accessToken forHTTPHeaderField:@"accessToken"];
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
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method requestUrl:(NSString *)requestUrl parameters:(NSDictionary *)parameters requestSerializer:(AFHTTPRequestSerializer *)requestSerializer completion:(void (^)(id, NSError *))completion {
    __block NSURLSessionDataTask *requestDataTask = nil;
    NSURLRequest *request = [requestSerializer requestWithMethod:method URLString:requestUrl parameters:parameters error:nil];
    requestDataTask = [[XXAPIClient httpClient] dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                       {
                           [self handleRequestResult:requestDataTask responseObject:responseObject error:error completion:completion];
                       }];
    
    return requestDataTask;
}


/**
 处理网络请求返回数据，并触发回调

 @param requestDataTask 网络请求任务对象
 @param responseObject 返回的数据对象
 @param error 网络错误信息
 */
- (void)handleRequestResult:(NSURLSessionDataTask *)requestDataTask responseObject:(id)responseObject error:(NSError *)error completion:(void (^)(id, NSError *))completion {
    Lock();
    XXXRequest *request = [self.requestTaskRecords objectForKey:@(requestDataTask.taskIdentifier)];
    if (error) {
        [self resumeRequest:request withErrorCode:error.code];
    }
    
    Unlock();
    
    id fetchedRawData = [self processResponseData:responseObject];
    if (!error){
        if (completion) {
            completion(fetchedRawData, nil);
        }
    }
    else{
        if (completion) {
            completion(fetchedRawData, error);
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cancelNetworkTask:request];
    });
}


/**
 网络请求重连（3次）

 @param request 请求对象
 @param errorCode 错误码NSURLErrorUnknown、NSURLErrorTimedOut以及NSURLErrorCannotConnectToHost
 */
- (void)resumeRequest:(XXXRequest *)request withErrorCode:(NSInteger)errorCode {
    if (errorCode == NSURLErrorUnknown || errorCode == NSURLErrorTimedOut || errorCode == NSURLErrorCannotConnectToHost) {
        // 超时重连
        request.timedOutCount++;
        if (request.timedOutCount < XXRequestTimedOutCount) {
            [request.requestDataTask resume];
        }
    }
}


/**
 返回json对象或者是字符串对象

 @param responseObject 接口回调结果responseObject
 @return 格式化返回结果
 */
- (id)processResponseData:(id)responseObject {
    id fetchedRawData;
    if ([responseObject isKindOfClass:NSString.class]) {
        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        fetchedRawData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (error) {
            fetchedRawData = responseObject;
        }
    }else if ([responseObject isKindOfClass:NSData.class]) {
        NSError *error;
        fetchedRawData = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if (error) {
            fetchedRawData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }
    }else {
        fetchedRawData = responseObject;
    }
    return fetchedRawData;
}


/**
 生成请求url字符串

 @param request 封装好的请求对象
 @return 返回请求的url字符串
 */
- (NSString *)buildRequestUrl:(XXXRequest *)request {
    NSString *requestUrl = [request requestUrl];
    NSURL *tempUrl = [NSURL URLWithString:requestUrl];
    if (tempUrl && tempUrl.scheme && tempUrl.host) {
        return requestUrl;
    }
    
    NSString *domainUrl;
    if ([request respondsToSelector:@selector(baseUrl)] && [request baseUrl]) {
        domainUrl = [request baseUrl];
    } else {
        domainUrl = [XXAppContext appContext].domain;
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

 @param requests 所有封装过的请求对象包含请求的方法、参数等
 */
- (void)cancelNetworkTasks:(NSArray<XXXRequest*> *)requests {
    if (requests) {
        [requests enumerateObjectsUsingBlock:^(XXXRequest * _Nonnull request, NSUInteger idx, BOOL * _Nonnull stop) {
            [self cancelNetworkTask:request];
        }];
    }
}


/**
 取消指定的网络请求任务

 @param request 封装过的请求对象包含请求的方法、参数等
 */
- (void)cancelNetworkTask:(XXXRequest *)request {
    Lock();
    [request.requestDataTask cancel];
    request.paramsDelegate = nil;
    [self.requestTaskRecords removeObjectForKey:@(request.requestDataTask.taskIdentifier)];
    Unlock();
}
@end
