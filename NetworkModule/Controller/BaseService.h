//
//  BaseService.h
//  NetworkModule
//
//  Created by 张国忠 on 2018/3/31.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseService : NSObject

- (void)handleErrorAction:(NSError *)errorInfo;

- (id)fetchDataWithReformer;

@end
