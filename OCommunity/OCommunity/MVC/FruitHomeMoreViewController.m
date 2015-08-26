//
//  FruitHomeMoreViewController.m
//  OCommunity
//
//  Created by runkun2 on 15/7/4.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "FruitHomeMoreViewController.h"
#import "FruitHomeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CartViewController.h"
#import "HomeGoodsItem.h"
#import "LoginViewController.h"
#import "PayRightNowViewController.h"
#define kBottomView_height 40
#define kPageSize 10

@interface FruitHomeMoreViewController ()<UIGestureRecognizerDelegate>
{
    UITableView *_tableView;
    NSMutableArray *subviewDataArray;
    int _currentPage;
    int _totalPage;
    UIView *_bottomView;
}
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) CGPoint tapPoint;
@property(nonatomic,assign)BOOL marketIsLogin;
@end

@implementation FruitHomeMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"超值购"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(makeHomePop)];
    _currentPage = 1;
    [self createTableViewSubview];
    subviewDataArray = [[NSMutableArray alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadSubviewData];
}
-(void)createTableViewSubview{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height - 64)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kBottomView_height)];
    _tableView.tableFooterView = _bottomView;


    [self.view addSubview:_tableView];
}
-(void)loadSubviewData{

    NSDictionary *marketDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [marketDic objectForKey:@"store_id"];

    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *para = [NSString stringWithFormat:@"pagenumber=%d&pagesize=%d&store_id=%@",_currentPage,kPageSize,store_id];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=fruitlistmore"] postData:para];
    request.successRequest = ^(NSDictionary *dataDic){
        NSLog(@"akckakadkahk%@",dataDic);
        _isLoading = NO;
        NSNumber *code = [dataDic objectForKey:@"code"];
        int numCode = [code intValue];//请求数据成功代码号
        if (numCode==200) {
            
            NSNumber *totalCount = [dataDic objectForKey:@"count"];
            
            int remainder = totalCount.intValue % kPageSize;
            if (remainder > 0) {
                _totalPage = totalCount.intValue/kPageSize + 1;
            } else {
                _totalPage = totalCount.intValue/kPageSize;
            }
            for (NSDictionary *dic in [dataDic objectForKey:@"datas"]) {
            
                HomeGoodsItem *item = [[HomeGoodsItem alloc] initWithDic:dic];
                [subviewDataArray addObject:item];
            }
            NSString *haveMore = [dataDic objectForKey:@"haveMore"];
            if ([haveMore isEqualToString:@"true"]) {
                [self loadMoreHandleInView:_bottomView];
            } else{
                [self loadMoreHasDoneHandleInView:_bottomView];
            }

        [_tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    };
    
    request.failureRequest = ^(NSError *error){
        _isLoading = NO;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    };



}
-(void)loadMoreHandleInView:(UIView *)view
{
    if (_totalPage > 1) {
        [view removeAllSubviews];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 1, kScreen_width, 0.5)];
        line.backgroundColor = kDividColor;
        [_bottomView addSubview:line];
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
    label.text = @"暂无更多数据";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:kFontSize_3];
    label.textColor = kDividColor;
    [view addSubview:label];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 1, kScreen_width, 0.5)];
    line.backgroundColor = kDividColor;
    [_bottomView addSubview:line];
    _tableView.tableFooterView = _bottomView;
    
}
#pragma mark UITableView
//滚动到最后一行自动刷新数据
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
       if (_tableView.contentSize.height-_tableView.contentOffset.y <= _tableView.height){
        if (_currentPage < _totalPage) {
            if (!_isLoading) {
                _isLoading = YES;
                ++_currentPage;
                [self loadSubviewData];
            }
        }
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return subviewDataArray.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"fruitsCell";
    FruitHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[FruitHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell.selectCountView.countLabel
    HomeGoodsItem *model = [subviewDataArray objectAtIndex:indexPath.row];
    cell.goodsItem = model;
    __weak FruitHomeTableViewCell *newCell = cell;
    __weak FruitHomeMoreViewController *weakSelf = self;
    cell.fruitActionBlock = ^(UITapGestureRecognizer *tap){
        [YanMethodManager showIndicatorOnView:_tableView];
        NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
        //加入购物车判断所选商品数量是否大于0
        if (newCell.selectCountView.countLabel.text.integerValue > 0) {
            //加入购物车判断是否登录状态
            if (member_id!=NULL) {
            
                [weakSelf fruitAddIntoCartWithItem:model cell:newCell tap:tap];
            }else{
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                loginVC.isPresent = YES;
                __weak FruitHomeMoreViewController *weakSelf = self;
                loginVC.dismissBlock = ^{
                    [YanMethodManager hideIndicatorFromView:weakSelf.view];
                };
                loginVC.loginSuccessBlock = ^{
                    
                    [weakSelf fruitAddIntoCartWithItem:model cell:newCell tap:tap];
                };
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self.tabBarController presentViewController:navi animated:NO completion:nil];            }
        }
        else {
            [self.view makeToast:@"请选择购买数量" duration:1 position:@"center"];
        }
    };
    return cell;

}
-(void)fruitAddIntoCartWithItem:(HomeGoodsItem *)item cell:(FruitHomeTableViewCell *)cell tap:(UITapGestureRecognizer *)tap
{
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NSString *para = [NSString stringWithFormat:@"goods_id=%d&quantity=%d&member_id=%@",item.goods_id,cell.selectCountView.countLabel.text.intValue,member_id];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addshopcar"] postData:para];
    __weak FruitHomeMoreViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *dataDic)
    {
        [YanMethodManager hideIndicatorFromView:self.view];
        NSNumber *codeNum = [dataDic objectForKey:@"code"];
        int code = [codeNum intValue];
        if (code == 200) {
            NSNumber *count = [dataDic objectForKey:@"count"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",count.integerValue] forKey:@"local_cartGoodsCount"];
            for (UINavigationController *navi in self.tabBarController.viewControllers) {
                if ([navi.topViewController isKindOfClass:[CartViewController class]]) {
                    navi.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",count.integerValue];
                }
            }
            [weakSelf.view makeToast:@"已加入购物车" duration:1 position:@"center"];
            
            
        }else if(code == 203){
            
            [weakSelf.view makeToast:@"购物车已满，请删除部分商品后重新加入" duration:1 position:@"center"];
            
        }else
        {
            [weakSelf.view makeToast:@"加入购物车失败" duration:1 position:@"center"];
        }
    };
    request.failureRequest = ^(NSError *error){
        [weakSelf.view makeToast:@"加入购物车失败" duration:.8 position:@"center"];
    };
}

