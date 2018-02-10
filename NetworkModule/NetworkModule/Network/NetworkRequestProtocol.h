//
//  NetworkRequestProtocol.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkRequestProtocol <NSObject>

- (NSString *)method; //请求方式（GET，POST等）
- (id)requestParams; //请求参数
- (NSUInteger)requestSerializerType;
- (NSString *)requestUrl; //请求的接口名称

@optional
- (NSString *)baseUrl; //请求的接口域名地址

@end
