//
//  MineViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/24.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MineViewController.h"
#import "MineCommenTableViewCell.h"
#import "ShipAddressViewController.h"
#import "MyCollectionViewController.h"
#import "CartViewController.h"
#import "MyPointsViewController.h"
#import "NoLoginViewController.h"
#import "ImageLabelView.h"
#import "GoodsListViewController.h"
#import "SDImageCache.h"
#import "RegistViewController.h"
#import "LoginViewController.h"
#import "HaveBoughtViewController.h"
#import "MyGoodsCommentsViewController.h"
#import "OrderPageViewController.h"
#import "MyCouponViewController.h"
#import "BPush.h"

@interface MineViewController ()<UIGestureRecognizerDelegate>
{
    UIButton *iconBtn;
    UIButton *logoutBtn;
}

@property (nonatomic, assign) BOOL hasLoad;

@end

@implementation MineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor = kRedColor;
    
    _mineArray = @[@"收货地址",@"我的订单",@"我的评价",@"清除缓存"];
    _imageArray = @[[UIImage imageNamed:@"mine_address"],[UIImage imageNamed:@"mine_purchased"],[UIImage imageNamed:@"mine_comments"],[UIImage imageNamed:@"mine_cache"],[UIImage imageNamed:@"mine_cache"]];
    //tableView
    [self mineContentTableView];//
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"我的页面"];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [TalkingData trackPageBegin:@"我的页面"];
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"我的"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    __weak MineViewController *weakSelf = self;
    if (_hasLoad == NO) {
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
        if (userName == NULL) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.isPresent = YES;
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [self.tabBarController presentViewController:navi animated:NO completion:nil];
            loginVC.dismissBlock = ^{
                weakSelf.tabBarController.selectedIndex = 0;
            };
            loginVC.loginSuccessBlock = ^{
                [weakSelf mineRequest];
            };
            
        }else{
        
            [self mineRequest];

        }
    }
    if (_tableView) {
        [_tableView reloadData];
    }
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}


-(void)mineRequest
{
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    NSString *passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSString *para = [NSString stringWithFormat:@"username=%@&password=%@",userName,passWord];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=login"] postData:para];
    request.successRequest = ^(NSDictionary *dataDic){
        [YanMethodManager hideIndicatorFromView:iconBtn];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSNumber *islogin = [dataDic objectForKey:@"islogin"];
        int loginSuc = [islogin intValue];//登陆成功码
        NSNumber *code = [dataDic objectForKey:@"code"];
        int loginCode = [code intValue];//请求数据成功代码号
        if (loginCode==200) {
            NSString *cartCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"local_cartGoodsCount"];
            if (cartCount != NULL) {
                if (cartCount.intValue > 0) {
                    for (UINavigationController *navi in self.tabBarController.viewControllers) {
                        if ([navi.topViewController isKindOfClass:[CartViewController class]]) {
                            navi.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",cartCount.intValue];
                        }
                    }
                }
            }
            if (loginSuc==1) {
                _hasLoad = YES;
                _nameLabel.text = userName;
                iconBtn.userInteractionEnabled = NO;
            }
        }else{
            NSLog(@"您还未登陆");
        }
        
    };
}

//头像

#define kHeadView_height 215

#define kBottomView_height 100
#define kLogoutBtn_left 30
#define kLogoutBtn_height 45

-(void)mineContentTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-64-49) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    //tableView header handle
    [self tableHeaderView];
    
    //退出登录
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kBottomView_height)];
    bottomView.backgroundColor = [UIColor whiteColor];
    logoutBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    logoutBtn.frame = CGRectMake(kLogoutBtn_left, bottomView.height-kLogoutBtn_height-15, bottomView.width-2*kLogoutBtn_left, kLogoutBtn_height);
    logoutBtn.backgroundColor = kRedColor;
    logoutBtn.layer.cornerRadius = 5;
    [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:logoutBtn];
    _tableView.tableFooterView = bottomView;

}

#define kIconImgV_left 25
#define kIconImgV_width 70

#define kHeader_sub_height 65

#define kImageLabel_width 150
#define kImageLabel_top 10

-(void)tableHeaderView
{
    //头像
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kHeadView_height)];
    headView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kHeadView_height)];
    imageView.image = [UIImage imageNamed:@"mine_bg"];
    [headView addSubview:imageView];
    
    iconBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    iconBtn.frame = CGRectMake(kIconImgV_left, 30, kIconImgV_width, kIconImgV_width);
    [iconBtn setBackgroundImage:[UIImage imageNamed:@"mine_icon"] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(tapHeaderIconAction) forControlEvents:UIControlEventTouchUpInside];
    iconBtn.layer.cornerRadius = kIconImgV_width/2;
    iconBtn.clipsToBounds = YES;
    [headView addSubview:iconBtn];
    [YanMethodManager showIndicatorOnView:iconBtn];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconBtn.right+10, iconBtn.top, 150, 20)];
    _nameLabel.text = @"点击头像登陆";
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:kFontSize_1];
    _nameLabel.centerY = iconBtn.centerY-10;
    [headView addSubview:_nameLabel];
        
    NSArray *titles = @[@"我的收藏",@"我的优惠券"];
    NSArray *images = @[[UIImage imageNamed:@"mine_collection"],[UIImage imageNamed:@"mine_points"]];
    for (int i = 0; i < 2; i++) {
        CGFloat margin = (kScreen_width-2*kImageLabel_width)/3;
        ImageLabelView *imageLabelV = [[ImageLabelView alloc] initWithFrame:CGRectMake(margin+(margin+margin +kImageLabel_width)*i, 180, kImageLabel_width, kHeader_sub_height-2*kImageLabel_top-15) title:titles[i] image:images[i]];
        imageLabelV.imageLabelBlcok = ^{
            NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
            if (memberId==NULL) {
            
                [self login];
            }
            else if (i == 0) {//我的收藏
               
                MyCollectionViewController *collectionVC = [[MyCollectionViewController alloc] init];
//                collectionVC.hasPurchased = NO;
                [self.navigationController pushViewController:collectionVC animated:YES];
            } else {//我的积分
//                MyPointsViewController *pointsVC = [[MyPointsViewController alloc] init];
//                [self.navigationController pushViewController:pointsVC animated:YES];
                MyCouponViewController *myCouponVC = [[MyCouponViewController alloc]init];
                [self.navigationController pushViewController:myCouponVC animated:YES];
            }
        };
        [headView addSubview:imageLabelV];
    }
    
    UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(kScreen_width/2, 180, 0.5, kHeader_sub_height-2*10-15)];
    middleLine.backgroundColor = kDividColor;
    [headView addSubview:middleLine];
    
    [YanMethodManager lineViewWithFrame:CGRectMake(0, headView.height, kScreen_width, 0.5) superView:headView];
    
    _tableView.tableHeaderView = headView;
}

