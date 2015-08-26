//
//  MaketHomeViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/24.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MaketHomeViewController.h"
#import "SearchResultViewController.h"
#import "KxMenu.h"
#import "HomeTopView.h"
#import "HomeBtn.h"
#import "FourthCategoryView.h"
#import "MoreSubView.h"
#import "GoodsListViewController.h"
#import "GoodsDetailViewController.h"
#import "CartViewController.h"
#import "GoodsCategoryViewController.h"
#import "SuperMarketListViewController.h"
#import "HomeGoodsItem.h"
#import "LoginViewController.h"
#import "TopHomeModel.h"
#import "MaketHomeWebViewController.h"
#import "HomeTopAdView.h"
#import "UIImageView+WebCache.h"
#import "DuckNeckViewController.h"
#import "CrayFishViewController.h"
#import "RedPacketViewController.h"
#import "CustomHomeView.h"
#import "FruitHomeTableViewCell.h"
#import "FruitHomeMoreViewController.h"
#import "PayRightNowViewController.h"
#import "PaySuccessViewController.h"
#import "MyCouponViewController.h"

@interface MaketHomeViewController ()<UIGestureRecognizerDelegate>

{
    UIImageView *lightImgV;
    FourthCategoryView *secondCateView;//天天特价
    FourthCategoryView *firstCateView;//酒水饮料
    FourthCategoryView *thirdCateView;//包装食品
    FourthCategoryView *fourthCateView;//日常用品
}

@property (nonatomic, strong) HomeTopView *topView;
@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuImages;
@property (nonatomic, strong) UIScrollView *homeScrollView;
@property (nonatomic, assign) BOOL isBright;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSTimer *lightTimer;
@property (nonatomic, strong) NSArray *goodsCategorys;
@property (nonatomic, strong) NSArray *class_idArray;
@property (nonatomic, assign) BOOL isSystemOpen;//标记超市系统是否打开
@property (nonatomic, strong) UIView *redPackageView;//红包View
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, assign) float redPacket;//红包金额
@property (nonatomic, strong) NSMutableDictionary *localDataDic;//本地化的首页商品数据
@property (nonatomic, assign) BOOL loadSpecialPrice;
@property (nonatomic, assign) BOOL loadDrinks;
@property (nonatomic, assign) BOOL loadPackege;
@property (nonatomic, assign) BOOL loadCommen;
@property (nonatomic, assign) BOOL showMenu;
@property (nonatomic, strong) NSMutableArray *detonationProducts;
@property (nonatomic, strong) NSMutableArray *topData;//顶部轮播图
@property (nonatomic, assign) BOOL showDuckNeck;
@property (nonatomic, assign) BOOL showCrayFish;

@property (nonatomic, assign) BOOL isOtherType;//标记进入的店铺类型
@property (nonatomic, strong) NSMutableArray *otherTypeGoods;
@property (nonatomic, assign) CGPoint tapPoint;
@property (nonatomic, assign) BOOL marketIsLogin;//标记进入的店铺类型

@property (nonatomic, assign) float couponAmount;//检查本超市是否有优惠券

@end

@implementation MaketHomeViewController

#define kLightImageView_width 8

#define Key_LocalHomeData @"local_homeData"
#define Key_SpecialPrice @"home_special_price"//今日特价
#define Key_Drinks @"home_drinks"//酒水饮料
#define Key_PackageFood @"home_packageFood"//包装食品
#define Key_CommenItems @"home_commenItems"//日常用品

#define Key_FruitLocalData @"fruit_local_data"

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
//////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _goodsCategorys = @[@"今日特价",@"休闲食品",@"酒水/饮料",@"粮油调味"];
    _class_idArray = @[@"",@"137",@"160",@"153"];
    _localDataDic = [NSMutableDictionary dictionary];
    _showMenu = NO;
    _redPackageView = nil;
    [self marketHomeNaviBarHandle];
    NSDictionary *marketDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [marketDic objectForKey:@"store_id"];
    NSLog(@"============= home store id = %@",store_id);
    NSString *store_Classid = [marketDic objectForKey:@"class_id"];
    if (store_Classid.intValue == 18) {
        _isOtherType = NO;
    } else {
        _isOtherType = YES;
    }

    Market *marketItem = [[Market alloc] initWithDic:marketDic];
    _homeMarketData = marketItem;
//    [self menuSubViewsHandle];
    
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
    
    [self loadTopViewData];
    
    // Do any additional setup after loading the view.

}

-(void)loadAllDatas
{
    if (_loadSpecialPrice && _loadCommen && _loadDrinks && _loadPackege) {
        NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
        if (member_id != NULL) {
            [self redPackageRequest];
        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:Key_LocalHomeData];
        NSDictionary *tempDic = [NSDictionary dictionaryWithObjects:_localDataDic.allValues forKeys:_localDataDic.allKeys];
        [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:Key_LocalHomeData];
    }
}


-(void)indicatorTimer
{
    _lightTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(lightTimerAction:) userInfo:nil repeats:YES];
    [self performSelector:@selector(lightTimerInvilade) withObject:nil afterDelay:5];

}

-(void)lightTimerAction:(NSTimer *)timer
{
    _isBright = !_isBright;
    NSString *lightName;
    if (_isOpen) {
        lightName = _isBright ? @"gray" : @"green";
    } else {
        lightName = _isBright ? @"gray" : @"red";
    }
    lightImgV.image = [UIImage imageNamed:lightName];
}

-(void)lightTimerInvilade
{
    [_lightTimer invalidate];
    _lightTimer = nil;
    NSString *name = _isOpen ? @"green" : @"red";
    lightImgV.image = [UIImage imageNamed:name];
}

