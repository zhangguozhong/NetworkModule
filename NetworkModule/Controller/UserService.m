//
//  UserService.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/4.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "UserService.h"

@interface UserService() <RequestParametersDelegate, RequestCallBackDelegate>
@property (strong,nonatomic) BaseRequestObject *userLoginRequest;
@property (nonatomic, copy) void(^callBack)(BaseRequestObject *requestObject);
@end

@implementation UserService

- (void)testActionWithCallBack:(void (^)(BaseRequestObject *))callBack {
    self.userLoginRequest = [[TestRequestObj alloc] init];
    self.callBack = callBack;
    _userLoginRequest.paramsDelegate = self;
    _userLoginRequest.delegate = self;
    [self.userLoginRequest taskStart];
}

- (void)requestCompleteWithRequestObject:(BaseRequestObject *)requestObject withErrorInfo:(NSError *)errorInfo {
    if (errorInfo) {
        [self handleErrorAction:errorInfo];
    }else {
        self.callBack(requestObject);
    }
}

- (id)requestParamsWithRequestObject:(BaseRequestObject *)requestObject {
    return @{@"key":@"value"};
}

@end
