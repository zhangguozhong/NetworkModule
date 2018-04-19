//
//  XXNetworkCacheMananger.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/4/18.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "XXNetworkCacheMananger.h"
#import "XXNetworkCache.h"
#import "XXXRequestConfiguration.h"

@interface XXNetworkCacheMananger ()

@property (strong, nonatomic) NSCache *networkCache;

@end

@implementation XXNetworkCacheMananger

+ (instancetype)sharedInstance {
    static XXNetworkCacheMananger *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.networkCache = [[NSCache alloc] init];
        self.networkCache.totalCostLimit = kCTCacheCountLimit;
    }
    return self;
}

- (NSData *)fetchCachedDataWithKey:(NSString *)key
{
    XXNetworkCache *cachedObject = [self.networkCache objectForKey:key];
    if (cachedObject.isOutdated || cachedObject.isEmpty) {
        return nil;
    } else {
        return cachedObject.content;
    }
}

- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key
{
    XXNetworkCache *cachedObject = [self.networkCache objectForKey:key];
    if (!cachedObject) {
        cachedObject = [[XXNetworkCache alloc] init];
    }
    [cachedObject updateContent:cachedData];
    [self.networkCache setObject:cachedObject forKey:key];
}

- (void)deleteCacheWithKey:(NSString *)key
{
    [self.networkCache removeObjectForKey:key];
}

- (void)clean
{
    [self.networkCache removeAllObjects];
}

@end
