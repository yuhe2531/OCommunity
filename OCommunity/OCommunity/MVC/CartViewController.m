//
//  CartViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/28.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "CartViewController.h"
#import "CartTableViewCell.h"
#import "SelectCountView.h"
#import "PayBillViewController.h"
#import "CartSectionView.h"
#import "CartGoodsItem.h"
#import "LoginViewController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

@interface CartViewController ()<UIGestureRecognizerDelegate>

{
    
    UILabel *_totalPriceLabel;
    UIButton *selectAllBtn;
    UIButton *payBtn;
}

@property (nonatomic, assign) BOOL isSelectAll;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cartItems;
@property (nonatomic, assign) float totalPrice;
@property (nonatomic, strong) NSMutableArray *isSelectSectionArr;//BOOL
@property (nonatomic, strong) NSMutableArray *rowsSelectedArr;//BOOL
@property (nonatomic, strong) NSMutableArray *pushDataArray;
@property (nonatomic, assign) BOOL hasLoad;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) BOOL isDelete;
@property(nonatomic,assign)BOOL marketIsLogin;
@property (nonatomic, strong) NSMutableArray *delItemsArray;


@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kRedColor;
    _isRefresh = NO;
    _isSelectSectionArr = [NSMutableArray array];
    _cartItems = [NSMutableArray array];
    _rowsSelectedArr = [NSMutableArray array];
    _pushDataArray = [NSMutableArray array];
    _totalPrice = 0.0;
    _isSelectAll = YES;
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"购物车"];
    if (_isPush) {
        self.tabBarController.tabBar.hidden = YES;
        [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(cartPop)];
    }
    [self clearCart];
    
    [self addTableInCartView];
//    [self cartRequest];
    // Do any additional setup after loading the view.
}

-(void)clearCart
{
    UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cleanBtn.frame = CGRectMake(0, 0, 25, 25);
//    [cleanBtn setTitle:@"清除" forState:UIControlStateNormal];
    [cleanBtn setBackgroundImage:[UIImage imageNamed:@"del_garbage"] forState:UIControlStateNormal];
    [cleanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cleanBtn addTarget:self action:@selector(cleanCartAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cleanBtn];
}

-(void)cleanCartAction
{
    _delItemsArray = [NSMutableArray array];
    for (int i = 0; i < _isSelectSectionArr.count; i++) {
        NSMutableArray *tempArr = _rowsSelectedArr[i];
        NSMutableArray *itemArr = _cartItems[i];
        for (int j = 0; j < tempArr.count; j++) {
            NSString *eigherYes = tempArr[j];
            CartGoodsItem *item = itemArr[j];
            if ([eigherYes isEqualToString:@"yes"]) {
                [_delItemsArray addObject:item];
            }
        }
    }
    if (_delItemsArray.count <= 0) {
        [self.view makeToast:@"您没有选择要删除的商品" duration:1.5 position:@"center"];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要删除选中的购物车商品?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
            NSString *telephone = [storeDic objectForKey:@"telephone"];
            
            [[YanMethodManager defaultManager] callPhoneActionWithNum:telephone viewController:self];
        }
    } else {
        if (buttonIndex == 1) {
            
            [self deleteCartData];
        } else {
            [_delItemsArray removeAllObjects];
            _delItemsArray = nil;
        }
    }
    
}

-(void)deleteCartData
{
    NSLog(@"====== section count = %ld  ----- row count = %ld ------- item count = %ld",_isSelectSectionArr.count,_rowsSelectedArr.count,_cartItems.count);
    
    [YanMethodManager showIndicatorOnView:_tableView];
    
    NSString *shopCar_ids = nil;
    for (int i = 0; i < _delItemsArray.count; i++) {
        CartGoodsItem *item = _delItemsArray[i];
        if (i == 0) {
            shopCar_ids = [NSString stringWithFormat:@"%ld",(long)item.shopcar_id];
        } else {
            shopCar_ids = [shopCar_ids stringByAppendingString:[NSString stringWithFormat:@",%ld",(long)item.shopcar_id]];
        }
    }
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NSLog(@"========== shop ids = %@ \n member_id = %@",shopCar_ids,member_id);
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=delshopcar"] postData:[NSString stringWithFormat:@"shopcar_id=%@&member_id=%@",shopCar_ids,member_id]];
    __weak CartViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *cleanDic){
        [weakSelf cartRequest];
    };
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    if (_isPush) {
        self.tabBarController.tabBar.hidden = YES;
    } else {
        self.tabBarController.tabBar.hidden = NO;
    }
    self.navigationController.navigationBarHidden = NO;
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    if (userName == NULL) {
        _hasLoad = NO;
    }
    __weak CartViewController *weakSelf = self;
    [super viewWillAppear:animated];
    if (_hasLoad == NO) {//未登录情况
        
        if (userName == NULL) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.isPresent = YES;
            loginVC.dismissBlock = ^{
                weakSelf.tabBarController.selectedIndex = 0;
            };
            loginVC.loginSuccessBlock = ^{
                [weakSelf cartRequest];
            };
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [self.tabBarController presentViewController:navi animated:NO completion:nil];
        } else {
            //登录情况
            [self cartRequest];
        }
    }
