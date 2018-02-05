//
//  NetworkRequestObject.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "NetworkRequestObject.h"
#import "NetworkModuleManager.h"

@interface NetworkRequestObject() {
    NSString *_reqUrl;
    NSString *_domainUrl;
}
@property (nonatomic,copy) NSString *requestMethod;
@property (nonatomic,copy) NSDictionary *requestParameters;
@end

@implementation NetworkRequestObject

- (instancetype)initWithMethod:(NSString *)method reqUrl:(NSString *)reqUrl withParams:(NSDictionary *)params successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock {
    return [self initWithMethod:method reqUrl:reqUrl domainUrl:nil withParams:params successBlock:successBlock failBlock:failBlock];
}

- (instancetype)initWithMethod:(NSString *)method reqUrl:(NSString *)reqUrl domainUrl:(NSString *)domainUrl withParams:(NSDictionary *)params successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock {
    self = [super init];
    if (self) {
        self.requestMethod = method;
        self.requestParameters = params;
        _successBlock = successBlock;
        _failBlock = failBlock;
        _reqUrl = reqUrl;
        _domainUrl = domainUrl;
    }
    return self;
}

- (NSString *)method{
    return self.requestMethod;
}

- (NSDictionary *)requestParams{
    return self.requestParameters;
}

- (NSString *)requestUrl {
    return _reqUrl;
}

- (NSString *)baseUrl {
    return _domainUrl;
}

- (void)dealloc {
    NSLog(@"对象被释放");
    NSLog(@"对象被释放了，网络请求也就被取消了");
}

@end
