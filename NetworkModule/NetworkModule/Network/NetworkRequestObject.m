//
//  NetworkRequestObject.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "NetworkRequestObject.h"

@interface NetworkRequestObject()
@property (nonatomic,copy) NSString *requestMethod;
@property (nonatomic,copy) NSDictionary *requestParameters;
@end

@implementation NetworkRequestObject

- (instancetype)initWithMethod:(NSString *)method withParams:(NSDictionary *)params{
    self = [super init];
    if (self) {
        self.requestMethod = method;
        self.requestParameters = params;
    }
    return self;
}

- (NSString *)method{
    return self.requestMethod;
}

- (NSDictionary *)requestParams{
    return self.requestParameters;
}

@end