//    else {
//        if (_cartItems.count == 0) {
//            
//        }
//    }
    if (_hasLoad) {
        [self cartRequest];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [TalkingData trackPageBegin:@"购物车页面"];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (_isPush) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (_isPush) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    if (_isPush) {
        self.navigationController.navigationBarHidden = YES;
    }
    [TalkingData trackPageEnd:@"购物车页面"];
}

-(void)cartRequest{
    
    if (!_hasLoad) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
    }
    payBtn.enabled = NO;
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NSString *para = [NSString stringWithFormat:@"member_id=%@",userID];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=shopcarlist"] postData:para];
    __weak CartViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *dataDic){
        NSLog(@"=========== cart data = %@",dataDic);
       weakSelf.isRefresh = NO;
        [weakSelf.tableView.header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [YanMethodManager hideIndicatorFromView:_tableView];
        NSNumber *code = [dataDic objectForKey:@"code"];
        if (code.intValue == 200) {
            weakSelf.hasLoad = YES;
            [weakSelf successDataHandleWithDic:dataDic];
            if (_cartItems.count <= 0) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"local_cartGoodsCount"];
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"local_cartGoodsCount"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (UINavigationController *navi in weakSelf.navigationController.tabBarController.viewControllers) {
                        if ([navi.topViewController isKindOfClass:[CartViewController class]]) {
                            
                            navi.tabBarItem.badgeValue = nil;
                        }
                    }
                });
            }
            [_tableView reloadData];
        }
        payBtn.enabled = YES;
    };
    
    request.failureRequest = ^(NSError *error){
        [weakSelf.tableView.header endRefreshing];
        payBtn.enabled = YES;
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    };
}

-(void)successDataHandleWithDic:(NSDictionary *)dic
{
    [_cartItems removeAllObjects];
    NSMutableArray *tempArr = [NSMutableArray array];
    NSArray *datas = [dic objectForKey:@"datas"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"local_cartGoodsCount"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",datas.count] forKey:@"local_cartGoodsCount"];
    _totalPrice = 0.0;
    __weak CartViewController *weakSelf = self;
    if (!_isPush) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UINavigationController *navi in weakSelf.navigationController.tabBarController.viewControllers) {
                if ([navi.topViewController isKindOfClass:[CartViewController class]]) {
                    if (datas.count > 0) {
                        navi.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",datas.count];
                    } else {
                        navi.tabBarItem.badgeValue = nil;
                    }
                }
            }
        });
    }
    
    for (int i = 0; i < datas.count; i++) {
        NSDictionary *itemDic = datas[i];
        NSNumber *price = [itemDic objectForKey:@"price"];
        NSNumber *count = [itemDic objectForKey:@"number"];
        _totalPrice += (price.floatValue*count.integerValue);
        NSString *storeName = [itemDic objectForKey:@"store_name"];
        BOOL hasSame = NO;
        if (tempArr.count > 0) {
            int i = 0;
            for (; i < tempArr.count; i++) {
                if ([storeName isEqualToString:tempArr[i]]) {
                    hasSame = YES;
                }
            }
            if (!hasSame) {
                [tempArr addObject:storeName];
            }
        } else {
            [tempArr addObject:storeName];
        }
    }
    _totalPriceLabel.text = [NSString stringWithFormat:@"合计:%.2f",_totalPrice];
    _totalPriceLabel.textColor = kRed_PriceColor;
    
    [_isSelectSectionArr removeAllObjects];
    for (int m = 0; m < tempArr.count; m++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j < datas.count; j++) {
            NSDictionary *dataDic = datas[j];
            CartGoodsItem *cartItem = [[CartGoodsItem alloc] initWithDic:dataDic];
            
            if ([cartItem.store_name isEqualToString:tempArr[m]]) {
                [array addObject:cartItem];
            }
        }
        if (array.count > 0) {
            [_cartItems addObject:array];
            [_isSelectSectionArr addObject:@"yes"];
        }
    }
    if (_cartItems.count == 0) {
        [YanMethodManager emptyDataInView:_tableView title:@"购物车是空的"];
    } else {
        [YanMethodManager removeEmptyViewOnView:_tableView];
    }
    
    
    [_rowsSelectedArr removeAllObjects];
    for (int i = 0; i < _cartItems.count; i++) {
        NSMutableArray *rowsArr = [NSMutableArray array];
        NSMutableArray *array = _cartItems[i];
        for (int j = 0; j < array.count; j++) {
            [rowsArr addObject:@"yes"];
        }
        [_rowsSelectedArr addObject:rowsArr];
    }
    
    [_tableView reloadData];
    [selectAllBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
}

