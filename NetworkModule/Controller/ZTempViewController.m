//
//  ZTempViewController.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/4.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "ZTempViewController.h"
#import "NetworkModuleManager.h"

@interface ZTempViewController ()

//@property (strong, nonatomic) NetworkRequestObject *userLoginRequest;

@end

@implementation ZTempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NetworkRequestObject *userLoginRequest = [[NetworkRequestObject alloc] initWithMethod:@"GET" withParams:@{@"key":@"value"} successBlock:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    [[NetworkModuleManager networkTaskSender] doNetworkTaskWithRequestObject:userLoginRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
