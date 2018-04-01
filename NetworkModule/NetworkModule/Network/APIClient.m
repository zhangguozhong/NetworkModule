//
//  NetworkClient.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/4.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "APIClient.h"
#import "AppContext.h"

@implementation APIClient

+ (APIClient *)httpClient {
    static APIClient *httpClient;
    static dispatch_once_t networkOnceToken;
    dispatch_once(&networkOnceToken, ^{
        httpClient = [[self alloc] init];
        httpClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        httpClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 设置headers
        [httpClient.requestSerializer setValue:[AppContext appContext].appVersion forHTTPHeaderField:@"appVersion"];
        [httpClient.requestSerializer setValue:[AppContext appContext].apiVersion forHTTPHeaderField:@"apiVersion"];
        [httpClient.requestSerializer setValue:[AppContext appContext].sessionToken forHTTPHeaderField:@"sessionToken"];
        [httpClient.requestSerializer setValue:[AppContext appContext].systemName forHTTPHeaderField:@"systemName"];
        [httpClient.requestSerializer setValue:[AppContext appContext].systemVersion forHTTPHeaderField:@"systemVersion"];
    });
    return httpClient;
}

@end
