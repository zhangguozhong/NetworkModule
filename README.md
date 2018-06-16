# NetworkModule

pod 'NetworkModule'


## 基本介绍

### 配置服务端接口地址

 ```objective-c
 
 [AppContext appContext].domain = @"https://facebook.github.io/";
 
 ```
  
  
  
### BaseReques基类

```objective-c

#import "XXXBaseRequest.h"
#import "XXXRequestConfiguration.h"

typedef NS_OPTIONS(NSUInteger, RequestSerializerType) {
    RequestSerializerTypeHTTP = 0,
    RequestSerializerTypeJSON
};

typedef NS_OPTIONS(NSUInteger, ResponseSerializerType) {
    ResponseSerializerTypeHTTP = 0,
    ResponseSerializerTypeJSON = 1,
    ResponseSerializerTypeXML
};


@protocol XXXRequestDelegate <NSObject>
@required
- (NSString *)requestMethod;
- (id)requestParams; //请求参数
- (NSString *)requestUrl; //请求的接口名称

@optional
- (NSString *)baseUrl; //请求的接口域名地址
- (NSUInteger)requestSerializerType;
- (NSUInteger)responseSerializerType;
- (NSTimeInterval)requestTimeoutInterval; // 每个请求的超时时间

@end


@protocol XXXRequestParametersDelegate <NSObject>
/**
 配置请求参数方法
 */
@required
- (id)paramsWithRequest:(XXXRequest *)request;

@end


@protocol XXXRequestDataReformer <NSObject>

/**
 格式化返回结果协议方法
 */
@required
- (id)request:(XXXRequest *)request reformData:(NSDictionary *)data;

@end

@interface XXXRequest : XXXBaseRequest<XXXRequestDelegate>

@property (strong, nonatomic) NSURLSessionDataTask *requestDataTask; //该请求的requestTask对象
@property (assign, nonatomic) BOOL ignoreCache; //忽略缓存
@property (assign, nonatomic) NSInteger timedOutCount; //超时次数
@property (copy, nonatomic) XXCallbackWithRequestBlock completionBlock;
@property (weak, nonatomic) id<XXXRequestParametersDelegate> paramsDelegate; //配置参数委托对象


@property (nonatomic) id fetchedRawData;
@property (nonatomic, strong) NSData *responseObject;
@property (nonatomic, strong) NSError *error;

- (void)start;
- (id)fetchDataWithReformer:(id<XXXRequestDataReformer>)reformer;


@end


```



### 发起请求，每个请求类必须继承BaseRequest基类；
```objective-c
   
- (void)testActionWithCallBack:(void (^)(NSError *))completionBlock {
    self.userLoginRequest = [[TestRequestObj alloc] init];
    _userLoginRequest.paramsDelegate = self;
    _userLoginRequest.completionBlock = completionBlock;
    [self.userLoginRequest start];
}

- (id)fetchDataWithReformer{
    return [self.userLoginRequest fetchDataWithReformer:nil];
}


- (id)paramsWithRequest:(XXXRequest *)request {
    return @{@"key":@"value"};
}


```
    
    
 

