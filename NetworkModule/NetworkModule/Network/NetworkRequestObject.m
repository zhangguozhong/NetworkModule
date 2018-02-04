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
@property (nonatomic,copy) NSString *requestMethod;
@property (nonatomic,copy) NSDictionary *requestParameters;
@end

@implementation NetworkRequestObject

- (instancetype)initWithMethod:(NSString *)method withParams:(NSDictionary *)params successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock {
    self = [super init];
    if (self) {
        self.requestMethod = method;
        self.requestParameters = params;
        _successBlock = successBlock;
        _failBlock = failBlock;
    }
    return self;
}

- (NSString *)method{
    return self.requestMethod;
}

- (NSDictionary *)requestParams{
    return self.requestParameters;
}

- (void)dealloc {
    NSLog(@"对象被释放");
}

@end