-(void)cartPop
{
    if (self.cartPopBlock) {
        self.cartPopBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#define kBottomView_height 49

#define kPayBtn_right 10
#define kPayBtn_width 60
#define kPayBtn_height 35

-(void)addTableInCartView
{
    CGFloat height = _isPush ? (kScreen_height-64-kBottomView_height) : (kScreen_height-64-kBottomView_height-49);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *tabBotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 2)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreen_width, 0.5)];
    line.backgroundColor = kDividColor;
    [tabBotView addSubview:line];
    _tableView.tableFooterView = tabBotView;
    
    __weak CartViewController *weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        if (weakSelf.isRefresh == NO) {
            weakSelf.totalPrice = 0.0;
            weakSelf.isRefresh = YES;
            [weakSelf cartRequest];
        }
    }];
    
    CGFloat top = _isPush ? (kScreen_height-kBottomView_height) : (kScreen_height-kBottomView_height-49);
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, top, kScreen_width, kBottomView_height)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    selectAllBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    selectAllBtn.frame = CGRectMake(15, 0, 25, 25);
    selectAllBtn.centerY = bottomView.height/2;
    selectAllBtn.layer.cornerRadius = 25/2.0;
    [selectAllBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    selectAllBtn.clipsToBounds = YES;
    [selectAllBtn addTarget:self action:@selector(selectAllGoodsAction:) forControlEvents:UIControlEventTouchUpInside];
    selectAllBtn.centerY = kBottomView_height/2;
    [bottomView addSubview:selectAllBtn];
    
    UILabel *selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(selectAllBtn.right+10, 0, 50, 20)];
    selectLabel.text = @"全选";
    selectLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    selectLabel.centerY = selectAllBtn.centerY;
    [bottomView addSubview:selectLabel];
    
    payBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    payBtn.frame = CGRectMake(kScreen_width-kPayBtn_right-kPayBtn_width, 0, kPayBtn_width, kPayBtn_height);
    payBtn.layer.cornerRadius = 5;
    payBtn.centerY = selectAllBtn.centerY;
    payBtn.backgroundColor = kRedColor;
    [payBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    [payBtn addTarget:self action:@selector(gotoSettleAccount:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.enabled = NO;
    [bottomView addSubview:payBtn];
    
    CGFloat width = kScreen_width - kPayBtn_right -kPayBtn_width - selectAllBtn.width - 25 - selectLabel.width - 20;
    _totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_width-kPayBtn_right-kPayBtn_width-kPayBtn_right-width, payBtn.top, width, payBtn.height)];
    _totalPriceLabel.textAlignment = NSTextAlignmentRight;
    _totalPriceLabel.text = @"合计:¥0.0";
    _totalPriceLabel.textColor = kRedColor;
    _totalPriceLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    [bottomView addSubview:_totalPriceLabel];
}

//进入结算页面
-(void)gotoSettleAccount:(UIButton *)button
{
    
    if (!_marketIsLogin) {//防止重复点击
        _marketIsLogin = YES;
        NSLog(@"========= 去结算");
        [self systemIsOpenHandle];
    }
}



