//
//  CanUsedCouponViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/8/4.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "CanUsedCouponViewController.h"
#import "MyCouponCell.h"
#import "MyCouponModel.h"
#import "MJRefresh.h"

#define kIgnoreViewHeight 60

@interface CanUsedCouponViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *couponArray;

@end

@implementation CanUsedCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"可使用优惠券"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(couponViewPop)];

    _couponArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-64-kIgnoreViewHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = kBackgroundColor;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [self ignoreCoupon];
    __weak CanUsedCouponViewController *weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [YanMethodManager removeEmptyViewOnView:weakSelf.view];
        [weakSelf requestCouponData];
    }];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    //请求在对应超市内可用的优惠券
    [self requestCouponData];
    
    // Do any additional setup after loading the view.
}

//不使用优惠券

-(void)ignoreCoupon
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_height-kIgnoreViewHeight, kScreen_width, kIgnoreViewHeight)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitleColor:kRedColor forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"不使用优惠券" forState:UIControlStateNormal];
    button.frame = CGRectMake(15, 10, kScreen_width-30, 40);
    [button addTarget:self action:@selector(ignoreBtnAction) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5;
    [view addSubview:button];
    [self.view addSubview:view];
}

-(void)ignoreBtnAction
{
    if (self.discountCouponBlock) {
        self.discountCouponBlock(0.0, @"");
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//请求在对应超市内可用的优惠券
-(void)requestCouponData
{

    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api_coupon.php?commend=member_coupons_isok"] postData:[NSString stringWithFormat:@"member_id=%@&store_id=%ld",member_id,_store_id]];
    request.successRequest = ^(NSDictionary *couponDic){
        
        [_tableView.header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"=============== request coupon = %@",couponDic);
        NSNumber *code = [couponDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSArray *datas = [couponDic objectForKey:@"datas"];
            if ([[YanMethodManager defaultManager] isArrayEmptyWithArray:datas] == NO) {
                
                [_couponArray removeAllObjects];
                
                for (int i = 0; i < datas.count; i++) {
                    NSDictionary *itemDic = datas[i];
                    MyCouponModel *item = [[MyCouponModel alloc] initWithDictionary:itemDic];
                    [_couponArray addObject:item];
                }
                [_tableView reloadData];
            } else {
                [YanMethodManager emptyDataInView:_tableView title:@"没有可使用的优惠券哦!!"];
            }
        }
    };
    request.failureRequest = ^(NSError *error){
        [_tableView.header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.view makeToast:@"网络异常,下拉重新获取数据" duration:1.0 position:@"center"];
    };
}

#pragma mark UITabelViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _couponArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *couponID = @"coupon";
    MyCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:couponID];
    if (!cell) {
        cell = [[MyCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:couponID];
        cell.backgroundColor = kBackgroundColor;
    }
    MyCouponModel *item = _couponArray[indexPath.row];
    cell.couponModel = item;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MyCouponModel *item = _couponArray[indexPath.row];
    if (_totalPrice >= item.xianzhi && _totalPrice > item.amount) {
        if (self.discountCouponBlock) {
            self.discountCouponBlock(item.amount, item.coupon_id);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.view makeToast:@"结算金额不足,再去逛逛吧!!" duration:1.5 position:@"center"];
    }
    
}

-(void)couponViewPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
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
