//
//  XXXFilesUtils.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/6/17.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "XXXFilesUtils.h"

@interface XXXFilesUtils() {
    
}
@property (copy, nonatomic) NSString *cacheDirectory;
@end

@implementation XXXFilesUtils

+ (XXXFilesUtils *)shared {
    static XXXFilesUtils *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    return self;
}

- (void)generateCacheData:(NSData *)data filesDirectory:(NSString *)filesDirectory aName:(NSString *)aName {
    NSString *cacheDirectory = [self.cacheDirectory stringByAppendingPathComponent:filesDirectory];
    if (cacheDirectory && aName && data) {
        [data writeToFile:[cacheDirectory stringByAppendingPathComponent:aName] atomically:YES];
    }
}

- (void)generateCacheMetadata:(XXXCacheMetadata *)data filesDirectory:(NSString *)filesDirectory aName:(NSString *)aName {
    NSString *cacheDirectory = [self.cacheDirectory stringByAppendingPathComponent:filesDirectory];
    if (cacheDirectory && aName && data) {
        [NSKeyedArchiver archiveRootObject:data toFile:[cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.metadata",aName]]];
    }
}

@end
