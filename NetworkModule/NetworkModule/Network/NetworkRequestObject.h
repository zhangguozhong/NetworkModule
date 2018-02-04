//
//  NetworkRequestObject.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/2.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequestProtocol.h"

typedef void(^successBlock)(id responseObject);
typedef void(^failBlock)(NSError *error);

@interface NetworkRequestObject : NSObject<NetworkRequestProtocol>

@property (strong,nonatomic) NSURLSessionDataTask *requestDataTask;
@property (copy,nonatomic,readonly) successBlock successBlock;
@property (copy,nonatomic,readonly) failBlock failBlock;

-(instancetype)initWithMethod:(NSString *)method withParams:(NSDictionary *)params successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;

@end
