//
//  NoLoginViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/13.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "NoLoginViewController.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "NetWorkRequest.h"
@interface NoLoginViewController ()

@end

@implementation NoLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.navigationController.navigationBar.barTintColor = kRedColor;
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"零步社区"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(0, 0, 40, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    [cancelBtn addTarget:self action:@selector(noLoginVCPopAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    [self createNoLoginSubviews];
    
    // Do any additional setup after loading the view.
}

#define kLoginBtn_height 40
#define kLoginBtn_left 15

-(void)createNoLoginSubviews
{
    UIImageView *iconImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreen_height/3, 60, 60)];
    iconImgV.image = [UIImage imageNamed:@"islogin_icon"];
    iconImgV.centerX = kScreen_width/2;
    [self.view addSubview:iconImgV];
    
    UILabel *loginMarkL = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImgV.bottom+10, 150, 25)];
    loginMarkL.centerX = iconImgV.centerX;
    loginMarkL.text = @"您还未登录,赶紧登陆吧～";
    loginMarkL.textAlignment = NSTextAlignmentCenter;
    loginMarkL.font = [UIFont systemFontOfSize:kFontSize_3];
    [self.view addSubview:loginMarkL];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(kLoginBtn_left, kScreen_height-49-2*kLoginBtn_height-80, kScreen_width-2*kLoginBtn_left, kLoginBtn_height);
    loginBtn.backgroundColor = kRedColor;
    [loginBtn setTitle:@"立即登陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    loginBtn.layer.cornerRadius = 5;
    [loginBtn addTarget:self action:@selector(clickLoginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registBtn.frame = CGRectMake(loginBtn.left, loginBtn.bottom+30, loginBtn.width, loginBtn.height);
    registBtn.backgroundColor = [UIColor whiteColor];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    registBtn.layer.cornerRadius = 5;
    [registBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
}

-(void)registAction
{
    RegistViewController *registVC = [[RegistViewController alloc] init];
    registVC.isRegist = YES;
    [self.navigationController pushViewController:registVC animated:YES];
}

-(void)clickLoginBtnAction:(UIButton *)button
{
//    LoginViewController *loginVC = [[LoginViewController alloc] init];
//    [self.navigationController pushViewController:loginVC animated:YES];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
   
    loginVC.loginSuccessBlock = ^{
        self.tabBarController.selectedIndex = 3;
    };


   
}

-(void)noLoginVCPopAction
{
    if (self.dissmissBlock) {
        self.dissmissBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