-(void)homeDataRequestByLoaclDic:(NSDictionary *)localDic
{
    __weak MaketHomeViewController *weakSelf = self;
    //今日特价
    if (localDic == NULL) {
        [YanMethodManager showIndicatorOnView:secondCateView];
        [YanMethodManager showIndicatorOnView:firstCateView];
        [YanMethodManager showIndicatorOnView:thirdCateView];
        [YanMethodManager showIndicatorOnView:fourthCateView];
    }
   
    [self packageHomeRequestHandleWithUrl:nil success:^(NSDictionary *requestDic) {
        if (requestDic) {
            [_localDataDic setObject:requestDic forKey:Key_SpecialPrice];
        }
        _loadSpecialPrice = YES;
        [weakSelf loadAllDatas];
        [YanMethodManager hideIndicatorFromView:secondCateView];
        NSMutableArray *items = [weakSelf requestItemsHandleWithDic:requestDic];
        secondCateView.fourthItems = items;
        secondCateView.tapFourthBlock = ^(UITapGestureRecognizer *tap){
            if (tap.view.tag-700 < 10) {
                [weakSelf pushDetailActionWithTag:tap.view.tag-700 items:items];
            } else {
//                [weakSelf addGoodsIntoCartWithGesture:tap];
//                [weakSelf addIntoCartHandleWithGesture:tap items:items markTag:170];
            }
        };
    } isTejia:@"1"];
    //酒水饮料
    NSString *firstIDStr = _class_idArray[1];
    
    [self packageHomeRequestHandleWithUrl:firstIDStr success:^(NSDictionary *requestDic) {
        if (requestDic) {
             [_localDataDic setObject:requestDic forKey:Key_Drinks];
        }
        _loadDrinks = YES;
        [weakSelf loadAllDatas];
        [YanMethodManager hideIndicatorFromView:firstCateView];
        NSMutableArray *items = [weakSelf requestItemsHandleWithDic:requestDic];
        firstCateView.fourthItems = items;
        firstCateView.tapFourthBlock = ^(UITapGestureRecognizer *tap){
            if (tap.view.tag-800 < 10) {
                [weakSelf pushDetailActionWithTag:tap.view.tag-800 items:items];
            } else {
//                [weakSelf addGoodsIntoCartWithGesture:tap];
//                [weakSelf addIntoCartHandleWithGesture:tap items:items markTag:120];
            }
        };
    } isTejia:@"0"];
    //包装食品
    NSString *thirdIDStr = _class_idArray[2];
    
    [self packageHomeRequestHandleWithUrl:thirdIDStr success:^(NSDictionary *requestDic) {
        if (requestDic) {
            [_localDataDic setObject:requestDic forKey:Key_PackageFood];
        }
        _loadPackege = YES;
        [weakSelf loadAllDatas];
        [YanMethodManager hideIndicatorFromView:thirdCateView];
        NSMutableArray *items = [weakSelf requestItemsHandleWithDic:requestDic];
        thirdCateView.fourthItems = items;
        thirdCateView.tapFourthBlock = ^(UITapGestureRecognizer *tap){
            if (tap.view.tag-900 < 10) {
                [weakSelf pushDetailActionWithTag:tap.view.tag-900 items:items];
            } else {
//                [weakSelf addGoodsIntoCartWithGesture:tap];
//                [weakSelf addIntoCartHandleWithGesture:tap items:items markTag:220];
            }
        };
    } isTejia:@"0"];
    
    //日常用品
    NSString *fourthIDStr = _class_idArray[3];
    
    [self packageHomeRequestHandleWithUrl:fourthIDStr success:^(NSDictionary *requstDic) {
        if (requstDic) {
            [_localDataDic setObject:requstDic forKey:Key_CommenItems];
        }
        _loadCommen = YES;
        [weakSelf loadAllDatas];
        [YanMethodManager hideIndicatorFromView:fourthCateView];
        NSMutableArray *items = [weakSelf requestItemsHandleWithDic:requstDic];
        fourthCateView.fourthItems = items;
        fourthCateView.tapFourthBlock = ^(UITapGestureRecognizer *tap){
            if (tap.view.tag-1000 < 10) {
                [weakSelf pushDetailActionWithTag:tap.view.tag-1000 items:items];
            } else {
//                [weakSelf addGoodsIntoCartWithGesture:tap];
//                [weakSelf addIntoCartHandleWithGesture:tap items:items markTag:270];
            }
        };
    } isTejia:@"0"];
}

#define kRedPackageView_width 108
#define kRedPackageView_height 48

-(void)redPackageRequest
{
    NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [storeDic objectForKey:@"store_id"];
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NSLog(@"package = %@,member id = %@",store_id,member_id);
    
    //实时检查超市系统状态
    [self checkMarketEtherOpenWithStoreId:store_id];
    
    __weak MaketHomeViewController *weakSelf = self;
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
//    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=hongbaostore"] postData:[NSString stringWithFormat:@"store_id=%@&member_id=%@",store_id,member_id]];
//    __weak MaketHomeViewController *weakSelf = self;
//    request.successRequest = ^(NSDictionary *packageDic){
//        NSLog(@"===== package dic = %@",packageDic);
//        NSNumber *code = [packageDic objectForKey:@"code"];
//        if (code.integerValue == 200) {
//            NSNumber *ishonebao = [packageDic objectForKey:@"ishongbao"];
//            NSNumber *islingqu = [packageDic objectForKey:@"islingqu"];
//            NSNumber *isxiaofei = [packageDic objectForKey:@"isxiaofei"];
//            
//            if (ishonebao.integerValue == 1) {
//                if (islingqu.integerValue == 0 && isxiaofei.integerValue == 0) {
//                    [weakSelf closeRedpacketView];
//                    [weakSelf addRedPacketSubview];
//                    NSDictionary *dataDic = [packageDic objectForKey:@"data"];
//                    if ([[YanMethodManager defaultManager] isDictionaryEmptyWithDic:dataDic] == NO) {
//                        NSNumber *hongbao = [dataDic objectForKey:@"hongbao"];
//                        _redPacket = hongbao.floatValue;
//                        _start_time = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"start_time"]];
//                        _end_time = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"end_time"]];
//                    }
//                    
//                }
//                if (islingqu.integerValue == 1 && isxiaofei.integerValue == 0) {
//                    [weakSelf closeRedpacketView];
//                }
//            }
////            [self indicatorTimer];
//        }
//        
//        [weakSelf checkMarketEtherOpenWithStoreId:store_id];
//        
//    };
    
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api_coupon.php?commend=couponstore"] postData:[NSString stringWithFormat:@"member_id=%@&store_id=%@",member_id,store_id]];
    request.successRequest = ^(NSDictionary *couponDic){
        NSLog(@"========= coupon dic = %@",couponDic);
        NSNumber *code = [couponDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSNumber *isyouhuiquan = [couponDic objectForKey:@"isyouhuijuan"];
            NSNumber *islingqu = [couponDic objectForKey:@"islingqu"];
            NSNumber *isxiaofei = [couponDic objectForKey:@"isxiaofei"];
            if (isyouhuiquan.integerValue == 1 && isxiaofei.integerValue == 0 && islingqu.integerValue == 0) {
                NSDictionary *datas = [couponDic objectForKey:@"datas"];
                if ([[YanMethodManager defaultManager] isDictionaryEmptyWithDic:datas] == NO) {
                    NSNumber *amount = [datas objectForKey:@"amount"];
                    _couponAmount = amount.floatValue;
                }
                [weakSelf closeRedpacketView];
                [weakSelf addRedPacketSubview];
            } else {
                [weakSelf closeRedpacketView];
            }
        }
    };
}

