//
//  NetworkRequestObject.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "XXXRequest.h"
#import "XXNetworkClient.h"
#import "XXXCacheFilesManager.h"
#import "XXXCacheMetadata.h"
#import "XXXNetworkUtils.h"
#import "XXXRequestConfiguration.h"

@interface XXXRequest() {
    XXXCacheMetadata *_cacheMetadata;
    id _requestParams;
}
@end

@implementation XXXRequest

- (instancetype)initWithRequestParams:(id)requestParams {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _requestParams = requestParams;
    return self;
}

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
- (NSDictionary *)headerFieldValueDictionary {
    return @{
             @"apiVersion":self.apiVersion
             };
}

// 配置请求参数
- (id)requestParams {
    return _requestParams;
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
    if (self.ignoreCache) {
        [self startRequest];
        return;
    }
    
    NSData *data = [self cacheForName:self.cacheFileName];
    if (!data) {
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
            [[XXXCacheFilesManager cacheManager] generateCacheObject:self.responseObject aName:self.cacheFileName];
            
            XXXCacheMetadata *cacheMetadata = [[XXXCacheMetadata alloc] init];
            cacheMetadata.apiVersion = self.apiVersion;
            cacheMetadata.appVersion = [XXAppContext appContext].appVersion;
            cacheMetadata.cacheCreateTime = [NSDate date];
            
            [[XXXCacheFilesManager cacheManager] generateMetadataObject:cacheMetadata aName:self.cacheFileName];
        }@catch(NSException *exception) {
            NSLog(@"Save cache failed, reason = %@",exception.reason);
        }
    }
}


/**
 缓存文件名

 @return fileName
 */
- (NSString *)cacheFileName {
    NSString *fileName = [NSString stringWithFormat:@"Method:%@ Host:%@ Url:%@ requestParams:%@", [self requestMethod], self.baseUrl ?: [XXAppContext appContext].domain, [self requestUrl], [self requestParams]];
    return [XXXNetworkUtils md5StringFromString:fileName];
}


/**
 获取缓存

 @param aName 缓存文件名
 @return data
 */
- (NSData *)cacheForName:(NSString *)aName {
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
    if (timeInterval > self.cacheInVaild) {
        return NO;
    }
    
    NSString *curApiVersion = self.apiVersion;
    NSString *cacheApiVersion = cacheMetadata.apiVersion;
    if (cacheApiVersion || curApiVersion) {
        if (cacheApiVersion.length != curApiVersion.length || ![cacheApiVersion isEqualToString:curApiVersion]) {
            return NO;
        }
    }
    
    NSString *curAppVersion = [XXAppContext appContext].appVersion;
    NSString *cacheAppVersion = cacheMetadata.appVersion;
    if (cacheAppVersion || curAppVersion) {
        if (cacheAppVersion.length != curAppVersion.length || ![cacheAppVersion isEqualToString:curAppVersion]) {
            return NO;
        }
    }
    
    return YES;
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
