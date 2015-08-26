//
//  RegistViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/13.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "RegistViewController.h"
#import "LoginCell.h"
#import "VertifyCodeCell.h"
#import "NetWorkRequest.h"
#import "AppDelegate.h"
#import "BPush.h"

@interface RegistViewController ()<UIGestureRecognizerDelegate>

{
    NSInteger timeSeconds;
    char *_userName;
    char *_passWord;
}

@property (nonatomic, strong) VertifyCodeCell *numberCell;
@property (nonatomic, strong) VertifyCodeCell *codeCell;
@property (nonatomic, strong) VertifyCodeCell *passwordCell;
@property (nonatomic, strong) VertifyCodeCell *vertifyPassCell;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger isCoupon;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(registVCPop)];
    NSString *naviTitle = _isRegist ? @"手机号注册" : @"找回密码";
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:naviTitle];
    
    [self createRegistSubviews];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

#define kCell_height 45
#define kBottomView_height 120
#define kRegistBtn_height 40

-(void)createRegistSubviews
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kBottomView_height)];
    bottomView.backgroundColor = [UIColor whiteColor];
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registBtn.frame = CGRectMake(15, kBottomView_height-kRegistBtn_height-40, kScreen_width-30, kRegistBtn_height);
    registBtn.layer.cornerRadius = 5;
    registBtn.backgroundColor = kRedColor;
    [registBtn setTitle:@"完成" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_1];
    [registBtn addTarget:self action:@selector(registerAccountAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:registBtn];
    tableView.tableFooterView = bottomView;
    
}

#define kTableView_cell_height 55

#pragma mark UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableView_cell_height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak RegistViewController *weakSelf = self;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:{
            _numberCell = [[VertifyCodeCell alloc] initWithFrame:CGRectMake(15, 15, kScreen_width-30, 35) title:@"手   机   号"];
            _numberCell.codeTF.width = _numberCell.width - 30;
            [_numberCell.codeLabel removeFromSuperview];
            [cell.contentView addSubview:_numberCell];
        }
            break;
        case 1:{
                _codeCell = [[VertifyCodeCell alloc] initWithFrame:CGRectMake(15, 15, kScreen_width-30, 35) title:@"验   证   码"];
                _codeCell.codeBtnBlock = ^{
                    //一分钟倒计时
                    if ([[YanMethodManager defaultManager] validateMobile:_numberCell.codeTF.text] == NO) {
                        [weakSelf.view makeToast:@"手机号格式错误" duration:1.5 position:@"center"];
                    } else {
                        if (weakSelf.isRegist) {//获取注册验证码
                            [weakSelf requestRegistMessageCode];
                        } else {//获取找回密码验证码
                            [weakSelf requestFindPasswordVertifyCode];
                        }
                    }
                };
                [cell.contentView addSubview:_codeCell];
        }
            break;
        case 2:{
                _passwordCell = [[VertifyCodeCell alloc] initWithFrame:CGRectMake(15, 15, kScreen_width-30, 35) title:@"密        码"];
                _passwordCell.codeTF.secureTextEntry = YES;
                _passwordCell.codeTF.width = _passwordCell.width - 30;
                [_passwordCell.codeLabel removeFromSuperview];
                [cell.contentView addSubview:_passwordCell];

        }
            break;
        case 3:{
                _vertifyPassCell = [[VertifyCodeCell alloc] initWithFrame:CGRectMake(15, 15, kScreen_width-30, 35) title:@"确 认 密 码"];
                _vertifyPassCell.codeTF.secureTextEntry = YES;
                _vertifyPassCell.codeTF.width = _vertifyPassCell.width - 30;
                [_vertifyPassCell.codeLabel removeFromSuperview];
                [cell.contentView addSubview:_vertifyPassCell];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

-(void)registerAccountAction
{
    
    if (_codeCell.codeTF.text.length > 0 && [_passwordCell.codeTF.text isEqualToString:_vertifyPassCell.codeTF.text]) {
        if (_isRegist) {
            [YanMethodManager showIndicatorOnView:self.view];
            NSString *unicode = [[UIDevice currentDevice].identifierForVendor UUIDString];
            NSLog(@"======== unicode = %@",unicode);
            NetWorkRequest *request = [[NetWorkRequest alloc]init];
            NSString *para = [NSString stringWithFormat:@"member_name=%@&password=%@&code=%@&phone_code=%@",_numberCell.codeTF.text,_passwordCell.codeTF.text,_codeCell.codeTF.text,unicode];
            [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"index.php?act=reg&op=register"] postData:para];
            request.successRequest = ^(NSDictionary *dataDic){
                NSLog(@"========= regist dic = %@",dataDic);
                NSNumber *code = [dataDic objectForKey:@"code"];
                if (code.integerValue == 200) {
                    NSDictionary *datasDic = [dataDic objectForKey:@"datas"];
                    NSString *haveUser = [datasDic objectForKey:@"haveUser"];
                    if ([haveUser isEqualToString:@"true"]) {
                        NSNumber *iscoupon = [datasDic objectForKey:@"iscoupon"];
                        if (iscoupon.integerValue == 1 && [iscoupon isKindOfClass:[NSNull class]]==NO) {
                            _isCoupon = iscoupon.integerValue;
                        }
                        [self loginRequest];
                    } else {
                        [self.view makeToast:@"您已注册过,请直接登录" duration:1.0 position:@"center"];
                    }
                }else if(code.integerValue == 201){
                    [YanMethodManager hideIndicatorFromView:self.view];
                 [self.view makeToast:@"验证码错误" duration:1.5 position:@"center"];
                    
                }
                else {
                    [YanMethodManager hideIndicatorFromView:self.view];
                    [self.view makeToast:@"注册失败" duration:1.5 position:@"center"];
                }
            };
            request.failureRequest =^(NSError *error){
            
                [YanMethodManager hideIndicatorFromView:self.view];

            
            };
            
        } else {
            [self requestFindPsswordMessageCode];
        }
    } else {
        [self.view makeToast:@"请检查两次输入的密码是否一致或填写验证码" duration:1.0 position:@"center"];
    }
}

