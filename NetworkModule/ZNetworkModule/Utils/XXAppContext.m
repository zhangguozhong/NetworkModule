//
//  NetworkConfig.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "XXAppContext.h"

@interface XXAppContext ()

@property (copy, nonatomic, readwrite) NSString *accessToken;
@end

@implementation XXAppContext

+ (XXAppContext *)appContext {
    static XXAppContext *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)systemName {
    return [UIDevice currentDevice].systemName;
}

- (NSString *)systemVersion {
    return [UIDevice currentDevice].systemVersion;
}

- (void)updateAccessToken:(NSString *)accessToken {
    self.accessToken = accessToken;
}

@end
