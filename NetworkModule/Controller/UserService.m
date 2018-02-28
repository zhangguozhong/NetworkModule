//
//  UserService.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/4.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "UserService.h"
#import "NetworkRequestObject.h"

@interface UserService() <RequestTaskParamsDelegate>
@property (strong,nonatomic) NetworkRequestObject *userLoginRequest;
@end

@implementation UserService

- (void)testAction {
    self.userLoginRequest = [[NetworkRequestObject alloc] init];
    _userLoginRequest.requestParamsDelegate = self;
    [_userLoginRequest setCompletionBlock:^(NetworkRequestObject *requestObject) {
        NSLog(@"%@",requestObject.responseObject);
    } andHasErrorBlock:^(NetworkRequestObject *requestObject) {
        NSLog(@"%@",requestObject.error);
    }];
    
    [self.userLoginRequest taskStart];
}

- (id)requestTaskParamsWithRequestObject:(NetworkRequestObject *)requestObject {
    return @{@"key":@"value"};
}

@end