//获取短信验证码--注册
-(void)requestRegistMessageCode
{
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"index.php?act=reg&op=sendmessage"] postData:[NSString stringWithFormat:@"mobile=%@",_numberCell.codeTF.text]];
    request.successRequest = ^(NSDictionary *requestDic){
        NSLog(@"=========== code dic = %@",requestDic);
        NSNumber *code = [requestDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSDictionary *dataDic = [requestDic objectForKey:@"datas"];
            NSString *sendSuc = [dataDic objectForKey:@"send"];
            NSLog(@"========= send str = %@",sendSuc);
            if ([sendSuc isEqualToString:@"success"]) {
                timeSeconds = 60;
                self.codeCell.codeLabel.backgroundColor = [UIColor lightGrayColor];
                self.codeCell.codeBtn.enabled = NO;
                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
            } else {
                [self.view makeToast:@"该手机号已经注册过,请重新注册" duration:1.5 position:@"center"];
            }
        }
    };
}

//获取找回密码验证码
-(void)requestFindPasswordVertifyCode
{
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"index.php?act=reg&op=forgetsendmessage"] postData:[NSString stringWithFormat:@"mobile=%@",_numberCell.codeTF.text]];
    request.successRequest = ^(NSDictionary *findDic){
        NSLog(@"============ find dic = %@",findDic);
        NSNumber *code = [findDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSDictionary *datasDic = [findDic objectForKey:@"datas"];
            NSString *haveUser = [datasDic objectForKey:@"haveUser"];
            if ([haveUser isEqualToString:@"true"]) {
                timeSeconds = 60;
                self.codeCell.codeLabel.backgroundColor = [UIColor lightGrayColor];
                self.codeCell.codeBtn.enabled = NO;
                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
            } else {
                [self.view makeToast:@"您还没有注册过,请先注册" duration:1.0 position:@"center"];
            }
        }
    };
}

