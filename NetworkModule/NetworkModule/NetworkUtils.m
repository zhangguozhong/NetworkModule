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
    NSDictionary *domainDatas = nil;
    if (!self.configDomainPlist) {
        return domainDatas;
    }
    
    NSString *resourceUrl = [[NSBundle mainBundle] pathForResource:self.configDomainPlist ofType:@".plist"];
    if (resourceUrl && resourceUrl.length>0) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:resourceUrl]) {
            domainDatas = [[NSDictionary alloc] initWithContentsOfFile:resourceUrl];
        }
    }
    
    NSLog(@"resource -- %@",domainDatas);
    return domainDatas;
}

@end
