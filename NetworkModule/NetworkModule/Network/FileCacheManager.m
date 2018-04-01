//
//  FileUtils.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/4/1.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "FileCacheManager.h"
#import "AppContext.h"

@interface FileCacheManager ()

@property (copy, nonatomic) NSString *currentCachePath;

@end

NSString * const DZFileManagerDirectoryURL = @"CacheData"; // 默认缓存目录
@implementation FileCacheManager

+ (instancetype)cacheManager {
    static FileCacheManager *cacheManagerInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheManagerInstance = [[self alloc] init];
    });
    return cacheManagerInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cacheFolder = [AppContext appContext].cachePath ?: DZFileManagerDirectoryURL;
        self.currentCachePath = [libraryPath stringByAppendingPathComponent:cacheFolder];
        [self createDirectoryIfNeed:self.currentCachePath];
    }
    return self;
}


- (NSString *)cacheDataFileWithName:(NSString *)fileName {
    return [self.currentCachePath stringByAppendingPathComponent:fileName];
}


- (void)createDirectoryIfNeed:(NSString *)cachePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    
    if (![fileManager fileExistsAtPath:cachePath isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:cachePath];
    } else {
        if (!isDir) {
            NSError *error;
            [fileManager removeItemAtPath:cachePath error:&error];
            [self createBaseDirectoryAtPath:cachePath];
        }
    }
}


- (void)createBaseDirectoryAtPath:(NSString *)cachePath {
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"create cache directory failed, error = %@", error);
    } else {
        [self addDoNotBackupAttribute:cachePath];
    }
}


- (void)addDoNotBackupAttribute:(NSString *)cachePath {
    NSURL *cacheUrl = [NSURL fileURLWithPath:cachePath];
    NSError *error;
    [cacheUrl setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        NSLog(@"error to set do not backup attribute, error = %@", error);
    }
}

@end
