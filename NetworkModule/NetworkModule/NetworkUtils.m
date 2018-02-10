//
//  NetworkConfig.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "NetworkUtils.h"

@interface NetworkUtils ()

@property (copy, nonatomic) NSDictionary *configDomainDatas;

@end

@implementation NetworkUtils

+ (NetworkUtils *)networkUtils {
    static NetworkUtils *networkUtils;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkUtils = [[self alloc] init];
    });
    return networkUtils;
}

- (NSString *)getDataForKey:(NSString *)key {
    return [[self.configDomainDatas objectForKey:self.environment] objectForKey:key];
}

- (NSDictionary *)configDomainDatas {
    if (_configData && _configData.count>0) {
        return _configData;
    }
    
    NSAssert(self.domainPlistName, @"pilst文件用于配置服务端域名信息，目前必须配置。");
    NSDictionary *domainDatas;
    NSString *resourceUrl = [[NSBundle mainBundle] pathForResource:self.domainPlistName ofType:@".plist"];
    if (resourceUrl && resourceUrl.length>0) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:resourceUrl]) {
            domainDatas = [[NSDictionary alloc] initWithContentsOfFile:resourceUrl];
        }
    }
    
    return domainDatas;
}

@end
