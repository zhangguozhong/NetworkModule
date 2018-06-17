//
//  XXXCacheFilesManager.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/6/17.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXXCacheMetadata.h"

@interface XXXCacheFilesManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

@property (copy, nonatomic, readonly) NSString *cacheDirectory;

+ (XXXCacheFilesManager *)cacheManager;
- (void)generateCacheObject:(NSData *)data aName:(NSString *)aName;
- (void)generateMetadataObject:(XXXCacheMetadata *)data aName:(NSString *)aName;

@end
