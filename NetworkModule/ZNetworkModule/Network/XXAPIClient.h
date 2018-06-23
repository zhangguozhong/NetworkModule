//
//  NetworkClient.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/4.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface XXAPIClient : AFHTTPSessionManager

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

+ (XXAPIClient *)httpClient;

@end
