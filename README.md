# NetworkModule

pod 'NetworkModule'


## 基本介绍

### 配置服务端接口地址

 ```objective-c
 
 [AppContext appContext].domain = @"https://facebook.github.io/";
 
 ```
  
  
  
### BaseReques基类

```objective-c

#import <Foundation/Foundation.h>
#import "RequestProtocol.h"
@class BaseRequest;

typedef NS_OPTIONS(NSUInteger, RequestSerializerType) {
    RequestSerializerTypeHTTP = 0,
    RequestSerializerTypeJSON
};


@protocol RequestParametersDelegate <NSObject>
/**
 配置请求参数方法
 */
@required
- (id)paramsWithRequest:(BaseRequest *)baseRequest;

@end


@protocol RequestDataReformer <NSObject>

/**
 格式化返回结果协议方法
 */
@required
- (id)request:(BaseRequest *)baseRequest reformData:(NSDictionary *)data;

@end

@interface BaseRequest : NSObject<RequestProtocol>

@property (strong, nonatomic) NSURLSessionDataTask *requestDataTask; // 该请求的requestTask对象
@property (assign, nonatomic) BOOL ignoreCache; // 忽略缓存
@property (weak, nonatomic) id<RequestParametersDelegate> paramsDelegate; //配置参数委托对象


- (void)startTaskWithComplectionBlock:(void(^)(BaseRequest *baseRequest, NSError *error))complectionBlock;
- (NSString *)cacheVersion; // 设置此次缓存的版本，默认与appVersion一致
- (void)requestCompletionPreprocessor;
- (id)fetchDataWithReformer:(id<RequestDataReformer>)reformer;


@end


```



### 发起请求，每个请求类必须继承BaseRequest基类；
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


// 发起请求并回调
- (void)testActionWithCallBack:(void (^)(BaseRequest *, NSError *))completionBlock {
    self.userLoginRequest = [[TestRequestObj alloc] init];
    _userLoginRequest.paramsDelegate = self;
    [self.userLoginRequest startTaskWithComplectionBlock:completionBlock];
}


// 参数设置
- (id)paramsWithRequest:(BaseRequest *)baseRequest {
    return @{@"key":@"value"};
}


```
    
    
 

