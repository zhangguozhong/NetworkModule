//
//  NetworkModuleManager.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequestObject.h"

@interface NetworkModuleManager : NSObject

+ (NetworkModuleManager *)networkTaskSender;

- (void)cancelNetworkTask:(NetworkRequestObject *)requestObject;
- (void)doNetworkTaskWithRequestObject:(NetworkRequestObject *)requestObject;

@end
