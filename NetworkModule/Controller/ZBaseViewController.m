//
//  ZBaseViewController.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/6.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "ZBaseViewController.h"

extern NSString *NetworkTaskRequestSessionExpired;
@interface ZBaseViewController ()

@end

@implementation ZBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",NetworkTaskRequestSessionExpired);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:NetworkTaskRequestSessionExpired object:nil];
}

- (void)logout{
    NSLog(@"退出登录");
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NetworkTaskRequestSessionExpired object:nil];
}

@end
