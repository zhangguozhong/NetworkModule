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

- (void)testActionWithCallBack:(void (^)(BaseService *,NSError *))completionBlockUI {
    self.userLoginRequest = [[TestRequestObj alloc] init];
    _userLoginRequest.paramsDelegate = self;
    
    void(^completionBlock)(NSError *) = ^(NSError *error){
        if (completionBlockUI) {
            completionBlockUI(self, error);
        }
    };
    
    _userLoginRequest.completionBlock = completionBlock;
    [self.userLoginRequest start];
}

- (id)fetchDataWithReformer{
    return [self.userLoginRequest fetchDataWithReformer:nil];
}


- (id)paramsWithRequest:(XXXRequest *)request {
    return @{@"key":@"value"};
}

@end
