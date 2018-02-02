//
//  NetworkRequestObject.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequestProtocol.h"

@interface NetworkRequestObject : NSObject<NetworkRequestProtocol>

-(instancetype)initWithMethod:(NSString *)method withParams:(NSDictionary *)params;

@end
