//
//  NetworkConfig.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppContext : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

+ (AppContext *)appContext;

@property (copy, nonatomic) NSString *domain; //域名
@property (copy, nonatomic, readonly) NSString *appVersion;
@property (copy, nonatomic) NSString *sessionToken;
@property (copy, nonatomic) NSString *apiVersion;

@property (copy, nonatomic, readonly) NSString *systemName;
@property (copy, nonatomic, readonly) NSString *systemVersion;


@end