-(void)removeImageView:(UIImageView *)imageView
{
    [imageView removeFromSuperview];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_marketIsLogin) {
        _marketIsLogin  = YES;
        [self systemIsOpenHandleFruitIndext:indexPath tableView:tableView];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//立即购买前先判断超市系统状态
-(void)systemIsOpenHandleFruitIndext:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    [YanMethodManager showIndicatorOnView:self.view];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [storeDic objectForKey:@"store_id"];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=isopenstore"] postData:[NSString stringWithFormat:@"store_id=%@",store_id]];
    __weak FruitHomeMoreViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *packageDic){
        _marketIsLogin = NO;
        [YanMethodManager hideIndicatorFromView:weakSelf.view];
        NSLog(@"===== package dic = %@",packageDic);
        NSNumber *code = [packageDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSNumber *isOpen = [packageDic objectForKey:@"isopen"];
            if (isOpen.integerValue == 1) {
                HomeGoodsItem *dataModel = [subviewDataArray objectAtIndex:indexPath.row];
                FruitHomeTableViewCell *cell = (FruitHomeTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
                NSString *count = cell.selectCountView.countLabel.text;
                [self isLoginHandle:^{
                    [weakSelf loginPayRightNow:dataModel withCount:count];
                } hasLogin:^{
                    [weakSelf loginPayRightNow:dataModel withCount:count];
                }];

                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲!店家已打烊,若有急需请电联" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"打电话", nil];
                [alert show];
            }
        }
    };
    request.failureRequest = ^(NSError *error){
        [YanMethodManager hideIndicatorFromView:weakSelf.view];
        _marketIsLogin = NO;
    };
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex ==1) {
        NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
        NSString *telNum = [storeDic objectForKey:@"telephone"];
        
        [[YanMethodManager defaultManager] callPhoneActionWithNum:telNum viewController:self];
        
    }
}
//购买前判断是否登录状态
-(void)loginPayRightNow:(HomeGoodsItem *)goodsModel withCount:(NSString *)count{
    NSDictionary *marketDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *marketName = [marketDic objectForKey:@"store_name"];
    PayRightNowViewController *payVC = [[PayRightNowViewController alloc] init];
    payVC.goods_name = goodsModel.goods_name;
    payVC.market_name = marketName;
    payVC.price = [NSString stringWithFormat:@"%.1f",goodsModel.goods_price];
    payVC.count = count;
    payVC.goods_id = goodsModel.goods_id;
    payVC.store_id = goodsModel.store_id;
    payVC.isHotGoods = NO;
    [self.navigationController pushViewController:payVC animated:YES];

}
-(void)isLoginHandle:(void(^)(void))loginSuccess hasLogin:(void(^)(void))hasLoginHandle
{
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    if (member_id == NULL) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.isPresent = YES;
        loginVC.loginSuccessBlock = ^{
            loginSuccess();
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.tabBarController presentViewController:nav animated:YES completion:nil];
    } else {
        hasLoginHandle();
    }
}

-(void)makeHomePop{
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)login{
    
   
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
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearDisk];
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