//立即购买前先判断超市系统状态
-(void)systemIsOpenHandle
{
    if (_cartItems.count > 0) {
        [_pushDataArray removeAllObjects];
        for (int i = 0; i < _rowsSelectedArr.count; i++) {
            NSMutableArray *rowArr = _rowsSelectedArr[i];
            NSMutableArray *itemArr = _cartItems[i];
            NSMutableArray *transArr = [NSMutableArray array];
            for (int j = 0; j < rowArr.count; j++) {
                NSString *rowStr = rowArr[j];
                CartGoodsItem *item = itemArr[j];
                if ([rowStr isEqualToString:@"yes"]) {
                    [transArr addObject:item];
                }
            }
            if (transArr.count > 0) {
                [_pushDataArray addObject:transArr];
            }
        }
        if (_pushDataArray.count == 1) {
//            NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
//            NSString *store_id = [storeDic objectForKey:@"store_id"];
            NSMutableArray *transArr = _pushDataArray[0];
            CartGoodsItem *item = transArr[0];
            NetWorkRequest *request = [[NetWorkRequest alloc] init];
            [YanMethodManager showIndicatorOnView:self.view];
            [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=isopenstore"] postData:[NSString stringWithFormat:@"store_id=%ld",item.store_id]];
            __weak CartViewController *weakSelf = self;
            request.successRequest = ^(NSDictionary *packageDic){
                NSLog(@"===== package dic = %@",packageDic);
                [YanMethodManager hideIndicatorFromView:self.view];
                _marketIsLogin = NO;
                NSNumber *code = [packageDic objectForKey:@"code"];
                if (code.integerValue == 200) {
                    NSNumber *isOpen = [packageDic objectForKey:@"isopen"];
                    if (isOpen.integerValue == 1) {
                        [weakSelf payBillAction];
                    } else {
                        //亲!店家已打烊,若有急需请电联
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲!店家已打烊,若有急需请电联" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"打电话", nil];
                        alert.tag = 101;
                        [alert show];
                    }
                }
            };
            request.failureRequest = ^(NSError *error){
                [YanMethodManager hideIndicatorFromView:self.view];
                _marketIsLogin = NO;
            };
        } else {
            _marketIsLogin = NO;
            [self.view makeToast:@"请选择一家超市进行结算" duration:1.5 position:@"center"];
        }
        
    } else {
        _marketIsLogin = NO;
        [self.view makeToast:@"购物车是空的" duration:1.5 position:@"center"];
    }
    
    
    
}

-(void)payBillAction
{
    PayBillViewController *payBillVC = [[PayBillViewController alloc] init];
    payBillVC.bills = _pushDataArray;
//    __weak CartViewController *weakSelf = self;
//    payBillVC.paySuccessBlock = ^{
//        [weakSelf cartRequest];
//    };
    [self.navigationController pushViewController:payBillVC animated:YES];
}

//全选
-(void)selectAllGoodsAction:(UIButton *)button
{
    _isSelectAll = !_isSelectAll;
    if (_isSelectAll) {
        [button setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        for (int i = 0; i < _isSelectSectionArr.count; i++) {
            NSString *str = _isSelectSectionArr[i];
            if ([str isEqualToString:@"no"]) {
                [_isSelectSectionArr replaceObjectAtIndex:i withObject:@"yes"];
            }
            NSMutableArray *rowArr = _rowsSelectedArr[i];
            for (int k = 0; k < rowArr.count; k++) {
                NSString *rowStr = rowArr[k];
                if ([rowStr isEqualToString:@"no"]) {
                    [rowArr replaceObjectAtIndex:k withObject:@"yes"];
                }
            }
        }
        
    } else {
        [button setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
        for (int i = 0; i < _isSelectSectionArr.count; i++) {
            NSString *str = _isSelectSectionArr[i];
            if ([str isEqualToString:@"yes"]) {
                [_isSelectSectionArr replaceObjectAtIndex:i withObject:@"no"];
            }
            NSMutableArray *rowArr = _rowsSelectedArr[i];
            for (int j = 0; j < rowArr.count; j++) {
                NSString *rowStr = rowArr[j];
                if ([rowStr isEqualToString:@"yes"]) {
                    [rowArr replaceObjectAtIndex:j withObject:@"no"];
                }
            }
        }
    }
    [_tableView reloadData];
    [self totalPriceHandle];
}

#pragma mark UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _isSelectSectionArr.count;
}

#define kCart_talble_section_header_height 30

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableArray *sectionArr = _cartItems[section];
    CartGoodsItem *item = sectionArr[0];
    CartSectionView *cartSectionView = [[CartSectionView alloc] initWithFrame:CGRectMake(15, 0, kScreen_width-30, kCart_talble_section_header_height) title:item.store_name];
    cartSectionView.backgroundColor = kColorWithRGB(239, 239, 244);
    NSString *sectionSelectedStr = _isSelectSectionArr[section];
    if ([sectionSelectedStr isEqualToString:@"yes"]) {
        cartSectionView.isSelected = YES;
    } else {
        cartSectionView.isSelected = NO;
    }
    __weak CartSectionView *weakCart = cartSectionView;
    __weak CartViewController *weakSelf = self;
    cartSectionView.selectBlock = ^(UIButton *button){
        if (weakCart.isSelected) {
            [weakSelf.isSelectSectionArr replaceObjectAtIndex:section withObject:@"yes"];
            [button setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
            NSMutableArray *rowsArray = weakSelf.rowsSelectedArr[section];
            for (int i = 0; i < rowsArray.count; i++) {
                NSString *str = rowsArray[i];
                if ([str isEqualToString:@"no"]) {
                    [rowsArray replaceObjectAtIndex:i withObject:@"yes"];
                }
            }
        } else {
            [weakSelf.isSelectSectionArr replaceObjectAtIndex:section withObject:@"no"];
            NSMutableArray *rowArr = _rowsSelectedArr[section];
            for (int i = 0; i < rowArr.count; i++) {
                NSString *rowStr = rowArr[i];
                if ([rowStr isEqualToString:@"yes"]) {
                    [rowArr replaceObjectAtIndex:i withObject:@"no"];
                }
            }
            [button setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
        }
        [weakSelf isSelectAllBtnMark];
        [weakSelf.tableView reloadData];
    };
    
    return cartSectionView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kCart_talble_section_header_height;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *sectionArr = _cartItems[section];
    return sectionArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *sectionArr = _cartItems[indexPath.section];
    CartGoodsItem *item = sectionArr[indexPath.row];
    static NSString *cart = @"cart";
    CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cart];
    if (!cell) {
        cell = [[CartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cart];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.cartItem = item;

    NSMutableArray *rowsSelectedSectionArr = _rowsSelectedArr[indexPath.section];
    NSString *rowSelectedStr = rowsSelectedSectionArr[indexPath.row];
    if ([rowSelectedStr isEqualToString:@"yes"]) {
        item.isSelected = YES;
    } else {
        item.isSelected = NO;
    }
    cell.isSelect = item.isSelected;
    
    //数量
    __weak CartViewController *weakSelf = self;
    cell.selectCountViewBlock = ^(UIButton *button){
        [weakSelf cartCellCountWithButton:button indexpath:indexPath];
    };
    //是否选中购买
//    __weak CartTableViewCell *weakCartCell = cell;
    cell.selectGoodsBlock = ^{
        item.isSelected = !item.isSelected;
        if (item.isSelected == NO) {
            [_isSelectSectionArr replaceObjectAtIndex:indexPath.section withObject:@"no"];
            [rowsSelectedSectionArr replaceObjectAtIndex:indexPath.row withObject:@"no"];
            
        } else {
            [rowsSelectedSectionArr replaceObjectAtIndex:indexPath.row withObject:@"yes"];
        }
        [weakSelf isSelectAllBtnMark];
        [_tableView reloadData];
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)isSelectAllBtnMark
{
    BOOL isYes = YES;
    for (int i = 0; i < _isSelectSectionArr.count; i++) {
        NSString *yesStr = _isSelectSectionArr[i];
        if ([yesStr isEqualToString:@"no"]) {
            isYes = NO;
        }
    }
    if (isYes == YES) {
        _isSelectAll = YES;
        [selectAllBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        for (int i = 0; i < _isSelectSectionArr.count; i++) {
            NSString *sectionStr = _isSelectSectionArr[i];
            if ([sectionStr isEqualToString:@"no"]) {
                sectionStr = @"yes";
            }
            NSMutableArray *rowArray = _rowsSelectedArr[i];
            for (int j = 0; j < rowArray.count; j++) {
                NSString *rowBoolStr = rowArray[j];
                if ([rowBoolStr isEqualToString:@"no"]) {
                    [rowArray replaceObjectAtIndex:j withObject:@"yes"];
                }
            }
        }
    } else {
        _isSelectAll = NO;
        [selectAllBtn setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
    }
    [self totalPriceHandle];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (_isDelete == NO) {
            _isDelete = YES;
            [YanMethodManager showIndicatorOnView:self.view];
            //删除cell的操作
            NSLog(@"======== shanchushi  section = %ld,item = %ld",_rowsSelectedArr.count, _cartItems.count);
            NSMutableArray *sectionArr = _cartItems[indexPath.section];
            NSMutableArray *rowArr = _rowsSelectedArr[indexPath.section];
            CartGoodsItem *item = sectionArr[indexPath.row];
            NetWorkRequest *request = [[NetWorkRequest alloc] init];
            NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
            [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=delshopcar"] postData:[NSString stringWithFormat:@"shopcar_id=%ld&member_id=%@",(long)item.shopcar_id,member_id]];
            request.successRequest = ^(NSDictionary *dataDic){
                _isDelete = NO;
                NSNumber *code = [dataDic objectForKey:@"code"];
                [YanMethodManager hideIndicatorFromView:self.view];
                if (code.integerValue == 200) {
                    [sectionArr removeObjectAtIndex:indexPath.row];
                    [rowArr removeObjectAtIndex:indexPath.row];
//                    [_cartItems replaceObjectAtIndex:indexPath.section withObject:sectionArr];
//                    [_rowsSelectedArr replaceObjectAtIndex:indexPath.section withObject:rowArr];
                    if (sectionArr.count == 0) {
                        [_cartItems removeObjectAtIndex:indexPath.section];
                        [_rowsSelectedArr removeObjectAtIndex:indexPath.section];
                        [_isSelectSectionArr removeObjectAtIndex:indexPath.section];
                        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                    } else {
                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                    }
                    NSString *cartCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"local_cartGoodsCount"];
                    NSInteger count = cartCount.integerValue - 1;
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",count] forKey:@"local_cartGoodsCount"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        for (UINavigationController *navi in self.navigationController.tabBarController.viewControllers) {
                            if ([navi.topViewController isKindOfClass:[CartViewController class]]) {
                                if (count > 0) {
                                    navi.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",count];
                                } else {
                                    navi.tabBarItem.badgeValue = nil;
                                }
                            }
                        }
                    });
                    
                    
                    if (!_isPush) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            for (UINavigationController *navi in self.navigationController.tabBarController.viewControllers) {
                                if ([navi.topViewController isKindOfClass:[CartViewController class]]) {
                                    if (count > 0) {
                                        navi.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",count];
                                    } else {
                                        navi.tabBarItem.badgeValue = nil;
                                    }
                                    
                                }
                            }
                        });
                    }
                    
                    [self totalPriceHandle];
                    if (_cartItems.count == 0) {
                        [YanMethodManager emptyDataInView:_tableView title:@"购物车是空的"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"local_cartGoodsCount"];
                    }
                    
                } else {
                    [self.view makeToast:@"删除失败" duration:1.5 position:@"center"];
                }
                [_tableView reloadData];
            };
        }
        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)cartCellCountWithButton:(UIButton *)button indexpath:(NSIndexPath *)indexPath
{
    CartTableViewCell *cell = (CartTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    NSInteger count = cell.selectCountV.countLabel.text.integerValue;
    switch (button.tag) {
        case 560:{//-
            if (count > 1) {
                count--;
            }
        }
            break;
        case 561:{//+
            count++;
        }
            break;
            
        default:
            break;
    }
    NSMutableArray *sectionArr = _cartItems[indexPath.section];
    CartGoodsItem *item = sectionArr[indexPath.row];
    item.number = count;
    [sectionArr replaceObjectAtIndex:indexPath.row withObject:item];
    [self totalPriceHandle];
    [_tableView reloadData];
}

-(void)totalPriceHandle
{
    _totalPrice = 0.0;
    for (int i = 0; i < _cartItems.count; i++) {
        NSMutableArray *array = _cartItems[i];
        NSMutableArray *rowArr = _rowsSelectedArr[i];
        for (int j = 0; j < array.count; j++) {
            NSString *rowStr = rowArr[j];
            if ([rowStr isEqualToString:@"yes"]) {
                CartGoodsItem *cartItem = array[j];
                float price = [NSString stringWithFormat:@"%.2f",cartItem.price].floatValue;
                _totalPrice += cartItem.number * price;
            }
        }
    }
    _totalPriceLabel.text = [NSString stringWithFormat:@"合计:%.2f",_totalPrice];
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
