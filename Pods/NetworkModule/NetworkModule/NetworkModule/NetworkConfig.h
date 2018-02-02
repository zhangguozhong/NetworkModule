//
//  NetworkConfig.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkConfig : NSObject

@property (nonatomic,copy) NSString *environment;
@property (nonatomic,strong,readonly) NSString *domain;
@property (nonatomic,strong,readonly) NSString *webDomian;

-(instancetype)init NS_UNAVAILABLE;
-(instancetype)new NS_UNAVAILABLE;

+(NetworkConfig *)shareConfig;

@end
