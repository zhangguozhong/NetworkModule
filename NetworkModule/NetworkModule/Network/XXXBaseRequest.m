//
//  XXXBaseRequest.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/6/12.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "XXXBaseRequest.h"

@implementation XXXBaseRequest

- (NSDictionary *)headerFieldValueDictionary {
    return @{
             @"appVersion": [XXAppContext appContext].appVersion,
             @"systemName": [XXAppContext appContext].systemName,
             @"systemVersion": [XXAppContext appContext].systemVersion
             };
}

- (void)requestCompletePreprocessor{
    
}

@end
