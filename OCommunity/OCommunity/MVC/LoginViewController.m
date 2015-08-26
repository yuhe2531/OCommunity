//
//  LoginViewController.m
//  Broker
//
//  Created by peng on 14/12/26.
//  Copyright (c) 2014年 zhangyan. All rights reserved.
//
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "RegistViewController.h"
#import "FindPassWordViewController.h"
#import "MineViewController.h"
#import "LoginSubView.h"
#import "BPush.h"

#define KControlHeight 40
@interface LoginViewController ()
{
    UIScrollView *_myScrollView;
    
    UITextField *login_user;
    UITextField *login_password;
}

@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //自定义一个导航栏
    self.navigationController.navigationBar.barTintColor = kRedColor;
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"登录"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(loginBack)];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-64)];
    _myScrollView.backgroundColor = [UIColor whiteColor];
    _myScrollView.contentSize = CGSizeMake(kScreen_width, _myScrollView.height);
    [self.view addSubview:_myScrollView];
    
    [self addLoginSubviews];
}

#define kRegistBtn_width 60
#define kRegistBtn_height 30
#define kLoginBtn_height 45
#define kPWBtn_width 70
#define kPWBtn_height 20

#define kTopImageV_top 60
#define kLogin_user_height 40

-(void)addLoginSubviews
{
    UIImageView *topImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 80)];
    topImageV.image = [UIImage imageNamed:@"icon2"];
    topImageV.centerX = kScreen_width/2;
    [_myScrollView addSubview:topImageV];
    
    login_user = [[UITextField alloc] initWithFrame:CGRectMake(0, topImageV.bottom+30, kScreen_width-70, kLogin_user_height)];
    login_user.delegate = self;
    login_user.returnKeyType = UIReturnKeyDone;
    login_user.textColor = kBlack_Color_2;
    login_user.centerX = kScreen_width/2;
    login_user.backgroundColor = kBackgroundColor;
    login_user.layer.cornerRadius = 5;
    login_user.placeholder = @"请输入手机号";
    [_myScrollView addSubview:login_user];
    
    login_password = [[UITextField alloc] initWithFrame:CGRectMake(login_user.left, login_user.bottom+20, login_user.width, login_user.height)];
    login_password.delegate = self;
    login_password.returnKeyType = UIReturnKeyDone;
    login_password.textColor = kBlack_Color_2;
    login_password.backgroundColor = kBackgroundColor;
    login_password.layer.cornerRadius = 5;
    login_password.placeholder = @"请输入密码";
    login_password.secureTextEntry = YES;
    [_myScrollView addSubview:login_password];
    for (int i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, login_password.height)];
        if (i == 0) {
            login_user.leftView = view;
            login_user.leftViewMode = UITextFieldViewModeAlways;
        } else {
            login_password.leftView = view;
            login_password.leftViewMode = UITextFieldViewModeAlways;
        }
    }
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registBtn.frame = CGRectMake(login_user.left, login_password.bottom+20, kRegistBtn_width, kRegistBtn_height);
    [registBtn setTitle:@"免费注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:kRedColor forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    [registBtn addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_myScrollView addSubview:registBtn];
    
    UIButton *pwBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    pwBtn.frame = CGRectMake(kScreen_width-(kScreen_width-login_password.width)/2-kPWBtn_width, registBtn.top, kPWBtn_width, kPWBtn_height);
    [pwBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [pwBtn setTitleColor:kRedColor forState:UIControlStateNormal];
    pwBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    [pwBtn addTarget:self action:@selector(findPasswordButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, pwBtn.height, pwBtn.width, 0.5)];
    line.backgroundColor = kRedColor;
    [pwBtn addSubview:line];
    [_myScrollView addSubview:pwBtn];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(0, pwBtn.bottom+kTopImageV_top, login_user.width, kLoginBtn_height);
    loginBtn.layer.cornerRadius = 5;
    loginBtn.centerX = kScreen_width/2;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = kColorWithRGB(255, 87, 87);
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    [loginBtn addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_myScrollView addSubview:loginBtn];
    
    _myScrollView.contentSize = CGSizeMake(kScreen_width, topImageV.height+2*login_user.height+registBtn.height+loginBtn.height+3*kTopImageV_top+40);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyboardWillShow:(NSNotification *)noti
{
    CGFloat keyboardHeight = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:0.5 animations:^{
        _myScrollView.frame = CGRectMake(0, 64, kScreen_width, kScreen_height-64-keyboardHeight);
    }];
}

-(void)keyboardWillHide:(NSNotification *)noti
{
    [UIView animateWithDuration:0.5 animations:^{
        _myScrollView.frame = CGRectMake(0, 64, kScreen_width, kScreen_height-64);
        _myScrollView.contentOffset = CGPointMake(0, 0);
        
    }];
}

-(void)loginBack
{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    if (!_isPresent) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [login_user resignFirstResponder];
        [login_password resignFirstResponder];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)dismissClick{

    if (self.dismissBlock) {
        self.dismissBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [login_user becomeFirstResponder];
}


-(void)registerButtonClick{
//注册页面
    RegistViewController *registVC = [[RegistViewController alloc] init];
    registVC.isRegist = YES;
    registVC.callBackBlcok = ^(NSString *name,NSString *password){
        login_user.text = name;
        login_password.text = password;
//        [login_password becomeFirstResponder];
        [self loginButtonClick];

        
    };
    [self.navigationController pushViewController:registVC animated:YES];

}
-(void)findPasswordButtonClick{
    //找回页面
    RegistViewController *registVC = [[RegistViewController alloc] init];
    registVC.isRegist = NO;
    registVC.callBackBlcok = ^(NSString *name,NSString *password){
        
        login_user.text = name;
        login_password.text = password;
        //        [login_password becomeFirstResponder];
        [self loginButtonClick];
        
    };
    [self.navigationController pushViewController:registVC animated:YES];
    
}

-(void)callBackAction:(NSString *)account
{
    login_user.text = account;
}

#define 输入框代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == login_password) {
        [self loginButtonClick];
    }
    [textField resignFirstResponder];
    return YES;
}

