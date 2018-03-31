//
//  NetworkConfig.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "AppContext.h"

@interface AppContext ()

@end

@implementation AppContext

+ (AppContext *)appContext {
    static AppContext *contextInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contextInstance = [[self alloc] init];
    });
    return contextInstance;
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

@end
