//
//  XXXRequestConfiguration.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/4/19.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#ifndef XXXRequestConfiguration_h
#define XXXRequestConfiguration_h

@class XXXRequest;

typedef void(^XXCallbackWithRequestBlock)(XXXRequest *request, NSError *error);

typedef void(^XXCallbackBlock)(id result, NSError *error);

static NSTimeInterval kCTCacheOutdateTimeSeconds = 300; // 5分钟的cache过期时间

static NSUInteger kCTCacheCountLimit = 1000; // 最多1000条cache

static NSUInteger XXRequestTimedOutCount = 3; // 3次重连

#endif /* XXXRequestConfiguration_h */
