//
//  UserService.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/4.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "UserService.h"
#import "NetworkModuleManager.h"

@interface UserService()<NetworkRequestParamDelegate>
@property (strong,nonatomic) NetworkRequestObject *userLoginRequest;
@end

@implementation UserService

- (void)testAction {
    self.userLoginRequest = [[NetworkRequestObject alloc] init];
    _userLoginRequest.requestParamDelegate = self;
    [_userLoginRequest setCompletionBlock:^(NetworkRequestObject *requestObject) {
        NSLog(@"%@",requestObject.responseObject);
    } andHasErrorBlock:^(NetworkRequestObject *requestObject) {
        NSLog(@"%@",requestObject.error);
    }];
    
    [[NetworkModuleManager networkTaskSender] doNetworkTaskWithRequestObject:_userLoginRequest];
}

- (id)parametersWithRequestObject:(NetworkRequestObject *)requestObject {
    return @{@"key":@"value"};
}

- (void)dealloc {
    [[NetworkModuleManager networkTaskSender] cancelNetworkTask:self.userLoginRequest];
}

@end
