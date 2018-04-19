//
//  NetworkRequestObject.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "XXXRequest.h"
#import "XXNetworkClient.h"
#import "XXAppContext.h"
#import "NSString+XXXRequest.h"
#import "XXNetworkCacheMananger.h"

@interface XXXRequest ()

@property (nonatomic, strong, readwrite) id fetchedRawData;

@end

@implementation XXXRequest

- (NSString *)requestMethod{
    return @"GET";
}

- (NSUInteger)requestSerializerType {
    return RequestSerializerTypeJSON;
}

// 配置请求参数
- (id)requestParams {
    if ([self.paramsDelegate respondsToSelector:@selector(paramsWithRequest:)]) {
        return [self.paramsDelegate paramsWithRequest:self];
    }
    return nil;
}

// 接口地址，可以配置完整的地址
- (NSString *)requestUrl {
    return @"react-native/movies.json";
}

- (NSString *)baseUrl {
    return nil;
}

- (NSTimeInterval)requestTimeoutInterval {
    return 10;
}

/**
 设置请求头
 */
- (NSDictionary *)headerFieldValueDictionary {
    return nil;
}

// 获取数据
- (id)fetchDataWithReformer:(id<XXXRequestDataReformer>)reformer {
    if ([reformer respondsToSelector:@selector(request:reformData:)]) {
        return [reformer request:self reformData:[self.fetchedRawData copy]];
    }else{
        return [self.fetchedRawData copy];
    }
}


/**
 发起请求
 */
- (void)startWithBlock:(XXCallbackWithRequestBlock)callbackWithRequestBlock
{
    // 生成缓存key
    NSString *baseUrl = self.baseUrl ?: [XXAppContext appContext].domain;
    NSString *cacheKey = [NSString stringWithFormat:@"Method:%@ Host:%@ Url:%@ requestParams:%@", [self requestMethod], baseUrl, [self requestUrl], [self requestParams]].stringToSignature;
    
    // 读取缓存
    XXCallbackBlock callbackBlock = [self callbackBlock:callbackWithRequestBlock withKey:cacheKey];
    NSData *cacheData = [[XXNetworkCacheMananger sharedInstance] fetchCachedDataWithKey:cacheKey];
    if (!cacheData || self.ignoreCache) {
        [self startWithCompletionBlock:callbackBlock];
        return;
    }
    
    // 命中缓存，直接回调
    NSError *error;
    id cacheDictionary = [NSJSONSerialization JSONObjectWithData:cacheData options:kNilOptions error:&error];
    if (error) {
        [self startWithCompletionBlock:callbackBlock];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.fetchedRawData = cacheDictionary;
            if (callbackWithRequestBlock) {
                callbackWithRequestBlock(self, error);
            }
        });
    }
}


/**
 生成回调block

 @param callbackWithRequestBlock XXCallbackWithRequestBlock
 @param cacheKey 缓存的key
 @return XXCallbackBlock
 */
- (XXCallbackBlock)callbackBlock:(XXCallbackWithRequestBlock)callbackWithRequestBlock withKey:(NSString *)cacheKey {
    XXCallbackBlock callbackBlock = ^(id responseObject, NSError *error) {
        self.fetchedRawData = responseObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callbackWithRequestBlock) {
                callbackWithRequestBlock(self, error);
            }
        });
        
        NSError *jsonError;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:kNilOptions error:&jsonError];
        if (!jsonError && !error) {
            [[XXNetworkCacheMananger sharedInstance] saveCacheWithData:jsonData key:cacheKey];
        }
    };
    return callbackBlock;
}


/**
 发起请求（没有缓存）
 */
- (void)startWithCompletionBlock:(XXCallbackBlock)callbackBlock {
    [[XXNetworkClient sharedInstance] startRequest:self completion:callbackBlock];
}

- (void)dealloc {
    [[XXNetworkClient sharedInstance] cancelNetworkTask:self];
}


@end
