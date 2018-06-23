//
//  XXXFilesUtils.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/6/17.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XXXCacheMetadata;

@interface XXXFilesUtils : NSObject

+ (XXXFilesUtils *)shared;

- (void)generateCacheData:(NSData *)data filesDirectory:(NSString *)filesDirectory aName:(NSString *)aName;

- (void)generateCacheMetadata:(XXXCacheMetadata *)data filesDirectory:(NSString *)filesDirectory aName:(NSString *)aName;

@end
