//
//  XXXBaseRequest.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/6/12.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "XXXBaseRequest.h"

@implementation XXXBaseRequest

- (NSDictionary *)CommonFieldValueDictionary {
    return @{
             @"appVersion": [XXAppContext appContext].appVersion,
             @"systemName": [XXAppContext appContext].systemName,
             @"systemVersion": [XXAppContext appContext].systemVersion,
             @"apiVersion": [XXAppContext appContext].apiVersion
             };
}

- (void)requestCompletePreprocessor{
    
}

@end
