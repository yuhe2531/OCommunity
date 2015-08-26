//
//  FindPassWordViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/13.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "FindPassWordViewController.h"

@interface FindPassWordViewController ()

@end

@implementation FindPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"找回密码"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(findPasswordPop)];
    // Do any additional setup after loading the view.
}

-(void)findPasswordPop
{
    [self.navigationController popViewControllerAnimated:YES];
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
