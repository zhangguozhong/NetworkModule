//
//  NetworkRequestObject.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkRequestObject : NSObject

-(instancetype)initWithMethod:(NSString *)method withParams:(NSDictionary *)params;

@end
