//
//  TestRequestObj.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/4/1.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "TestRequestObj.h"

@implementation TestRequestObj

- (BOOL)shouldRequestCompletionCacheData {
    return YES;
}

- (NSString *)cacheVersion {
    return @"1233";
}

- (NSTimeInterval)cacheTimeInterval {
    return 3000;
}

@end
