# NetworkModule

pod 'NetworkModule'


### 使用方法：

（1）配置接口域名

 ```objective-c
 [AppContext appContext].domain = @"https://facebook.github.io/";
 ```
    

（2）发起请求，每个请求类必须继承NetworkRequestObject；
```objective-c
    self.userLoginRequest = [[NetworkRequestObject alloc] init];
    _userLoginRequest.paramsDelegate = self;
    __weak typeof(self) weakSelf = self;
    [_userLoginRequest setCompletionBlock:^(NetworkRequestObject *requestObject) {
        NSLog(@"%@",requestObject.responseObject);
    } andHasErrorBlock:^(NetworkRequestObject *requestObject) {
        [weakSelf handleErrorAction:requestObject.responseObject];
        NSLog(@"%@",requestObject.error);
    }];
    
    [self.userLoginRequest taskStart];
   ```
    
    
 配置参数：
 ```objective-c
    - (id)requestTaskParamsWithRequestObject:(NetworkRequestObject *)requestObject {
    return @{@"key":@"value"};
    }

