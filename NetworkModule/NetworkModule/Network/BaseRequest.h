//
//  NetworkRequestObject.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestProtocol.h"
@class BaseRequest;

typedef NS_OPTIONS(NSUInteger, RequestSerializerType) {
    RequestSerializerTypeHTTP = 0,
    RequestSerializerTypeJSON
};


@protocol RequestParametersDelegate <NSObject>
/**
 配置请求参数方法
 */
@required
- (id)paramsWithRequest:(BaseRequest *)baseRequest;

@end


@protocol RequestDataReformer <NSObject>

/**
 格式化返回结果协议方法
 */
@required
- (id)request:(BaseRequest *)baseRequest reformData:(NSDictionary *)data;

@end

@interface BaseRequest : NSObject<RequestProtocol>

@property (strong, nonatomic) NSURLSessionDataTask *requestDataTask; // 该请求的requestTask对象
@property (assign, nonatomic) BOOL ignoreCache; // 忽略缓存
@property (weak, nonatomic) id<RequestParametersDelegate> paramsDelegate; //配置参数委托对象


- (void)startTaskWithComplectionBlock:(void(^)(BaseRequest *baseRequest, NSError *error))complectionBlock;
- (NSString *)cacheVersion; // 设置此次缓存的版本，默认与appVersion一致
- (void)requestCompletionPreprocessor;
- (id)fetchDataWithReformer:(id<RequestDataReformer>)reformer;


@end
