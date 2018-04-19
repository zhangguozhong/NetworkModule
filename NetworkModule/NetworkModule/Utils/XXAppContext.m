//
//  NetworkConfig.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "XXAppContext.h"

@interface XXAppContext ()

@end

@implementation XXAppContext

+ (XXAppContext *)appContext {
    static XXAppContext *contextInstance = nil;
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

- (NSDictionary *)headerFieldValueDictionary {
    if (!_headerFieldValueDictionary) {
        _headerFieldValueDictionary = @{
                            @"appVersion": self.appVersion,
                            @"apiVersion": self.apiVersion ?: @"1",
                            @"sessionToken": self.sessionToken ?: [NSNull null],
                            @"systemName": self.systemName,
                            @"systemVersion": self.systemVersion
                            };
    }
    return _headerFieldValueDictionary;
}

@end
