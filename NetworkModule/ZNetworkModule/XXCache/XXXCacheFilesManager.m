//
//  XXXCacheFilesManager.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/6/17.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "XXXCacheFilesManager.h"
#import "XXAppContext.h"
#import "XXXRequestConfiguration.h"
#import "XXXFilesUtils.h"

@interface XXXCacheFilesManager ()

@property (copy, nonatomic) NSString *cacheDirectory;

@end

@implementation XXXCacheFilesManager

+ (XXXCacheFilesManager *)cacheManager {
    static XXXCacheFilesManager *cacheFilesManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        cacheFilesManager = [[self alloc] init];
    });
    
    return cacheFilesManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDirectoryIfNeed];
    }
    return self;
}

- (void)createDirectoryIfNeed {
    NSString *cacheDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:self.filesDirectory];
    
    BOOL isDirectory;
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory isDirectory:&isDirectory]) {
        [self createBaseDirectoryAtPath:cacheDirectory];
    }else {
        if (!isDirectory) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:cacheDirectory error:&error];
            [self createBaseDirectoryAtPath:cacheDirectory];
        }
    }
}

- (void)createBaseDirectoryAtPath:(NSString *)cacheDirectory {
    NSError *error = nil;
    BOOL isCreated = [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    if (isCreated && !error) {
        [self addDoNotBackupAttribute:cacheDirectory];
    }
}

- (void)addDoNotBackupAttribute:(NSString *)cacheDirectory {
    NSURL *url = [NSURL fileURLWithPath:cacheDirectory];
    NSError *error = nil;
    [url setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        NSLog(@"create cache directory failed, error = %@",error);
    }
}

- (NSString *)filesDirectory {
    return [XXAppContext appContext].cacheFileDirectory ?: XXXCacheFilesDirectory;
}

- (void)generateCacheObject:(NSData *)data aName:(NSString *)aName {
    [[XXXFilesUtils shared] generateCacheData:data filesDirectory:self.filesDirectory aName:aName];
}

- (void)generateMetadataObject:(XXXCacheMetadata *)data aName:(NSString *)aName {
    [[XXXFilesUtils shared] generateCacheMetadata:data filesDirectory:self.filesDirectory aName:aName];
}

@end