//检查超市系统是否关闭
-(void)checkMarketEtherOpenWithStoreId:(NSString *)store_id
{
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=isopenstore"] postData:[NSString stringWithFormat:@"store_id=%@",store_id]];
    __weak MaketHomeViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *openDic){
        NSLog(@"=========== open = %@",openDic);
        NSNumber *code = [openDic objectForKey:@"code"];
        NSNumber *isOpen = [openDic objectForKey:@"isopen"];
        if (code.integerValue == 200) {
            if ([isOpen isKindOfClass:[NSNull class]] == NO) {
                if (isOpen.integerValue == 1) {
                    _isOpen = YES;
                    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:kMarket_name];
                    weakSelf.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:name];
                } else {
                    _isOpen = NO;
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
                    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:kMarket_name];
                    titleLabel.text = [name stringByAppendingString:@"(离线)"];
                    titleLabel.textColor = [UIColor blackColor];
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                    titleLabel.font = [UIFont systemFontOfSize:kFontSize_1];
                    weakSelf.navigationItem.titleView = titleLabel;
                }
            }
        }
    };
}

#define kClose_btn_width 20

-(void)addRedPacketSubview
{
    _redPackageView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_width-10-kRedPackageView_width, 260, kRedPackageView_width, kRedPackageView_height)];
    _redPackageView.backgroundColor = [UIColor whiteColor];
    UIButton *redPackageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    redPackageBtn.frame = _redPackageView.bounds;
    [redPackageBtn setBackgroundImage:[UIImage imageNamed:@"red_packet"] forState:UIControlStateNormal];
    [redPackageBtn addTarget:self action:@selector(receiveRedPacket) forControlEvents:UIControlEventTouchUpInside];
    [_redPackageView addSubview:redPackageBtn];
    [self.view addSubview:_redPackageView];
    [self.view bringSubviewToFront:_redPackageView];
}

//领取红包
-(void)receiveRedPacket
{
    NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [storeDic objectForKey:@"store_id"];
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
//    NSString *param = [NSString stringWithFormat:@"store_id=%@&member_id=%@&start_time=%@&end_time=%@&hongbao=%.1f",store_id,member_id,_start_time,_end_time,_redPacket];
//    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=hongbaomember"] postData:param];
//    request.successRequest = ^(NSDictionary *requestDic){
//        NSLog(@"============ 领取红包 ＝ %@",requestDic);
//        NSNumber *code = [requestDic objectForKey:@"code"];
//        if (code.integerValue == 200) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                _redPackageView.hidden = YES;
//                [_redPackageView removeFromSuperview];
//                _redPackageView = nil;
//                [self.view makeToast:[NSString stringWithFormat:@"您已成功领取%.1f元红包,请在当天消费",_redPacket] duration:2.5 position:@"center"];
//            });
//        }
//    };
    
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api_coupon.php?commend=couponmember"] postData:[NSString stringWithFormat:@"member_id=%@&store_id=%@",member_id,store_id]];
    request.successRequest = ^(NSDictionary *getCouponDic){
        NSLog(@"============ get coupon = %@",getCouponDic);
        NSNumber *code = [getCouponDic objectForKey:@"code"];
        int codeStatus = code.intValue;
        if (codeStatus == 200) {
            [self.view makeToast:[NSString stringWithFormat:@"您已成功领取¥%.1f优惠券,可在我的优惠券查看",_couponAmount] duration:1.5 position:@"center"];
            [self closeRedpacketView];
        } else if (codeStatus == 201) {
            [self.view makeToast:@"您已领取了优惠券,不能重复领取哦!!" duration:1.0 position:@"center"];
            [self closeRedpacketView];
        } else {
            [self.view makeToast:@"领取失败,请重新领取" duration:1.0 position:@"center"];
        }
    };
}

-(void)closeRedpacketView
{
    _redPackageView.hidden = YES;
    [_redPackageView removeFromSuperview];
    _redPackageView = nil;
}

-(void)addIntoCartHandleWithGesture:(UITapGestureRecognizer *)tap items:(NSMutableArray *)items markTag:(NSInteger)tag
{
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    if (member_id == NULL) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.isPresent = YES;
        loginVC.dismissBlock = ^{
            self.tabBarController.selectedIndex = 0;
        };
        loginVC.loginSuccessBlock = ^{
        };
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.tabBarController presentViewController:navi animated:NO completion:nil];
    } else {
        NetWorkRequest *request = [[NetWorkRequest alloc]init];
        HomeGoodsItem *item = items[tap.view.tag - tag];
        
        NSString *telephone = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
        NSString *para = [NSString stringWithFormat:@"goods_id=%d&quantity=1&member_id=%@", item.goods_id,telephone];
        [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addshopcar"] postData:para];
        request.successRequest = ^(NSDictionary *dataDic)
        {
            NSNumber *code = [dataDic objectForKey:@"code"];
            int loginCode = [code intValue];//请求数据成功代码号
            if (loginCode == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSNumber *count = [dataDic objectForKey:@"count"];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)count.integerValue] forKey:@"local_cartGoodsCount"];
                    for (UINavigationController *navi in self.tabBarController.viewControllers) {
                        if ([navi.topViewController isKindOfClass:[CartViewController class]]) {
                            navi.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)count.integerValue];
                        }
                    }
                    
                });
            }
            if (loginCode == 203) {
                [self.view makeToast:@"您的购物车已满,请先结算购物车" duration:1.5 position:@"center"];
            }
            if (loginCode != 200 && loginCode != 203) {
                [self.view makeToast:@"加入购物车失败" duration:1.5 position:@"center"];
            }
        };
        request.failureRequest = ^(NSError *error){
            [self.view makeToast:@"加入购物车失败" duration:1.5 position:@"center"];
        };
    }
}

