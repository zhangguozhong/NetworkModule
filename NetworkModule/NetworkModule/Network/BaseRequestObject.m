//
//  NetworkRequestObject.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "BaseRequestObject.h"
#import "RequestTaskHandler.h"
#import "AppContext.h"
#import "NSString+ConvertToMd5.h"
#import "FileCacheManager.h"

#ifdef NSFoundationVersionNumber_iOS_8_0
#define NSFoundationVersionNumber_With_QoS_Available 1140.11
#else
#define NSFoundationVersionNumber_With_QoS_Available NSFoundationVersionNumber_iOS_8_0
#endif


static dispatch_queue_t cache_writing_queue() {
    static dispatch_once_t onceQueueToken;
    static dispatch_queue_t cacheQueue = nil;
    dispatch_once(&onceQueueToken, ^{
        dispatch_queue_attr_t queue_attr = DISPATCH_QUEUE_SERIAL;
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_With_QoS_Available) {
            queue_attr = dispatch_queue_attr_make_with_qos_class(queue_attr, QOS_CLASS_BACKGROUND, 0);
        }
        cacheQueue = dispatch_queue_create("com.youdianyisi.request.caching.queue", queue_attr);
    });
    return cacheQueue;
}


@interface CacheMetaData : NSObject <NSSecureCoding>

@property (copy, nonatomic) NSString *cacheVersion;
@property (strong, nonatomic) NSDate *createDateTime;
@property (copy, nonatomic) NSString *appVersion;

@end


@implementation CacheMetaData

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.cacheVersion forKey:NSStringFromSelector(@selector(cacheVersion))];
    [aCoder encodeObject:self.createDateTime forKey:NSStringFromSelector(@selector(createDateTime))];
    [aCoder encodeObject:self.appVersion forKey:NSStringFromSelector(@selector(appVersion))];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.cacheVersion = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(cacheVersion))];
        self.createDateTime = [aDecoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(createDateTime))];
        self.appVersion = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(appVersion))];
    }
    return self;
}

@end


@interface BaseRequestObject ()

@property (strong, nonatomic) CacheMetaData *cacheMetaData;
@property (assign, nonatomic) BOOL isCache;

@end


@implementation BaseRequestObject

- (NSString *)requestMethod{
    return @"GET";
}

- (NSUInteger)requestSerializerType {
    return RequestSerializerTypeJSON;
}

// 配置请求参数
- (id)requestParams {
    if ([self.paramsDelegate respondsToSelector:@selector(requestParamsWithRequestObject:)]) {
        return [self.paramsDelegate requestParamsWithRequestObject:self];
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

- (BOOL)shouldRequestCompletionCacheData {
    return NO;
}

// 是否使用串行队列缓存
- (BOOL)writeCacheAsynchronously {
    return NO;
}


- (NSTimeInterval)cacheTimeInterval {
    return 20;
}

- (NSTimeInterval)requestTimeoutInterval {
    return 30;
}


- (void)setCompletionBlock:(CompletionBlock)completionBlock andHasErrorBlock:(HasErrorBlock)hasErrorBlock {
    _completionBlock = completionBlock;
    _hasErrorBlock = hasErrorBlock;
}


- (void)startWithCompletionBlock:(CompletionBlock)completionBlock andHasErrorBlock:(HasErrorBlock)hasErrorBlock {
    [self setCompletionBlock:completionBlock andHasErrorBlock:hasErrorBlock];
    [self taskStart];
}


- (void)cleanBlocks {
    _completionBlock = nil;
    _hasErrorBlock = nil;
}

- (NSString *)cacheVersion {
    return [AppContext appContext].appVersion;
}


/**
 设置请求头
 */
- (NSDictionary *)headerFieldValueDictionary {
    return nil;
}


/**
 发起请求
 */
- (void)taskStart {
    if (self.ignoreCache) {
        [self startWithoutCache];
        return;
    }
    if (!self.loadCache) {
        [self startWithoutCache];
        return;
    }
    
    self.isCache = YES; // 执行到这里说明可以使用之前的缓存
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.completionBlock) {
            self.completionBlock(self);
        }
    });
    
}


/**
 发起请求（没有缓存）
 */
- (void)startWithoutCache {
    [self clearCache];
    [[RequestTaskHandler taskHandler] doNetworkTaskWithRequestObject:self];
}


