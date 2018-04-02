# NetworkModule

pod 'NetworkModule'


## 基本介绍

### 配置服务端接口地址

 ```objective-c
 
 [AppContext appContext].domain = @"https://facebook.github.io/";
 
 ```
  
  
  
### BaseRequestObject基类

```objective-c

#import <Foundation/Foundation.h>
@class BaseRequestObject;

typedef NS_OPTIONS(NSUInteger, RequestSerializerType) {
    RequestSerializerTypeHTTP = 0,
    RequestSerializerTypeJSON
};


@protocol RequestObjectDelegate <NSObject>

- (NSString *)requestMethod;
- (id)requestParams; //请求参数
- (NSUInteger)requestSerializerType;
- (NSString *)requestUrl; //请求的接口名称

@optional
- (NSString *)baseUrl; //请求的接口域名地址
- (BOOL)shouldRequestCompletionCacheData; //是否开启缓存，默认不开启
- (BOOL)writeCacheAsynchronously;
- (NSTimeInterval)cacheTimeInterval; //缓存过期时间
- (NSTimeInterval)requestTimeoutInterval; // 每个请求的超时时间
- (NSDictionary *)headerFieldValueDictionary; // 设置该请求的请求头

@end

@protocol RequestParametersDelegate <NSObject>

/**
 配置参数方法

 @param requestObject 请求对象
 @return 所配置的参数
 */
- (id)requestParamsWithRequestObject:(BaseRequestObject *)requestObject;

@end

typedef void(^CompletionBlock)(BaseRequestObject *requestObject);
typedef void(^HasErrorBlock)(BaseRequestObject *requestObject);

@interface BaseRequestObject : NSObject<RequestObjectDelegate>

@property (nonatomic) id responseObject; // 返回数据
@property (strong, nonatomic) NSError *error;

@property (strong,nonatomic) NSURLSessionDataTask *requestDataTask; // 本次请求的requestTask对象

@property (copy,nonatomic,readonly) CompletionBlock completionBlock;
@property (copy,nonatomic,readonly) HasErrorBlock hasErrorBlock;
@property (assign, nonatomic) BOOL ignoreCache; // 忽略缓存


/**
 配置参数委托对象
 */
@property (weak,nonatomic) id<RequestParametersDelegate> paramsDelegate;


/**
 配置网络回调事件

 @param completionBlock 请求成功block回调
 @param hasErrorBlock 请求失败block回调
 */
- (void)setCompletionBlock:(CompletionBlock)completionBlock andHasErrorBlock:(HasErrorBlock)hasErrorBlock;


/**
 开始网络请求

 @param completionBlock 请求成功block回调
 @param hasErrorBlock 请求失败block回调
 */
- (void)startWithCompletionBlock:(CompletionBlock)completionBlock andHasErrorBlock:(HasErrorBlock)hasErrorBlock;

- (void)cleanBlocks;
- (void)taskStart;
- (NSString *)cacheVersion; // 设置此次缓存的版本，默认与appVersion一致
- (void)requestCompletionPreprocessor;


@end

```



### 发起请求，每个请求类必须继承BaseRequestObject基类；
```objective-c
   
   #import "TestRequestObj.h"

   @implementation TestRequestObj

   - (BOOL)shouldRequestCompletionCacheData {
       return YES;
   }

   - (NSString *)cacheVersion {
       return @"1233";
   }

   - (NSTimeInterval)cacheTimeInterval {
       return 3000;
   }

   @end


    // 发起请求
    self.userLoginRequest = [[TestRequestObj alloc] init];
    _userLoginRequest.paramsDelegate = self;
    __weak typeof(self) weakSelf = self;
    [_userLoginRequest setCompletionBlock:^(BaseRequestObject *requestObject) {
        NSLog(@"%@",requestObject.responseObject);
    } andHasErrorBlock:^(BaseRequestObject *requestObject) {
        [weakSelf handleErrorAction:requestObject.responseObject];
        NSLog(@"%@",requestObject.error);
    }];
    
    [self.userLoginRequest taskStart];
    
   ```
    
    
 ### 网络请求参数配置需通过以下方法；
 
 ```objective-c
 
    - (id)requestParamsWithRequestObject:(BaseRequestObject *)requestObject {
    return @{@"key":@"value"};
    }
    
 ```