-(void)packageHomeRequestHandleWithUrl:(NSString *)class_id success:(void(^)(NSDictionary *requestDic))successHandle isTejia:(NSString *)istejia
{
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [storeDic objectForKey:@"store_id"];
    //[@"store_id=%@&class_id=" stringByAppendingString:class_id]
    NSString *param;
    if (class_id != nil) {
        param = [NSString stringWithFormat:@"store_id=%@&class_id=%@",store_id,class_id];
    } else {
        param = [NSString stringWithFormat:@"store_id=%@&is_tejia=%@",store_id,istejia];
        NSLog(@"======== tejia param = %@",param);
    }
    
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=goodslist"] postData:param];
    request.successRequest = ^(NSDictionary *homeData){
        NSLog(@"========== home data = %@ ",homeData);
        if (successHandle) {
            
            successHandle(homeData);
        }
    };
}

//将每次请求的数据本地化，方便下次请求时每次都有加载时间
-(NSMutableArray *)localHomeDataHandleByKey:(NSString *)key dic:(NSDictionary *)dic
{
    NSDictionary *keyDic = [dic objectForKey:key];
    NSArray *keyArray = [keyDic objectForKey:@"datas"];
     NSMutableArray *tempArr = [NSMutableArray array];
    if ([[YanMethodManager defaultManager] isArrayEmptyWithArray:keyArray] == NO) {
        for (int i = 0; i < keyArray.count; i++) {
            NSDictionary *itemDic = keyArray[i];
            HomeGoodsItem *item = [[HomeGoodsItem alloc] initWithDic:itemDic];
            [tempArr addObject:item];
        }
    }
    return tempArr;
}

-(NSMutableArray *)requestItemsHandleWithDic:(NSDictionary *)dic
{
    NSArray *keyArray = [dic objectForKey:@"datas"];
    NSMutableArray *tempArr = [NSMutableArray array];
    if ([[YanMethodManager defaultManager] isArrayEmptyWithArray:keyArray] == NO) {
        for (int i = 0; i < keyArray.count; i++) {
            NSDictionary *itemDic = keyArray[i];
            HomeGoodsItem *item = [[HomeGoodsItem alloc] initWithDic:itemDic];
            [tempArr addObject:item];
        }
    }
    return tempArr;
    
}


#define kTopView_height 150
#define kBtnsView_height 80
#define kMoreBtnV_height 40

-(void)createMarketHomeSubviews
{
    _homeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-64-49)];
    _homeScrollView.contentSize = CGSizeMake(kScreen_width, 2*kScreen_height);
    [self.view addSubview:_homeScrollView];
    
    //顶部的轮播图
    _topView = [[HomeTopView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kTopView_height)];
    _topView.topImagesArray = _topData;
    [_homeScrollView addSubview:_topView];
        //起送价格、送货范围视图
    UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.bottom, kScreen_width, 30)];
    [priceView setBackgroundColor:kRedColor];
    //初始社区数据，设为全局变量，在获取所选择社区的数据后给这两个label重新赋值
    
    NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSNumber *alisa = [storeDic objectForKey:@"alisa"];
    NSString *sendDes = [storeDic objectForKey:@"daliver_description"];
    
    UILabel * sendPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_width/2, 30)];
    if (alisa.floatValue > 0) {
        sendPrice.text = [NSString stringWithFormat:@"%.1f元起送",alisa.floatValue];
    } else {
        sendPrice.text = @"免运费";
    }
    [sendPrice setTextAlignment:NSTextAlignmentCenter];
    sendPrice.textColor = [UIColor whiteColor];
    sendPrice.font = [UIFont boldSystemFontOfSize:kFontSize_3];
    [priceView addSubview:sendPrice];
    
    UILabel * rangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_width/2+10, 0, kScreen_width/2-10, 30)];
    rangeLabel.text = sendDes;
    rangeLabel.textColor = [UIColor whiteColor];
    rangeLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    rangeLabel.textAlignment = NSTextAlignmentCenter;
    [priceView addSubview:sendPrice];
    [priceView addSubview:rangeLabel];
    
    
    UIView *seperateView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_width/2 -0.5, 5, 1, 20)];
    seperateView.backgroundColor = [UIColor colorWithWhite:.6 alpha:.7];
    ;
    [priceView addSubview:seperateView];
    [_homeScrollView addSubview:priceView];
    //功能模块
    NSArray *funcArr = @[@"切换超市",@"联系超市",@"客服热线",@"优惠券"];
    NSArray *funcImages = @[[UIImage imageNamed:@"kichens"],[UIImage imageNamed:@"fresh"],[UIImage imageNamed:@"clean"],[UIImage imageNamed:@"housekeeper"]];
    UIView *btnsView = [[UIView alloc] initWithFrame:CGRectMake(0, priceView.bottom, kScreen_width, kBtnsView_height)];
    btnsView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < 4; i++) {
        HomeBtn *subBtn = [[HomeBtn alloc] initWithFrame:CGRectMake(kScreen_width/4*i, 0, kScreen_width/4, kBtnsView_height)];
        subBtn.button.tag = 100 + i;
        [subBtn.button setBackgroundImage:funcImages[i] forState:UIControlStateNormal];
        subBtn.title = funcArr[i];
        [subBtn.button addTarget:self action:@selector(homeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnsView addSubview:subBtn];
    }
    [_homeScrollView addSubview:btnsView];
    UIView *markV = [[UIView alloc] initWithFrame:CGRectMake(0, btnsView.bottom, kScreen_width, 10)];
    markV.backgroundColor = kBackgroundColor;
    [_homeScrollView addSubview:markV];
    
    //爆品
    CGFloat adviewHeight = 0;
    if (!_showDuckNeck || !_showCrayFish) {
        if (_showCrayFish || _showDuckNeck) {
            adviewHeight = kScreen_width*107/375.0;
        }
    }
    if (_showDuckNeck && _showCrayFish) {
        adviewHeight = kScreen_width*107/375.0*2+10;
    }
    TopHomeModel *duckModel;
    TopHomeModel *crayfishModel;
    TopHomeModel *duckDetailModel;
    TopHomeModel *crayfishDetailModel;
    for (int i = 0; i < _detonationProducts.count; i++) {
        TopHomeModel *model = _detonationProducts[i];
        if (model.is_type == 2) {//首页鸭脖
            duckModel = model;
            continue;
        }
        if (model.is_type == 4) {//首页小龙虾
            crayfishModel = model;
            continue;
        }
        if (model.is_type == 3) {//详情鸭脖
            duckDetailModel = model;
            continue;
        }
        if (model.is_type == 5) {//详情小龙虾
            crayfishDetailModel = model;
            continue;
        }
    }
    HomeTopAdView *adView = [[HomeTopAdView alloc] initWithFrame:CGRectMake(0, btnsView.bottom+10, kScreen_width, adviewHeight) showDuck:duckModel showCrayfish:crayfishModel];
    adView.tapAdBlock = ^(UITapGestureRecognizer *tap){
        switch (tap.view.tag) {
            case 390:{
                DuckNeckViewController *duckVC = [[DuckNeckViewController alloc] init];
                duckVC.imageName = duckDetailModel.default_content;
                duckVC.width = duckDetailModel.ap_width;
                duckVC.height = duckDetailModel.ap_height;
                [self.navigationController pushViewController:duckVC animated:YES];
            }
                break;
            case 391:{
                CrayFishViewController *crayFishVC = [[CrayFishViewController alloc] init];
                crayFishVC.width = crayfishDetailModel.ap_width;
                crayFishVC.height = crayfishDetailModel.ap_height;
                crayFishVC.urlImageString = crayfishDetailModel.default_content;
                [self.navigationController pushViewController:crayFishVC animated:YES];
            }
                break;
            default:
                break;
        }
    };
    [_homeScrollView addSubview:adView];
    
    _homeScrollView.contentSize = CGSizeMake(kScreen_width, _topView.height+btnsView.height+kBtnsView_height-40+adView.height);
    
    if (_isOtherType) {
        
        [self requestOtherTypeDataWithView:adView btnsView:btnsView];
        
    } else {
        [self joinTogetherWithMarketWithTop:adView duck:duckModel crayfish:crayfishModel buttonsView:btnsView];
    }
}

