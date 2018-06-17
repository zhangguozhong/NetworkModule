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

- (void)testActionWithCallBack:(void (^)(NSError *))completionBlockUI {
    self.userLoginRequest = [[TestRequestObj alloc] init];
    _userLoginRequest.paramsDelegate = self;
    _userLoginRequest.completionBlock = completionBlockUI;
    [self.userLoginRequest start];
}

- (id)fetchDataWithReformer{
    return [self.userLoginRequest fetchDataWithReformer:nil];
}


- (id)paramsWithRequest:(XXXRequest *)request {
    return @{@"key":@"value"};
}

- (void)dealloc{
    NSLog(@"服务对象已销毁");
}

@end
