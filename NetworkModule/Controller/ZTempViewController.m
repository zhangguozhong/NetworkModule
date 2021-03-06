//
//  ZTempViewController.m
//  NetworkModule
//
//  Created by 张国忠 on 2018/2/4.
//  Copyright © 2018年 张国忠. All rights reserved.
//

#import "ZTempViewController.h"
#import "UserService.h"

@interface ZTempViewController ()

@property (strong, nonatomic) UserService *userService;

@end

@implementation ZTempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.userService = [[UserService alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.userService testActionWithCallBack:^(NSError *error) {
        if (!error) {
            id result = [weakSelf fetchDataWithReformer];
            NSLog(@"result -- %@",result);
        }
    }];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"test":@"value",@"name":@"zhangsan"} options:kNilOptions error:nil];
    
    NSString *testStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"json string == %@", testStr);
}

- (id)fetchDataWithReformer {
    return [self.userService fetchDataWithReformer];
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
    NSLog(@"视图已销毁");
}

@end
