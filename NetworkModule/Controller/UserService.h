//
//  UserService.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/4.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "BaseService.h"
#import "TestRequestObj.h"

@interface UserService : BaseService

- (void)testActionWithCallBack:(void(^)(NSError *error))completionBlock;

- (id)fetchDataWithReformer;

@end
