//
//  NetworkClient.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/4.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "XXAPIClient.h"

@implementation XXAPIClient

+ (XXAPIClient *)httpClient {
    static XXAPIClient *httpClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpClient = [[self alloc] init];
        httpClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        httpClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    
    return httpClient;
}

@end
