//
//  FileUtils.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/4/1.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileCacheManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

+ (instancetype)cacheManager;


/**
 生成缓存文件路径

 @param fileName 文件名
 @return 缓存文件路径
 */
- (NSString *)cacheDataFileWithName:(NSString *)fileName;


@end
