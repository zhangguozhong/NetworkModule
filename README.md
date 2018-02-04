# NetworkModule

pod 'NetworkModule'


使用方法：
（1）创建请求对象NetworkRequestObject类型；
self.userLoginRequest = [[NetworkRequestObject alloc] initWithMethod:@"GET" withParams:@{@"key":@"value"} successBlock:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
   创建并配置完成之后，
   
（2）通过NetworkModuleManager，发起网络请求如[[NetworkModuleManager networkTaskSender] doNetworkTaskWithRequestObject:_userLoginRequest];