//获取水果店商品数据
-(void)requestOtherTypeDataWithView:(UIView *)adView btnsView:(UIView *)btnsView
{
    NSDictionary *marketDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [marketDic objectForKey:@"store_id"];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    _otherTypeGoods = [NSMutableArray array];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=fruitlistmore"] postData:[NSString stringWithFormat:@"store_id=%@",store_id]];
    request.successRequest = ^(NSDictionary *typeDic){
//        NSLog(@"=========== typedic = %@",typeDic);
        NSNumber *code = [typeDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSArray *datas = [typeDic objectForKey:@"datas"];
            for (int i = 0; i < datas.count; i++) {
                NSDictionary *dataDic = datas[i];
                HomeGoodsItem *item = [[HomeGoodsItem alloc] initWithDic:dataDic];
                [_otherTypeGoods addObject:item];
            }
            
            if (_otherTypeGoods.count > 0) {
                
                CGFloat top;
                if (!_showCrayFish && !_showDuckNeck) {
                    top = btnsView.bottom;
                } else {
                    top = adView.bottom;
                }
                
                UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, top, kScreen_width, 10)];
                tempView.backgroundColor = kBackgroundColor;
                [_homeScrollView addSubview:tempView];
                CustomHomeView *customview = [[CustomHomeView alloc] initWithFrame:CGRectMake(0, adView.bottom+10, kScreen_width, 120*_otherTypeGoods.count+80)];
                
                //查看更多
                customview.moreBtnBlock = ^{
                FruitHomeMoreViewController *fruitVC = [[FruitHomeMoreViewController alloc] init];
                [self.navigationController pushViewController:fruitVC animated:YES];
                    
                };
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                customview.tableView.dataSource = self;
                customview.tableView.delegate = self;
                [_homeScrollView addSubview:customview];
                _homeScrollView.contentSize = CGSizeMake(kScreen_width, _topView.height+btnsView.height+kBtnsView_height-40+adView.height+10+customview.height);
            } else {
                _homeScrollView.contentSize = CGSizeMake(kScreen_width, _topView.height+btnsView.height+kBtnsView_height-40+adView.height);
            }
        }
    };
    
    request.failureRequest = ^(NSError *error){
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    };
}