//找回密码
-(void)requestFindPsswordMessageCode
{
    if ([[YanMethodManager defaultManager] validateMobile:_numberCell.codeTF.text]) {
        if ([_passwordCell.codeTF.text isEqualToString:_vertifyPassCell.codeTF.text]) {
            [YanMethodManager showIndicatorOnView:self.view];
            NetWorkRequest *request = [[NetWorkRequest alloc] init];
            [request requestForPOSTWithUrl:@"http://app.lingbushequ.com/index.php?act=reg&op=forgetpwd" postData:[NSString stringWithFormat:@"mobile=%@&password=%@&fcode=%@",_numberCell.codeTF.text,_passwordCell.codeTF.text,_codeCell.codeTF.text]];
            request.successRequest = ^(NSDictionary *requestDic){
                NSLog(@"======== find pass = %@",requestDic);
                NSNumber *code = [requestDic objectForKey:@"code"];
                if (code.integerValue == 200) {
                    NSNumber *datas = [requestDic objectForKey:@"datas"];
                    if (datas.integerValue == 1) {
                        [self loginRequest];
                        
                    } else {
                        [self.view makeToast:@"找回密码失败" duration:1.0 position:@"center"];
                        [YanMethodManager hideIndicatorFromView:self.view];
                    }
                }
                if (code.integerValue == 201) {
                    [self.view makeToast:@"您还没有注册,请先注册" duration:1.0 position:@"center"];
                    [YanMethodManager hideIndicatorFromView:self.view];


                }
                if (code.integerValue == 202) {
                    [self.view makeToast:@"验证码输入错误" duration:1.0 position:@"center"];
                    [YanMethodManager hideIndicatorFromView:self.view];


                }
            };
            request.failureRequest =^(NSError *error){
                
                [YanMethodManager hideIndicatorFromView:self.view];

                
                
            };

        } else {
            [self.view makeToast:@"两次密码不一致,请重新输入" duration:1.0 position:@"center"];

        }
    } else {
        [self.view makeToast:@"手机号格式不正确" duration:1.5 position:@"center"];
    }
    
}
-(void)loginRequest
{
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *para = [NSString stringWithFormat:@"username=%@&password=%@",_numberCell.codeTF.text,_passwordCell.codeTF.text];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=login"] postData:para];
    __weak RegistViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *dataDic){
        NSLog(@"========= login data = %@",dataDic);
        [YanMethodManager hideIndicatorFromView:self.view];

        NSDictionary *dataDictory = [dataDic objectForKey:@"datas"];
        
        NSNumber *islogin = [dataDic objectForKey:@"islogin"];
        int loginSuc = [islogin intValue];//登陆成功码
        NSNumber *code = [dataDic objectForKey:@"code"];
        int loginCode = [code intValue];//请求数据成功代码号
        if (loginCode==200) {
            NSNumber *cartCount = [dataDic objectForKey:@"membershopcarcount"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",cartCount.integerValue] forKey:@"local_cartGoodsCount"];
            if (loginSuc==1) {
                if (_isCoupon == 1) {
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.window makeToast:@"您获得了一个新用户奖励优惠券,快去我的优惠券看看吧!!" duration:2.5 position:@"center"];
                }
                
                [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
                    NSLog(@"regist success binding result = %@",result);
                }];
                
                NSNumber *memberID = [dataDictory objectForKey:@"member_id"];
                NSString *member_id = [NSString stringWithFormat:@"%d",memberID.intValue];
                [[NSUserDefaults standardUserDefaults] setObject:member_id forKey:@"member_id"];
                NSLog(@"登陆成功");
//                [weakSelf.view makeToast:@"登陆成功" duration:1.5 position:@"center"];
                NSNumber *telephone = [dataDictory objectForKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] setObject:telephone forKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
                [[NSUserDefaults standardUserDefaults] setObject:_passwordCell.codeTF.text forKey:@"password"];

                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                
            }
        }
    };
    request.failureRequest = ^(NSError *error){
        [YanMethodManager hideIndicatorFromView:self.view];

    };
}

//验证码倒计时
-(void)countDownAction
{
    if (timeSeconds > 0) {
        timeSeconds--;
        _codeCell.codeLabel.text = [NSString stringWithFormat:@"验证码(%ld)",timeSeconds];
    } else {
        [_timer invalidate];
        _codeCell.codeLabel.backgroundColor = kRedColor;
        _codeCell.codeBtn.enabled = YES;
        _codeCell.codeLabel.text = @"获取验证码";
    }
}

-(void)registVCPop
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
