//
//  XXXCacheMetadata.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/6/17.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "XXXCacheMetadata.h"

@implementation XXXCacheMetadata

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.apiVersion forKey:NSStringFromSelector(@selector(apiVersion))];
    [aCoder encodeObject:self.cacheCreateTime forKey:NSStringFromSelector(@selector(cacheCreateTime))];
    [aCoder encodeObject:self.appVersion forKey:NSStringFromSelector(@selector(appVersion))];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.apiVersion = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(apiVersion))];
    self.cacheCreateTime = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(cacheCreateTime))];
    self.appVersion = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(appVersion))];
    
    return self;
}

@end
