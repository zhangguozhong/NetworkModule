//
//  UserService.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/4.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "UserService.h"
#import "TestRequestObj.h"

@interface UserService() <XXXRequestParametersDelegate>
@property (strong,nonatomic) XXXRequest *userLoginRequest;
@end

@implementation UserService

- (void)testActionWithCallBack:(void (^)(XXXRequest *, NSError *))completionBlock {
    self.userLoginRequest = [[TestRequestObj alloc] init];
    _userLoginRequest.paramsDelegate = self;
    [self.userLoginRequest startWithBlock:completionBlock];
}


- (id)paramsWithRequest:(XXXRequest *)request {
    return @{@"key":@"value"};
}

@end
