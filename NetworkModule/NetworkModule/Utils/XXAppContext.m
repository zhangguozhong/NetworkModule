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


@synthesize apiVersion = _apiVersion;

@synthesize headerFieldValueDictionary = _headerFieldValueDictionary;

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


- (NSString *)apiVersion {
    if (!_apiVersion) {
        return @"1";
    }
    return _apiVersion;
}

- (NSDictionary *)headerFieldValueDictionary {
    if (!_headerFieldValueDictionary) {
        _headerFieldValueDictionary = @{
                                        @"appVersion": self.appVersion,
                                        @"apiVersion": self.apiVersion,
                                        @"systemName": self.systemName,
                                        @"systemVersion": self.systemVersion
                                        };
    }
    return _headerFieldValueDictionary;
}

- (void)updateAccessToken:(NSString *)accessToken {
    self.accessToken = accessToken;
}

@end
