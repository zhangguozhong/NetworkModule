//
//  UserService.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/4.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "UserService.h"
#import "NetworkModuleManager.h"

@interface UserService()
@property (strong,nonatomic) NetworkRequestObject *userLoginRequest;
@end

@implementation UserService

- (void)testAction {
    self.userLoginRequest = [[NetworkRequestObject alloc] initWithMethod:@"GET" withParams:@{@"key":@"value"} successBlock:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    [[NetworkModuleManager networkTaskSender] doNetworkTaskWithRequestObject:_userLoginRequest];
}

- (void)dealloc {
    [[NetworkModuleManager networkTaskSender] cancelNetworkTask:self.userLoginRequest];
}

@end
