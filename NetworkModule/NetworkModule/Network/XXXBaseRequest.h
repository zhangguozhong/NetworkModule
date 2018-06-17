//
//  XXXBaseRequest.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/6/12.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXAppContext.h"

@interface XXXBaseRequest : NSObject

- (NSDictionary *)headerFieldValueDictionary; // 设置该请求的请求头

- (void)requestCompletePreprocessor;

@end
