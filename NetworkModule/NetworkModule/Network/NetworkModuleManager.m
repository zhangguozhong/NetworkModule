//
//  NetworkModuleManager.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "NetworkModuleManager.h"

@implementation NetworkModuleManager

+ (NetworkModuleManager *)apiClient{
    static NetworkModuleManager *apiClientManager;
    static dispatch_once_t clientOnceToken;
    dispatch_once(&clientOnceToken, ^{
        apiClientManager = [[self alloc] init];
    });
    return apiClientManager;
}

@end
