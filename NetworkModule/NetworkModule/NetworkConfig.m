//
//  NetworkConfig.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "NetworkConfig.h"

@implementation NetworkConfig

+ (NetworkConfig *)shareConfig {
    static NetworkConfig *networkConfigInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkConfigInstance = [[self alloc] init];
    });
    return networkConfigInstance;
}

- (NSString *)domain {
    return [[self.configData objectForKey:self.environment] objectForKey:@"domain"];
}

- (NSString *)webDomian {
    return [[self.configData objectForKey:self.environment] objectForKey:@"webDomain"];
}

- (NSDictionary *)configData {
    return @{
             @"dev":@{
                     @"domain":@"https://facebook.github.io/react-native/movies.json",
                     @"webDomain":@"https://devWebDomain.domain.com"
                     },
             @"staging":@{
                     @"domain":@"https://staging.domain.com",
                     @"webDomain":@"https://stagingWebDomain.domain.com"
                     },
             @"prodiction":@{
                     @"domain":@"https://prodiction.domain.com",
                     @"webDomain":@"https://prodictionWebDomain.domain.com"
                     }
             };
}

@end