-(void)loginButtonClick{
    
    if (login_user.text > 0 && login_password.text.length > 0) {
        [self loginRequest];
    } else {
        [self.view makeToast:@"请输入用户名和密码" duration:1.5 position:@"center"];
    }
}

-(void)loginRequest
{
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *para = [NSString stringWithFormat:@"username=%@&password=%@",login_user.text,login_password.text];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=login"] postData:para];
    __weak LoginViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *dataDic){
        NSLog(@"========= login data = %@",dataDic);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSDictionary *dataDictory = [dataDic objectForKey:@"datas"];
    
        NSNumber *islogin = [dataDic objectForKey:@"islogin"];
        int loginSuc = [islogin intValue];//登陆成功码
        NSNumber *code = [dataDic objectForKey:@"code"];
        int loginCode = [code intValue];//请求数据成功代码号
        if (loginCode==200) {
            NSNumber *cartCount = [dataDic objectForKey:@"membershopcarcount"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",cartCount.integerValue] forKey:@"local_cartGoodsCount"];
            if (loginSuc==1) {
                
                //登录成功后绑定百度云（防止不登录是也会发送推送消息）
                [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
                    NSLog(@"============= baidu remote push = %@",result);
                }];
                
                NSNumber *memberID = [dataDictory objectForKey:@"member_id"];
                NSString *member_id = [NSString stringWithFormat:@"%d",memberID.intValue];
                [[NSUserDefaults standardUserDefaults] setObject:member_id forKey:@"member_id"];
                NSLog(@"登陆成功");
                [weakSelf.view makeToast:@"登陆成功" duration:1.5 position:@"center"];
                NSNumber *telephone = [dataDictory objectForKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] setObject:telephone forKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
                [[NSUserDefaults standardUserDefaults] setObject:login_password.text forKey:@"password"];
                if (weakSelf.loginSuccessBlock) {
                    weakSelf.loginSuccessBlock();
                }
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                
            }
        }else{
            [weakSelf.view makeToast:@"用户名或密码错误" duration:1 position:@"center"];
        }
        
    };
    request.failureRequest = ^(NSError *error){
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





