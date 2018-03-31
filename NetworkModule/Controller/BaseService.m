//
//  BaseService.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/3/31.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "BaseService.h"

@implementation BaseService

- (void)handleErrorAction:(id)responseObject {
    if ([responseObject[@"code"] isEqualToString:@"session_expire"]) {
        NSLog(@"退出登录");
    }
}

@end