/**
 缓存
 */
- (void)requestCompletionPreprocessor {
    if (self.shouldRequestCompletionCacheData) {
        if (self.writeCacheAsynchronously) {
            dispatch_async(cache_writing_queue(), ^{
                [self cacheDataToFile];
            });
        } else {
            [self cacheDataToFile];
        }
    }
}

- (void)clearCache {
    _cacheMetaData = nil;
    _isCache = NO;
}


/**
 条件1：此次请求设置可缓存
 条件2：缓存过期时间大于0
 条件3：缓存附带文件各项数据均合法
 条件4：符合条件的缓存文件存在
 当满足以上4个条件后，可以使用缓存数据直接回调，不用请求后台接口。

 @return 是否可以使用缓存
 */
- (BOOL)loadCache {
    return ([self shouldRequestCompletionCacheData] && (self.cacheTimeInterval > 0) && [self loadCacheMetadata] && [self loadCacheData]);
}



/**
 判断缓存信息文件是否可用

 @return 缓存信息文件可用
 */
- (BOOL)loadCacheMetadata {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [self cacheMetadataFileName];
    NSString *filePath = [[FileCacheManager cacheManager] cacheDataFileWithName:fileName];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        @try {
            self.cacheMetaData = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            NSTimeInterval invertal = -[self.cacheMetaData.createDateTime timeIntervalSinceNow];
            if (invertal < 0 || invertal > [self cacheTimeInterval]) {
                return NO;
            }
            
            NSString *cacheVersion = self.cacheMetaData.cacheVersion;
            NSString *currentCacheVersion = self.cacheVersion;
            if (![cacheVersion isEqualToString:currentCacheVersion]) {
                return NO;
            }
            
            NSString *appVersion = self.cacheMetaData.appVersion;
            NSString *currentAppVersion = [AppContext appContext].appVersion;
            if (appVersion || currentAppVersion) {
                if (![appVersion isEqualToString:currentAppVersion]) {
                    return NO;
                }
            }
        } @catch (NSException *exception) {
            return NO;
        }
    }
    return YES;
}


/**
 缓存文件存在且有数据

 @return 是否能成功加载缓存
 */
- (BOOL)loadCacheData {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [self cacheFileName];
    NSString *filePath = [[FileCacheManager cacheManager] cacheDataFileWithName:fileName];
    
    id cacheResponseObject = nil;
    if ([fileManager fileExistsAtPath:filePath]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        
        NSError *error;
        cacheResponseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error) {
            cacheResponseObject = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    
    self.responseObject = cacheResponseObject;
    return !!cacheResponseObject;
}



/**
 将成功返回的数据缓存至文件
 */
- (void)cacheDataToFile {
    if (self.cacheTimeInterval > 0 && !self.isCache) {
        NSData *responseData = [NSJSONSerialization dataWithJSONObject:self.responseObject options:kNilOptions error:nil];
        if (responseData) {
            @try{
                [responseData writeToFile:[[FileCacheManager cacheManager] cacheDataFileWithName:[self cacheFileName]] atomically:YES];
                
                CacheMetaData *cacheMetaData = [[CacheMetaData alloc] init];
                cacheMetaData.cacheVersion = self.cacheVersion;
                cacheMetaData.createDateTime = [NSDate date];
                cacheMetaData.appVersion = [AppContext appContext].appVersion;
                [NSKeyedArchiver archiveRootObject:cacheMetaData toFile:[[FileCacheManager cacheManager] cacheDataFileWithName:[self cacheMetadataFileName]]];
                
            } @catch (NSException *exception) {
                NSLog(@"cahce data error");
            }
        }
    }
}

#pragma mark - Cache FileName
- (NSString *)cacheFileName {
    NSString *baseUrl = self.baseUrl ?: [AppContext appContext].domain;
    NSString *requestInfo = [NSString stringWithFormat:@"Method:%@ Host:%@ Url:%@ Argument:%@", [self requestMethod], baseUrl, [self requestUrl], [self requestParams]];
    return [requestInfo stringToMd5];
}

- (NSString *)cacheMetadataFileName {
    return [NSString stringWithFormat:@"%@.metadata", [self cacheFileName]];
}

- (void)dealloc {
    [[RequestTaskHandler taskHandler] cancelNetworkTask:self];
}

@end
