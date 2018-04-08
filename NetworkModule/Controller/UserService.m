//
//  UserService.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/4.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "UserService.h"
#import "TestRequestObj.h"

@interface UserService() <RequestParametersDelegate>
@property (strong,nonatomic) BaseRequest *userLoginRequest;
@end

@implementation UserService

- (void)testActionWithCallBack:(void (^)(BaseRequest *, NSError *))completionBlock {
    self.userLoginRequest = [[TestRequestObj alloc] init];
    _userLoginRequest.paramsDelegate = self;
    [self.userLoginRequest startTaskWithComplectionBlock:completionBlock];
}


- (id)paramsWithRequest:(BaseRequest *)baseRequest {
    return @{@"key":@"value"};
}

@end
