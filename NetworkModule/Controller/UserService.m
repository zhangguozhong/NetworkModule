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
@property (strong,nonatomic) BaseRequestObject *userLoginRequest;
@end

@implementation UserService

- (void)testAction {
    self.userLoginRequest = [[TestRequestObj alloc] init];
    _userLoginRequest.paramsDelegate = self;
    __weak typeof(self) weakSelf = self;
    [_userLoginRequest setCompletionBlock:^(BaseRequestObject *requestObject) {
        NSLog(@"%@",requestObject.responseObject);
    } andHasErrorBlock:^(BaseRequestObject *requestObject) {
        [weakSelf handleErrorAction:requestObject.responseObject];
        NSLog(@"%@",requestObject.error);
    }];
    
    [self.userLoginRequest taskStart];
}

- (id)requestParamsWithRequestObject:(BaseRequestObject *)requestObject {
    return @{@"key":@"value"};
}

@end