//（点击头像登陆）
-(void)tapHeaderIconAction
{
//    NSLog(@"=========== tapped the icon");
//    NoLoginViewController *outloginVC= [[NoLoginViewController alloc] init];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:outloginVC];
//    [self presentViewController:navi animated:YES completion:nil];
    [self login];
    
}
//点击注册
-(void)registerBtnAction:(UIButton *)btn{
//注册
    RegistViewController *registVC = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:registVC animated:YES];
}
//退出登录
-(void)logoutBtnAction:(UIButton *)button
{
    NSLog(@"========= 退出登录");
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *memberID = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NSString *para = [NSString stringWithFormat:@"member_id=%@",memberID];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=outlogin"] postData:para];
    request.successRequest = ^(NSDictionary *dataDic){
        
        //退出登录后不能收到远程推送消息
        [BPush unbindChannelWithCompleteHandler:^(id result, NSError *error) {
            NSLog(@"============= baidu remote noti unbinded = %@",result);
        }];
        
        _hasLoad = NO;

        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"consignee_address"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"member_id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"local_cartGoodsCount"];
        for (UINavigationController *navi in self.tabBarController.viewControllers) {
            if ([navi.topViewController isKindOfClass:[CartViewController class]]) {
                navi.tabBarItem.badgeValue = nil;
            }
        }
        _nameLabel.text = @"点击头像登陆";
        iconBtn.userInteractionEnabled = YES;
        
        self.tabBarController.selectedIndex = 0;
    };
    
    
}

#pragma mark UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mineArray.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mine = @"mine";
    MineCommenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mine];
    cell.detailTextLabel.textColor = kBlack_Color_2;

    if (!cell) {
        cell = [[MineCommenTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:mine];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }//===
    if (indexPath.row != _imageArray.count) {
        cell.markImageView.image = _imageArray[indexPath.row];
    }
    
    if (indexPath.row < _mineArray.count) {
         cell.titleLabel.text = _mineArray[indexPath.row];
        if (indexPath.row == _mineArray.count-1) {
            
            cell.detailTextLabel.font = [UIFont systemFontOfSize:kFontSize_4];
           
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1fM",[self sizeCach]];
        }
        return cell;
    } else {
        UITableViewCell *lastCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        return lastCell;
    }
}

-(float)sizeCach
{
    NSInteger size = [[SDImageCache sharedImageCache] getSize];
    float size_M = size/1024.0/1024.0;
    return size_M;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _mineArray.count) {
        return 0;
    }
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //@"收货地址",@"已购买商品",@"我的评价",@"清除缓存"
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MineCommenTableViewCell *cell = (MineCommenTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.textColor = kBlack_Color_2;
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    if (memberId!=NULL) {
        switch (indexPath.row) {
                case 0:{//收货地址
                ShipAddressViewController *addressVC = [[ShipAddressViewController alloc] init];
                [self.navigationController pushViewController:addressVC animated:YES];
                
            }
                break;
            case 1:{//我的订单

//                HaveBoughtViewController *haveBoughtVC = [[HaveBoughtViewController alloc]init];
//                haveBoughtVC.haveBuy = YES;
                OrderPageViewController *orderPageV = [[OrderPageViewController alloc]init];
                orderPageV.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:orderPageV animated:YES];
                
            }
                break;
            case 2:{//我的评价
                MyGoodsCommentsViewController *goodsComments = [[MyGoodsCommentsViewController alloc] init];
                goodsComments.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:goodsComments animated:YES];
            }
                break;
            case 3:{//清除缓存
                [[SDImageCache sharedImageCache] clearDisk];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1fM",[self sizeCach]];
            }
                break;

            default:
                break;
        }

    }else if(memberId==NULL&&indexPath.row!=4){
        [self login];
    
    }else{
    
        [[SDImageCache sharedImageCache] clearDisk];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1fM",[self sizeCach]];
    
    }
    }
-(void)login{

    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.isPresent = YES;
    loginVC.dismissBlock = ^{
        
    self.tabBarController.selectedIndex = 3;
    };
    loginVC.loginSuccessBlock = ^{
        [self mineRequest];

    };
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.tabBarController presentViewController:navi animated:NO completion:nil];

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
