//
//  NetworkRequestObject.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "NetworkRequestObject.h"
#import "NetworkModuleManager.h"

@interface NetworkRequestObject()

@end

@implementation NetworkRequestObject

- (void)setCompletionBlock:(CompletionBlock)completionBlock andHasErrorBlock:(HasErrorBlock)hasErrorBlock {
    _completionBlock = completionBlock;
    _hasErrorBlock = hasErrorBlock;
}

- (NSString *)method{
    return @"GET";
}

- (NSUInteger)requestSerializerType {
    return RequestSerializerTypeJSON;
}

- (id)requestParams{
    if (self.requestParamDelegate && [self.requestParamDelegate respondsToSelector:@selector(parametersWithRequestObject:)]) {
        return [self.requestParamDelegate parametersWithRequestObject:self];
    }
    return nil;
}

- (NSString *)requestUrl {
    return @"react-native/movies.json";
}

- (NSString *)baseUrl {
    return nil;
}

- (void)cleanBlocks {
    _completionBlock = nil;
    _hasErrorBlock = nil;
}

- (void)dealloc {
    NSLog(@"对象被释放");
    NSLog(@"对象被释放了，网络请求也就被取消了");
}

@end