-(void)joinTogetherWithMarketWithTop:(HomeTopAdView *)adView duck:(TopHomeModel *)duckModel crayfish:(TopHomeModel *)crayfishModel buttonsView:(UIView *)btnsView
{
    //商品模块
    //今日特价
    CGFloat top;
    if (duckModel.is_use != 1 && crayfishModel.is_use != 1) {
        top = btnsView.bottom;
    } else {
        top = adView.bottom;
    }
    [self addCategoryBtnOnScrollViewWithFrame:CGRectMake(0, top, kScreen_width, kMoreBtnV_height) title:_goodsCategorys[0] tag:500 color:kBlack_Color_2];
    secondCateView = [[FourthCategoryView alloc] initWithFrame:CGRectMake(0, top+kMoreBtnV_height+10, kScreen_width, 300) tag:700];
    [_homeScrollView addSubview:secondCateView];
    
    //酒水饮料
    [self addCategoryBtnOnScrollViewWithFrame:CGRectMake(0, secondCateView.bottom, kScreen_width, kMoreBtnV_height) title:_goodsCategorys[1] tag:501 color:kBlack_Color_2];
    firstCateView = [[FourthCategoryView alloc] initWithFrame:CGRectMake(0, secondCateView.bottom+kMoreBtnV_height, kScreen_width, 300) tag:800];
    [_homeScrollView addSubview:firstCateView];
    //包装食品
    [self addCategoryBtnOnScrollViewWithFrame:CGRectMake(0, firstCateView.bottom, kScreen_width, kMoreBtnV_height) title:_goodsCategorys[2] tag:502 color:kBlack_Color_2];
    thirdCateView = [[FourthCategoryView alloc] initWithFrame:CGRectMake(0, firstCateView.bottom+kMoreBtnV_height, kScreen_width, 300) tag:900];
    [_homeScrollView addSubview:thirdCateView];
    
    //日常用品
    [self addCategoryBtnOnScrollViewWithFrame:CGRectMake(0, thirdCateView.bottom, kScreen_width, kMoreBtnV_height) title:_goodsCategorys[3] tag:503 color:kBlack_Color_2];
    fourthCateView = [[FourthCategoryView alloc] initWithFrame:CGRectMake(0, thirdCateView.bottom+kMoreBtnV_height, kScreen_width, 300) tag:1000];
    [_homeScrollView addSubview:fourthCateView];
    
    _homeScrollView.contentSize = CGSizeMake(kScreen_width, _topView.height+4*kMoreBtnV_height+firstCateView.height+secondCateView.height+thirdCateView.height+fourthCateView.height+btnsView.height+kBtnsView_height-40+adView.height+10);
}

//顶部的轮播图
-(void)loadTopViewData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *para;
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addisplay"] postData:para];
    request.successRequest = ^(NSDictionary *dataDic){
//        NSLog(@"============== 顶部轮播图 ＝ %@",dataDic);
        if (!_isOtherType) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        
        _topData = [[NSMutableArray alloc] init];
        NSString *code = [dataDic objectForKey:@"code"];
        int codeNum = code.intValue;
        if (codeNum==200) {
            _detonationProducts = [NSMutableArray array];
            for (NSDictionary *dic in [dataDic objectForKey:@"datas"]) {
                
                TopHomeModel *model = [[TopHomeModel alloc] initWithDic:dic];
                if (model.is_type == 1) {
                    [_topData addObject:model];
                } else {
                    if (model.is_type == 2 && model.is_use == 1) {
                        _showDuckNeck = YES;
                    }
                    if (model.is_type == 4 && model.is_use == 1) {
                        _showCrayFish = YES;
                    }
                    [_detonationProducts addObject:model];
                }
            }
        }
        
        [self createMarketHomeSubviews];
        //网络请求返回数据之前先使用本地化的数据加载
        if (!_isOtherType) {
            NSDictionary *localDic = [[NSUserDefaults standardUserDefaults] objectForKey:Key_LocalHomeData];
            //    [self homeDataRequestByLoaclDic:localDic];
            if (localDic != NULL) {
                secondCateView.fourthItems = [self localHomeDataHandleByKey:Key_SpecialPrice dic:localDic];
                firstCateView.fourthItems = [self localHomeDataHandleByKey:Key_Drinks dic:localDic];
                thirdCateView.fourthItems = [self localHomeDataHandleByKey:Key_PackageFood dic:localDic];
                fourthCateView.fourthItems = [self localHomeDataHandleByKey:Key_CommenItems dic:localDic];
            }
            [self homeDataRequestByLoaclDic:localDic];
        }
        

//        __weak NSMutableArray *topArray = topData;
//        __weak MaketHomeViewController *blockVC = self;
//        _topView.tapTopImageBlock = ^(UIImageView *imageView){
//            TopHomeModel *model = [topArray objectAtIndex:imageView.tag-150];
//            MaketHomeWebViewController *webVC = [[MaketHomeWebViewController alloc] init];
//            webVC.hidesBottomBarWhenPushed = YES;
//            webVC.webString =[NSURL URLWithString:model.link];
//            [blockVC.navigationController pushViewController:webVC animated:YES];
//        };
    };
    
    request.failureRequest = ^(NSError *error){
        if (!_isOtherType) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        [self createMarketHomeSubviews];
        NSDictionary *localDic = [[NSUserDefaults standardUserDefaults] objectForKey:Key_LocalHomeData];
        [self homeDataRequestByLoaclDic:localDic];
    };
}
-(void)pushDetailActionWithTag:(NSInteger)tag items:(NSMutableArray *)items
{
    HomeGoodsItem *item = items[tag];
    GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc] init];
    detailVC.goods_id = item.goods_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

//将商品放入购物车动画效果
-(void)addGoodsIntoCartWithGesture:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_tapPoint.x, _tapPoint.y, 40, 40)];
    imageView.image = kHolderImage;
    [self.view addSubview:imageView];
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, _tapPoint.x, _tapPoint.y);
    CGPathAddLineToPoint(path, NULL, kScreen_width/4*3-25, kScreen_height-20);
    pathAnimation.path = path;
    [imageView.layer addAnimation:pathAnimation forKey:@"position"];
    
    CABasicAnimation *basiAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    basiAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    basiAnimation.toValue = [NSNumber numberWithFloat:0.0];
    [imageView.layer addAnimation:basiAnimation forKey:@"transform.scale"];
    
    //    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    //    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    //    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    //    [imageView.layer addAnimation:opacityAnimation forKey:@"透明度"];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setDuration:0.5];
    group.animations = @[pathAnimation, basiAnimation];
    [imageView.layer addAnimation:group forKey:@"group"];
    CGPathRelease(path);
    [self performSelector:@selector(removeImageView:) withObject:imageView afterDelay:0.45];
}

-(void)removeImageView:(UIImageView *)imageView
{
    [imageView removeFromSuperview];
}

