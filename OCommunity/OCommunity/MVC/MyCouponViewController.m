//
//  MyCouponViewController.m
//  OCommunity
//
//  Created by runkun3 on 15/7/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MyCouponViewController.h"
#import "MyCouponCell.h"
#import "MyCouponModel.h"
#import "MJRefresh.h"
#import "CouponRuleViewController.h"

@interface MyCouponViewController ()<UIGestureRecognizerDelegate>

@end

@implementation MyCouponViewController
{
    NSMutableArray *couponArray;
    MyCouponModel *couponModel;
    int _currentPage;
    int _totalPage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"我的优惠券"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(myCouponPop)];
    
    
    UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    ruleBtn.frame = CGRectMake(0, 0, 60, 25);
    [ruleBtn setTitle:@"使用规则" forState:UIControlStateNormal];
    [ruleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ruleBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    [ruleBtn addTarget:self action:@selector(ruleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:ruleBtn];
    
    //点击空白处收键盘
    _currentPage = 1;
    couponArray = [[NSMutableArray alloc]init];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    [self creatMyCouponView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self myCouponRequest];
   
}

-(void)ruleBtnAction
{
    CouponRuleViewController *ruleVC = [[CouponRuleViewController alloc] init];
    [self.navigationController pushViewController:ruleVC animated:YES];
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [_textFied resignFirstResponder];
}
-(void)creatMyCouponView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64+80, kScreen_width, kScreen_height-64-80)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kBackgroundColor;
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 50)];
    _tableView.tableFooterView = _bottomView;

    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreen_width, 80)];
    _topView.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 78, kScreen_width, 2)];
    line.backgroundColor = kColorWithRGB(220, 220, 220);
    _textFied = [[UITextField alloc]initWithFrame:CGRectMake(15, 20, kScreen_width*2/3, 40)];
    _textFied.backgroundColor = [UIColor whiteColor];
    _textFied.placeholder = @"     请输入兑换码或邀请码";
    _textFied.delegate = self;
    _textFied.returnKeyType = UIReturnKeyDone;
    _textFied.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFied.borderStyle = UITextBorderStyleRoundedRect;
    _textFied.layer.cornerRadius = 5;
    UIButton *convert = [UIButton buttonWithType:UIButtonTypeSystem];
    convert.frame = CGRectMake(_textFied.right+15, 20, 70, 40);
    convert.layer.cornerRadius = 8;
    [convert setTitle:@"兑换" forState:UIControlStateNormal];
    [convert setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    convert.backgroundColor = kRedColor;
    convert.titleLabel.font = [UIFont systemFontOfSize:kFontSize_1];
    [convert addTarget:self action:@selector(convertAction) forControlEvents:UIControlEventTouchUpInside];
    __weak MyCouponViewController *weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        if (!weakSelf.isRefresh) {
            _isDelete = YES;
            weakSelf.isRefresh = YES;
            _currentPage = 1;
            [weakSelf myCouponRequest];
            

        }
        
    }];

    [_topView addSubview:convert];
    [_topView addSubview:_textFied];
    [_topView addSubview:line];
    [self.view addSubview:_tableView];
    [self.view addSubview:_topView];
}
//会员已经领取的优惠券请求
-(void)myCouponRequest{
    [YanMethodManager removeEmptyViewOnView:_tableView];
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *para =[NSString stringWithFormat:@"member_id=%@&pagenumber=%d&pagesize=%d",member_id,_currentPage,10];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api_coupon.php?commend=member_coupons_list"] postData:para];
    __weak MyCouponViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *requestDic){
        NSLog(@"我的优惠券列表:%@",requestDic);
        if (_isDelete) {
            [couponArray removeAllObjects];
        }
        
        weakSelf.isRefresh = NO;
        [weakSelf.tableView.header endRefreshing];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [YanMethodManager hideIndicatorFromView:_tableView];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSNumber *number = [requestDic objectForKey:@"code"];
        int code = [number intValue];
        if (code==200) {
            _textFied.text = nil;
            NSNumber *totalCount = [requestDic objectForKey:@"count"];
            int remainder = totalCount.intValue % 10;
            if (remainder > 0) {
                _totalPage = totalCount.intValue/10 + 1;
            } else {
                _totalPage = totalCount.intValue/10;
            }
            NSArray *datasArr = [requestDic objectForKey:@"datas"];
            if (datasArr.count==0) {
                [YanMethodManager emptyDataInView:_tableView title:@"暂无优惠券"];
            }else{
                for (int i = 0; i < datasArr.count; i++) {
                    NSDictionary *itemDic = datasArr[i];
                    couponModel = [[MyCouponModel alloc] initWithDictionary:itemDic];
                    [couponArray addObject:couponModel];
                }
                
            }
            NSString *haveMore = [requestDic objectForKey:@"haveMore"];
            if ([haveMore isEqualToString:@"true"]) {
                [self loadMoreHandleInView:_bottomView];
            } else {
                [self loadMoreHasDoneHandleInView:_bottomView];
            }
            if (_isLoading) {
                _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, _tableView.contentOffset.y+30);
            }
            _isLoading = NO;
            
            [_tableView reloadData];
        }
    };
    request.failureRequest = ^(NSError *error){
         _isLoading = NO;
        [weakSelf.tableView.header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.view makeToast:@"网络异常，请尝试下拉刷新" duration:1.5 position:@"center"];
    };
}
-(void)convertAction{
    if (_textFied.text.length >0) {
        [self convertButtonRequest];
    }else{
        [self.view makeToast:@"请输入兑换码" duration:1.5 position:@"center"];
    }    
//    NSLog(@"兑换成功了～～～～～");
}
-(void)convertButtonRequest{
    __weak MyCouponViewController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *para = [NSString stringWithFormat:@"member_id=%@&coupon_sn=%@",member_id,_textFied.text];
    NSString *url = [kHostHttp stringByAppendingPathComponent:@"mobile/api_coupon.php?commend=use_coupons_sn"];
    [request requestForPOSTWithUrl:url postData:para];
    request.successRequest = ^(NSDictionary *requestDic){
        NSLog(@"兑换接口%@",requestDic);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSString *data = [requestDic objectForKey:@"datas"];
        NSNumber *codeNum = [requestDic objectForKey:@"code"];
        int code = [codeNum intValue];
        if (code==200) {
            if ([data intValue]==200) {
                _currentPage=1;
                _isDelete = YES;
                [weakSelf myCouponRequest];
                [self.view makeToast:@"恭喜您领取成功" duration:1.5 position:@"center"];
            }else if([data intValue]==202){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.view makeToast:@"您的手慢了，优惠券已被抢光" duration:1.5 position:@"center"];
            }else if([data intValue]==203){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.view makeToast:@"兑换码已过期" duration:1.5 position:@"center"];

            }else if([data intValue]==204){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.view makeToast:@"此优惠码已经被兑换了，不可重复兑换" duration:1.5 position:@"center"];

            }else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.view makeToast:@"兑换码不正确" duration:1.5 position:@"center"];

            }
            
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.view makeToast:@"请检查网络连接" duration:1.5 position:@"center"];
        }
        
    };
    request.failureRequest = ^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.view makeToast:@"加载失败，请检查网络连接" duration:1.5 position:@"center"];
    };
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return couponArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identy = @"identy";
    MyCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (!cell) {
        cell = [[MyCouponCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MyCouponModel *model = [couponArray objectAtIndex:indexPath.row];
    cell.couponModel = model;
    
    if (cell.couponModel.is_use==0) {
        if (cell.couponModel.is_guoqi==0) {
            cell.used = NO;
            cell.overData=NO;
        }else{
            cell.overData=YES;
        }
    }else{
        cell.used = YES;
    }
    
    return cell;
    
}

#define 输入框代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _textFied) {
        [self convertAction];
    }
    [textField resignFirstResponder];
    return YES;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [_textFied resignFirstResponder];
    
}
//滚动到最后一行刷新数据
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"上拉%f",_tableView.contentSize.height-_tableView.contentOffset.y);
    NSLog(@"23223%f",_tableView.height);
    if (_tableView.contentSize.height-_tableView.contentOffset.y <= _tableView.height) {
        if (_currentPage < _totalPage) {
            NSLog(@"asddjadjhajhgd%d",_totalPage);
            if (!_isLoading) {
                _isLoading = YES;
                _isDelete = NO;
                ++_currentPage;
                [self myCouponRequest];
                
            }
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)myCouponPop
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadMoreHandleInView:(UIView *)view
{
    if (_totalPage > 1) {
        [view removeAllSubviews];
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake(0, 0, 25, 25);
        activityView.center = CGPointMake(view.width/2, view.height/2);
        [view addSubview:activityView];
        [activityView startAnimating];
        _tableView.tableFooterView = _bottomView;
    }
}

-(void)loadMoreHasDoneHandleInView:(UIView *)view
{
    [view removeAllSubviews];
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.text = @"暂无更多优惠券";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kBlack_Color_3;
    label.font = [UIFont systemFontOfSize:kFontSize_3];
    [view addSubview:label];
    _tableView.tableFooterView = _bottomView;
    
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
