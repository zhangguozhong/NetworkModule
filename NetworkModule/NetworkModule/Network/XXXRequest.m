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
#import "XXXCacheFilesManager.h"
#import "XXXCacheMetadata.h"

@interface XXXRequest() {
    XXXCacheMetadata *_cacheMetadata;
}
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
- (NSString *)apiVersion{
    return @"1";
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
- (NSTimeInterval)cacheInVaild {
    return 30;
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
 开始请求
 */
- (void)start{
    //读取缓存
    NSData *data = [self getCacheForName:self.cacheKey];
    if (!data || self.ignoreCache) {
        [self startRequest];
        return;
    }
    
    NSError *serializerError = nil;
    id fetchedRawData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&serializerError];
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
}


/**
 保存缓存
 */
- (void)requestCompletePreprocessor {
    if (self.cacheInVaild > 0 && self.responseObject) {
        @try{
            [[XXXCacheFilesManager cacheManager] generateCacheObject:self.responseObject aName:self.cacheKey];
            
            XXXCacheMetadata *cacheMetadata = [[XXXCacheMetadata alloc] init];
            cacheMetadata.apiVersion = self.apiVersion;
            cacheMetadata.appVersion = [XXAppContext appContext].appVersion;
            cacheMetadata.cacheCreateTime = [NSDate date];
            
            [[XXXCacheFilesManager cacheManager] generateMetadataObject:cacheMetadata aName:self.cacheKey];
        }@catch(NSException *exception) {
            NSLog(@"Save cache failed, reason = %@",exception.reason);
        }
    }
}


/**
 缓存文件名

 @return _cacheKey
 */
- (NSString *)cacheKey {
    if (!_cacheKey) {
        _cacheKey = [NSString stringWithFormat:@"Method:%@ Host:%@ Url:%@ requestParams:%@", [self requestMethod], self.baseUrl ?: [XXAppContext appContext].domain, [self requestUrl], [self requestParams]].stringToSignature;
    }
    return _cacheKey;
}


/**
 获取缓存

 @param aName 缓存文件名
 @return data
 */
- (NSData *)getCacheForName:(NSString *)aName {
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filesDirectory = [XXAppContext appContext].cacheFileDirectory ?: XXXCacheFilesDirectory;
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:filesDirectory];
    
    NSString *metadata = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.metadata",aName]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:metadata isDirectory:nil]) {
        return nil;
    }
    
    @try{
        _cacheMetadata = [NSKeyedUnarchiver unarchiveObjectWithFile:metadata];
    } @catch(NSException *exception){
        NSLog(@"Load cache metadata failed, reason = %@",exception.reason);
    }
    
    if ([self isCacheVaild:_cacheMetadata]) {
        NSString *cache = [cacheDirectory stringByAppendingPathComponent:aName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:cache isDirectory:nil]) {
            NSData *data = [NSData dataWithContentsOfFile:cache];
            if (data) {
                return data;
            }
        }
    }
    
    return nil;
}


/**
 判断缓存是否有效（同一api版本、app版本以及在有效的缓存时间区间内，则判断缓存有效）

 @param cacheMetadata 缓存配置文件
 @return YES OR NO
 */
- (BOOL)isCacheVaild:(XXXCacheMetadata *)cacheMetadata {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:cacheMetadata.cacheCreateTime];
    return cacheMetadata && [cacheMetadata.apiVersion isEqualToString:self.apiVersion] && [cacheMetadata.appVersion isEqualToString:[XXAppContext appContext].appVersion] && (timeInterval < self.cacheInVaild);
}


/**
 发起请求
 */
- (void)startRequest {
    [[XXNetworkClient sharedInstance] startRequest:self];
}


/**
 移除请求
 */
- (void)dealloc {
    [[XXNetworkClient sharedInstance] cancelNetworkTask:self];
}

@end