-(void)addCategoryBtnOnScrollViewWithFrame:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag color:(UIColor *)color
{
    MoreSubView *moreView = [[MoreSubView alloc] initWithFrame:frame title:title color:color];
    moreView.moreBtn.tag = tag;
    [moreView.moreBtn addTarget:self action:@selector(categoryMoreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_homeScrollView addSubview:moreView];
}

//商品分类(更多按钮)
-(void)categoryMoreBtnClicked:(UIButton *)btn
{
    NSLog(@"============ btn tag = %ld",btn.tag);
    GoodsListViewController *goodsListVC = [[GoodsListViewController alloc] init];
    GoodsCategoryViewController *moreGoodsVC = [[GoodsCategoryViewController alloc] init];
    moreGoodsVC.marketHomeMore = YES;
    // _class_idArray = @[@"",@"137",@"160",@"153"];
    switch (btn.tag) {
        case 500:{//今日特价
            goodsListVC.naviTitle = _goodsCategorys[0];
            goodsListVC.isTejia = YES;
            [self.navigationController pushViewController:goodsListVC animated:YES];

        }
            break;
        case 501:{//休闲食品
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            moreGoodsVC.indexPath = indexPath;
            [self.navigationController pushViewController:moreGoodsVC animated:YES];
        }
            break;
        case 502:{//酒水饮料
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            moreGoodsVC.indexPath = indexPath;
            [self.navigationController pushViewController:moreGoodsVC animated:YES];

        }
            break;
        case 503:{//调味粮油
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
            moreGoodsVC.indexPath = indexPath;
            [self.navigationController pushViewController:moreGoodsVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

//功能模块
-(void)homeButtonAction:(UIButton *)button
{
    switch (button.tag) {
        case 100:{//切换超市
            SuperMarketListViewController *marketListVC = [[SuperMarketListViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:marketListVC];
            [self presentViewController:navi animated:YES completion:nil];
        }
            break;
        case 101:{//联系超市
            NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
            NSString *telNum = [storeDic objectForKey:@"telephone"];
            
            [[YanMethodManager defaultManager] callPhoneActionWithNum:telNum viewController:self];
        }
            break;
        case 102:{//客服热线
           [[YanMethodManager defaultManager] callPhoneActionWithNum:@"4000279567" viewController:self];
        }
            break;
        case 103:{//红包
            NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
            if (member_id == NULL) {
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
                loginVC.loginSuccessBlock = ^{
                    //                    RedPacketViewController *packetVC = [[RedPacketViewController alloc] init];
                    //                    [self.navigationController pushViewController:packetVC animated:YES];
                    MyCouponViewController *couponVC = [[MyCouponViewController alloc] init];
                    [self.navigationController pushViewController:couponVC animated:YES];
                };
                [self presentViewController:navi animated:YES completion:nil];
            } else {
                //                RedPacketViewController *packetVC = [[RedPacketViewController alloc] init];
                //                [self.navigationController pushViewController:packetVC animated:YES];
                MyCouponViewController *couponVC = [[MyCouponViewController alloc] init];
                [self.navigationController pushViewController:couponVC animated:YES];
            }
            
        }
            break;
            
        default:
            break;
    }
}

-(void)menuSubViewsHandle
{
    _menuTitles = @[@"切换超市",@"联系超市",@"收藏超市"];
    _menuImages = @[[UIImage imageNamed:@"menu_super"],[UIImage imageNamed:@"menu_contect"],[UIImage imageNamed:@"menu_collection"]];
}

#define kMarketHomeName_width 80
#define kMenuBtn_width 25

-(void)marketHomeNaviBarHandle
{
    self.navigationController.navigationBar.barTintColor = kRedColor;
    //超市名字
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:kMarket_name];
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:name];
    
//    //菜单栏
//    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    menuBtn.frame = CGRectMake(0, 0, kMenuBtn_width, kMenuBtn_width);
//    [menuBtn setBackgroundImage:[UIImage imageNamed:@"home_list"] forState:UIControlStateNormal];
//    [menuBtn addTarget:self action:@selector(menuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    //搜索
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    searchBtn.frame = CGRectMake(0, 0, kMenuBtn_width, kMenuBtn_width);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = searchItem;
}

-(void)searchAction:(UIButton *)btn
{
    SearchResultViewController *searchVC = [[SearchResultViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:NO];
}

//-(void)menuBtnAction:(UIButton *)btn
//{
//    NSLog(@"=========== 菜单");
//    _showMenu = !_showMenu;
//    if (_showMenu) {
//        NSArray *menuItems = @[[KxMenuItem menuItem:_menuTitles[0] image:_menuImages[0] target:self action:@selector(menumItemAction:)],[KxMenuItem menuItem:_menuTitles[1] image:_menuImages[1] target:self action:@selector(menumItemAction:)],[KxMenuItem menuItem:_menuTitles[2] image:_menuImages[2] target:self action:@selector(menumItemAction:)]];
//        [KxMenu showMenuInView:self.view fromRect:CGRectMake(kScreen_width-40, 35, btn.width, btn.height) menuItems:menuItems];
//        
//        for (UIView *view in self.view.subviews) {
//            if ([view isKindOfClass:[KxMenuOverlay class]]) {
//                view.alpha = 0.7;
//                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapKxMenuOverlayAction:)];
//                [view addGestureRecognizer:tap];
//            }
//        }
//    } else {
//        [KxMenu dismissMenu];
//    }
//}

-(void)tapKxMenuOverlayAction:(UITapGestureRecognizer *)tap
{
    _showMenu = NO;
    [KxMenu dismissMenu];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

//-(void)menumItemAction:(id)sender
//{
//    _showMenu = NO;
//    KxMenuItem *menumItem = (KxMenuItem *)sender;
//    if ([menumItem.title isEqualToString:_menuTitles[0]]) {//========= 切换超市
//
//        
//        
//
//    } else if ([menumItem.title isEqualToString:_menuTitles[1]]) {//============ 电话联系超市
//        
//        
//        
//    } else if ([menumItem.title isEqualToString:_menuTitles[2]]) {//收藏超市
//        [self storeCollection];
//    }
//}

//收藏超市
-(void)storeCollection{

    NSString *member_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"member_id"];
    if (member_id !=NULL) {
        [self collectionRequestWithMember_id:member_id];
        
    }else{
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.isPresent = YES;
        loginVC.dismissBlock = ^{
            self.tabBarController.selectedIndex = 0;
        };
        loginVC.loginSuccessBlock = ^{
            NSString *loginmember_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"member_id"];
            [self collectionRequestWithMember_id:loginmember_id];
        };
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.tabBarController presentViewController:navi animated:NO completion:nil];
    }
}

-(void)collectionRequestWithMember_id:(NSString *)member_id
{
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"]];
    
    NSString *store_id = [dataDic objectForKey:@"store_id"];
    NSString *store_name = [dataDic objectForKey:@"store_name"];
    NSString *store_address = [dataDic objectForKey:@"address"];
    NSString *store_pic = [dataDic objectForKey:@"pic"];
    NSString *store_dis = [dataDic objectForKey:@"store_dis"];
    NSString *para = [NSString stringWithFormat:@"member_id=%@&store_id=%@&store_name=%@&store_address=%@&store_pic=%@&store_dis=%@",member_id,store_id,store_name,store_address,store_pic,store_dis];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=favorite_stores"] postData:para];
    request.successRequest = ^(NSDictionary *dataDic)
    {
        NSNumber *codeNum = [dataDic objectForKey:@"code"];
        int code = [codeNum intValue];
        if (code == 200) {
            [self.view makeToast:@"收藏成功~" duration:.8 position:@"center"];
        }else if (code==202){
            
            [self.view makeToast:@"您已经收藏过该超市~" duration:.8 position:@"center"];
        }else if (code==203){
            
            [self.view makeToast:@"超市收藏列表已满，请删除部分收藏后重新收藏~" duration:.8 position:@"center"];
        }
        else{
            [self.view makeToast:@"收藏失败~" duration:.8 position:@"center"];
        }
    };
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _otherTypeGoods.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *customCellID = @"fruit";
    FruitHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customCellID];
    if (!cell) {
        cell = [[FruitHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HomeGoodsItem *item = _otherTypeGoods[indexPath.row];
    cell.goodsItem = item;
    
    //加入购物车
    __weak FruitHomeTableViewCell *weakCell = cell;
    __weak MaketHomeViewController *weakSelf = self;
    cell.fruitActionBlock = ^(UITapGestureRecognizer *tap){
        
        _tapPoint = [tap locationInView:self.view];
        [YanMethodManager showIndicatorOnView:tableView];
        NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
        //加入购物车判断所选商品数量是否大于0
        if (weakCell.selectCountView.countLabel.text.integerValue > 0) {
            //加入购物车判断是否登录状态
            if (member_id!=NULL) {
                [weakSelf fruitAddIntoCartWithItem:item cell:weakCell tap:tap];
            }else{
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
                loginVC.dismissBlock = ^{
                    [YanMethodManager hideIndicatorFromView:weakSelf.view];
                };
                loginVC.loginSuccessBlock = ^{
                    [weakSelf fruitAddIntoCartWithItem:item cell:weakCell tap:tap];
                };
                [weakSelf presentViewController:navi animated:YES completion:nil];
            }
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
    __weak MaketHomeViewController *weakSelf = self;
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
//            [weakSelf.view makeToast:@"已加入购物车" duration:1 position:@"center"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf addGoodsIntoCartWithGesture:tap];
            });
            
            
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (!_marketIsLogin) {
        _marketIsLogin = YES;
        [self systemIsOpenHandleFruitIndext:indexPath tableView:tableView];
    }
    
    
}
//立即购买前先判断超市系统状态
-(void)systemIsOpenHandleFruitIndext:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    [YanMethodManager showIndicatorOnView:self.view];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [storeDic objectForKey:@"store_id"];
        [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=isopenstore"] postData:[NSString stringWithFormat:@"store_id=%@",store_id]];
    __weak MaketHomeViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *packageDic){
        _marketIsLogin = NO;
        [YanMethodManager hideIndicatorFromView:weakSelf.view];
        NSLog(@"===== package dic = %@",packageDic);
        NSNumber *code = [packageDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSNumber *isOpen = [packageDic objectForKey:@"isopen"];
            if (isOpen.integerValue == 1) {
               
                [weakSelf jumptobuyFruitIndext:indexPath tableView:tableView];
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
-(void)jumptobuyFruitIndext:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_name = [storeDic objectForKey:@"store_name"];
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    FruitHomeTableViewCell *cell = (FruitHomeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (member_id == NULL) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
        loginVC.loginSuccessBlock = ^{
            HomeGoodsItem *item = _otherTypeGoods[indexPath.row];
            PayRightNowViewController *payVC = [[PayRightNowViewController alloc] init];
            payVC.goods_name = item.goods_name;
            payVC.price = [NSString stringWithFormat:@"%.1f",item.goods_price];
            payVC.count = cell.selectCountView.countLabel.text;
            payVC.market_name = store_name;
            payVC.goods_id = item.goods_id;
            payVC.store_id = item.store_id;
            payVC.isHotGoods = NO;
            [self.navigationController pushViewController:payVC animated:YES];
        };
        [self presentViewController:navi animated:YES completion:nil];
    } else {
        HomeGoodsItem *item = _otherTypeGoods[indexPath.row];
        PayRightNowViewController *payVC = [[PayRightNowViewController alloc] init];
        payVC.goods_name = item.goods_name;
        payVC.price = [NSString stringWithFormat:@"%.1f",item.goods_price];
        payVC.count = cell.selectCountView.countLabel.text;
        payVC.market_name = store_name;
        payVC.goods_id = item.goods_id;
        payVC.store_id = item.store_id;
        payVC.isHotGoods = NO;
        [self.navigationController pushViewController:payVC animated:YES];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [_topView.timer setFireDate:[NSDate distantPast]];
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    if (member_id != NULL) {
        if (_isOtherType) {
            [self redPackageRequest];
        } else {
            if (_loadSpecialPrice && _loadCommen && _loadDrinks && _loadPackege) {
                [self redPackageRequest];
            }
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [TalkingData trackPageBegin:@"店铺首页"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [TalkingData trackPageEnd:@"店铺首页"];
    [_topView.timer setFireDate:[NSDate distantFuture]];
    if (_lightTimer) {
        [_lightTimer invalidate];
        _lightTimer = nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearDisk];
    // Dispose of any resources that can be recreated.
}



@end
