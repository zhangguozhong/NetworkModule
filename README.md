# NetworkModule

pod 'NetworkModule'


使用方法：

 (1)创建配置文件
 
 先创建一个plist文件，用于配置dev，production的环境下对应的domain，方便在发起网络请求时，获取到正确的服务端地址；
 
 然后通过NetworkUtils工具类进行配置配：
 
    [NetworkUtils networkUtils].domainPlistName = @"configDomainDatas";
 
    [NetworkUtils networkUtils].environment = @"dev";

（2）创建请求对象NetworkRequestObject类型；

    self.userLoginRequest = [[NetworkRequestObject alloc] initWithMethod:@"GET" withParams:@{@"key":@"value"}

    successBlock:^(id responseObject) {

        NSLog(@"%@",responseObject);
        
    } failBlock:^(NSError *error) {
    
        NSLog(@"%@",error);
    }];
    
 创建并配置完成之后，
   
（3）通过NetworkModuleManager，发起网络请求如[[NetworkModuleManager networkTaskSender] doNetworkTaskWithRequestObject:_userLoginRequest];

