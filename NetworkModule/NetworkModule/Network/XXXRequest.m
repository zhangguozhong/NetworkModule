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

@property (nonatomic, copy) NSString *cacheKey;

@end

@implementation XXXRequest

- (NSString *)requestMethod{
    return @"GET";
}
- (NSUInteger)requestSerializerType {
    return RequestSerializerTypeJSON;
}
- (NSUInteger)responseSerializerType {
    return ResponseSerializerTypeJSON;
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

// 获取数据
- (id)fetchDataWithReformer:(id<XXXRequestDataReformer>)reformer {
    if ([reformer respondsToSelector:@selector(request:reformData:)]) {
        return [reformer request:self reformData:[self.fetchedRawData copy]];
    }else {
        return [self.fetchedRawData copy];
    }
}


/**
 发起请求
 */
- (void)start {
    //读取缓存
    NSData *cacheData = [[XXNetworkCacheMananger sharedInstance] fetchCachedDataWithKey:self.cacheKey];
    if (!cacheData || self.ignoreCache) {
        [self startRequest];
        return;
    }
    
    NSError *serializerError = nil;
    id fetchedRawData = [NSJSONSerialization JSONObjectWithData:cacheData options:kNilOptions error:&serializerError];
    if (serializerError) {
        [self startRequest];
        return;
    }
    
    self.fetchedRawData = fetchedRawData;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.completionBlock) {
            self.completionBlock(serializerError);
        }
    });
    //更新缓存
    [[XXNetworkCacheMananger sharedInstance] saveCacheWithData:cacheData key:self.cacheKey];
}


/**
 保存缓存
 */
- (void)requestCompletePreprocessor {
    if (self.responseObject && [self.responseObject isKindOfClass:NSData.class]) {
        [[XXNetworkCacheMananger sharedInstance] saveCacheWithData:self.responseObject key:self.cacheKey];
    }
}

- (NSString *)cacheKey {
    if (!_cacheKey) {
        _cacheKey = [NSString stringWithFormat:@"Method:%@ Host:%@ Url:%@ requestParams:%@", [self requestMethod], self.baseUrl ?: [XXAppContext appContext].domain, [self requestUrl], [self requestParams]].stringToSignature;
    }
    return _cacheKey;
}


/**
 发起请求（没有缓存）
 */
- (void)startRequest {
    [[XXNetworkClient sharedInstance] startRequest:self];
}

- (void)dealloc {
    [[XXNetworkClient sharedInstance] cancelNetworkTask:self];
}

@end
