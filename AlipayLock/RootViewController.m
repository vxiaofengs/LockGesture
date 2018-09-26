//
//  RootViewController.m
//  AlipayLock
//
//  Created by houji007 on 15/10/23.
//  Copyright © 2015年 houji007. All rights reserved.
//

#import "RootViewController.h"
#import "GestureLockView.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GestureLockView * lock=[[GestureLockView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [lock setUnlockSuccess:^{
    }];
    [self.view addSubview:lock];
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
