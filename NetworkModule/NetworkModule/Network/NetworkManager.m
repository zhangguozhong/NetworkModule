//
//  NetworkClient.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/4.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

+ (NetworkManager *)networkClient {
    static NetworkManager *networkClient;
    static dispatch_once_t networkOnceToken;
    dispatch_once(&networkOnceToken, ^{
        networkClient = [[self alloc] init];
        networkClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        networkClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        networkClient.requestSerializer.timeoutInterval = 20;
        //[networkClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        //[networkClient.requestSerializer setValue:@"" forHTTPHeaderField:@"User-Agent"];
    });
    return networkClient;
}

@end
