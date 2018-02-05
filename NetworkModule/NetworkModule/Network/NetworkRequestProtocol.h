//
//  NetworkRequestProtocol.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkRequestProtocol <NSObject>

- (NSString *)method;
- (NSDictionary *)requestParams;
- (NSString *)requestUrl;

@optional
- (NSString *)baseUrl;

@end
