//
//  GoodsListViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/27.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsListTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "PayRightNowViewController.h"
#import "MyColllectionTableViewCell.h"
#import "MyCommentViewController.h"
#import "HomeGoodsItem.h"
#import "ListSubItem.h"
#import "JSBadgeView.h"
#import "CartViewController.h"
#import "LoginViewController.h"

#define viewX 43

#define kPageSize 16

@interface GoodsListViewController ()<UIGestureRecognizerDelegate>

{
    UIView *backGroundView;
    UIButton *arrowBtn;
    int _currentPage;
    int _totalPage;
    JSBadgeView *_badgeView;
   
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *subTableView;
@property (nonatomic, strong) NSMutableArray *goodsitemsArr;
@property (nonatomic, assign) BOOL showSubclass;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSMutableArray *subItemsArr;
@property (nonatomic, assign) int sub_class_id;
@property (nonatomic, assign) BOOL isSubGoods;
@property (nonatomic, strong) UIView *cartView;
@property (nonatomic, assign) BOOL isLoadSub;
@property (nonatomic, assign) BOOL isLoadMarkStatus;

@end

@implementation GoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _isLoadSub = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"========== class id = %d",_class_id);
    _goodsitemsArr = [NSMutableArray array];
    _subItemsArr = [NSMutableArray array];
    _showSubclass = YES;
    _isLoading = NO;
    _currentPage = 1;
    _sub_class_id = -1;
//    NSString *title = _haveBuy ? @"已购买商品" : _naviTitle;
//    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:title];
//    if (_haveBuy) {
//        self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"已购买商品"];
//
//    } else {
        [self goodsCategoryItemTitleHandle];
//    }
    
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(goodsListPop)];
    [self goodsListSubviews];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @" 加载中...";
    [self goodsListRequestDataHandleWithClassID:_class_id];

    // Do any additional setup after loading the view.
}

#define kBottomView_height 40

-(void)goodsListSubviews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-64-49) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kBottomView_height)];
    _tableView.tableFooterView = _bottomView;
    
    [self addBottomCartView];
}

#define kCartBtn_width 50
-(void)addBottomCartView
{
    //添加购物车实时显示购物车中的商品数量
    UIView *bottomCartView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.bottom, kScreen_width, 49)];
    bottomCartView.backgroundColor = kColorWithRGB(57, 56, 62);
    [self.view addSubview:bottomCartView];
    
    UIView *tempCartView = [[UIView alloc] initWithFrame:CGRectMake(35, bottomCartView.top-10, kCartBtn_width, 50)];
    [self.view addSubview:tempCartView];
    
    UIButton *cartBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cartBtn.frame = tempCartView.bounds;
    [cartBtn setBackgroundImage:[UIImage imageNamed:@"minecart"] forState:UIControlStateNormal];
    cartBtn.layer.cornerRadius = kCartBtn_width/2;
    cartBtn.clipsToBounds = YES;
    [cartBtn addTarget:self action:@selector(listtitleBtnsAction:) forControlEvents:UIControlEventTouchUpInside];
    [tempCartView addSubview:cartBtn];
    
    _badgeView = [[JSBadgeView alloc] initWithParentView:tempCartView alignment:JSBadgeViewAlignmentTopRight];
    NSString *badgeCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"local_cartGoodsCount"];
    if (badgeCount.integerValue > 0) {
        _badgeView.badgeText = badgeCount;
    }
}

-(void)listtitleBtnsAction:(UIButton *)button
{
    __weak GoodsListViewController *weakSelf = self;
    [self isLoginHandle:^{
        CartViewController *cartVC = [[CartViewController alloc] init];
        cartVC.isPush = YES;
        [weakSelf.navigationController pushViewController:cartVC animated:YES];
    } hasLogin:^{
        CartViewController *cartVC = [[CartViewController alloc] init];
        cartVC.isPush = YES;
        [weakSelf.navigationController pushViewController:cartVC animated:YES];
    }];

}


-(void)goodsListRequestDataHandleWithClassID:(int)class_id
{
    _isLoading = YES;
    [YanMethodManager removeEmptyViewOnView:self.view];
    NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [storeDic objectForKey:@"store_id"];
    NSLog(@"=========== list store id = %@",store_id);
    NSString *param;
    if (!_isTejia) {
        param = [NSString stringWithFormat:@"store_id=%d&class_id=%d&pagenumber=%d",store_id.intValue,class_id,_currentPage];
    } else {
         param = [NSString stringWithFormat:@"store_id=%d&is_tejia=%d&pagenumber=%d",store_id.intValue,1,_currentPage];
    }
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=goodslistmore"] postData:param];
    request.successRequest = ^(NSDictionary *requestDic){
        NSLog(@"djagjagdgajhdgjgagj%@",requestDic);
        if (_sub_class_id > 0) {
            _isSubGoods = YES;
            if (_currentPage == 1) {
                [_goodsitemsArr removeAllObjects];
            }
        }
        _isLoading = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [YanMethodManager hideIndicatorFromView:self.view];
        NSNumber *code = [requestDic objectForKey:@"code"];
        if (code.intValue == 200) {
            NSNumber *totalCount = [requestDic objectForKey:@"count"];
            int remainder = totalCount.intValue % kPageSize;
            if (remainder > 0) {
                _totalPage = totalCount.intValue/kPageSize + 1;
            } else {
                _totalPage = totalCount.intValue/kPageSize;
            }
            NSArray *datasArr = [requestDic objectForKey:@"datas"];
            if (datasArr.count > 0) {
                for (int i = 0; i < datasArr.count; i++) {
                    NSDictionary *itemDic = datasArr[i];
                    HomeGoodsItem *item = [[HomeGoodsItem alloc] initWithDic:itemDic];
                    [_goodsitemsArr addObject:item];
                    
                    
                }
            }
            if (_goodsitemsArr.count <= 0) {
                 [YanMethodManager emptyDataInView:self.view title:@"没有此分类商品"];
            }
            
            [_tableView reloadData];
            NSString *haveMore = [requestDic objectForKey:@"haveMore"];
            if ([haveMore isEqualToString:@"true"]) {
                [self loadMoreHandleInView:_bottomView];
            } else {
                [self loadMoreHasDoneHandleInView:_bottomView];
            }
            if (_goodsitemsArr.count > 0) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
    };
    request.failureRequest = ^(NSError *error){
        if (_sub_class_id > 0) {
            _isSubGoods = YES;
        }
        _isLoading = NO;
        [YanMethodManager removeEmptyViewOnView:self.view];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
}


//滚动到最后一行自动刷新数据
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.tableView.contentSize.height-_tableView.contentOffset.y <= _tableView.height+kBottomView_height) {
        if (_currentPage < _totalPage) {
            if (!_isLoading) {
                ++_currentPage;
                if (_isSubGoods) {
                    [self goodsListRequestDataHandleWithClassID:_class_id];
                } else {
                    [self goodsListRequestDataHandleWithClassID:_class_id];
                }
                
                _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, _tableView.contentOffset.y+30);
            }
        }
    }
}


-(void)goodsCategoryItemTitleHandle
{
    CGFloat width = [[YanMethodManager defaultManager] LabelWidthByText:_naviTitle height:30 font:kFontSize_1];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width+30, 30)];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    titleL.text = _naviTitle;
    titleL.font = [UIFont systemFontOfSize:kFontSize_1];
    titleL.textColor = [UIColor whiteColor];
    [view addSubview:titleL];
    if (!_isTejia) {
        arrowBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        arrowBtn.frame = CGRectMake(titleL.right+15, 0, 15, 30);
        [arrowBtn setBackgroundImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
        [arrowBtn addTarget:self action:@selector(arrowBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:arrowBtn];
    }
    self.navigationItem.titleView = view;
    self.navigationItem.rightBarButtonItems = nil;
}

-(void)arrowBtnAction
{
    if (!_isLoadSub) {
        _showSubclass = !_showSubclass;
        if (_showSubclass) {
            [backGroundView removeFromSuperview];
            [_subTableView removeFromSuperview];
            backGroundView = nil;
            _subTableView = nil;
        } else {
            [self subGoodsRequest];
        }
    }
    
}

-(void)addSubTableSubviews
{
    backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-64)];
    backGroundView.backgroundColor = [UIColor blackColor];
    backGroundView.alpha = 0.6;
    [self.view addSubview:backGroundView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundViewAction:)];
    [backGroundView addGestureRecognizer:tap];
    CGFloat height = _subItemsArr.count <= 6 ? (_subItemsArr.count*44) : (6*44);
    _subTableView = [[UITableView alloc] initWithFrame:CGRectMake(200, 64, 100, height) style:UITableViewStylePlain];
    //    _subTableView.backgroundColor = [UIColor orangeColor];
    _subTableView.layer.cornerRadius = 5;
    _subTableView.dataSource = self;
    _subTableView.delegate = self;
    [self.view addSubview:_subTableView];
}

-(void)subGoodsRequest
{
    [_subItemsArr removeAllObjects];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=smallclass"] postData:[NSString stringWithFormat:@"class_id=%d",_sub_calss_id]];
    __weak GoodsListViewController *weakSelf = self;
    _isLoadSub = YES;
    request.successRequest = ^(NSDictionary *subDic){
        _isLoadSub = NO;
        NSLog(@"========= sub class = %@",subDic);
        NSNumber *code = [subDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSArray *dataArr = [subDic objectForKey:@"data"];
            if (dataArr.count > 0) {
                for (int i = 0; i < dataArr.count; i++) {
                    NSDictionary *itemDic = dataArr[i];
                    ListSubItem *item = [[ListSubItem alloc] initWithDic:itemDic];
                    [_subItemsArr addObject:item];
                }
                [weakSelf addSubTableSubviews];
            }else {
                [self.view makeToast:@"没有更多分类" duration:1.0 position:@"center"];
            }
        }
        
    };
    
    request.failureRequest = ^(NSError *error){
        _isLoadSub = NO;
    };
}

-(void)tapBackgroundViewAction:(UITapGestureRecognizer *)tap
{
    _showSubclass = !_showSubclass;
    [backGroundView removeFromSuperview];
    [_subTableView removeFromSuperview];
    backGroundView = nil;
    _subTableView = nil;
}

-(void)goodsListPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _subTableView) {
        return _subItemsArr.count;
    }
    return _goodsitemsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _subTableView) {
        static NSString *subCell = @"subCategory";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:subCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:subCell];
            cell.textLabel.font = [UIFont systemFontOfSize:kFontSize_3];
        }
        ListSubItem *item = _subItemsArr[indexPath.row];
        cell.textLabel.text = item.class_name;
        return cell;
    }
    static NSString *listID = @"listCell";
    HomeGoodsItem *item = _goodsitemsArr[indexPath.row];
    GoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listID];
    if (!cell) {
        cell = [[GoodsListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.hasPurchased = NO;
    }
    cell.isList = YES;
    cell.goodsItem = item;
    if (item.goods_price > 0) {
        cell.tejiaPrice = item.goods_price;
    }
    __weak GoodsListViewController *weakSelf = self;
    
    //选择商品数量
    cell.selectCountBlock = ^(UIButton *button){
        [weakSelf selectCountInCellWithIndexPath:indexPath button:button];
    };
    
    
    //加入购物车
    cell.addCartBlock = ^(UITapGestureRecognizer *tap){
        
        [YanMethodManager showIndicatorOnView:weakSelf.view];
     NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
        if (member_id!=NULL) {
            [weakSelf addGoodsToCart:item withTap:tap withIndexPath:indexPath];

        }else{
            
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.isPresent = YES;
            loginVC.dismissBlock = ^{
                [YanMethodManager hideIndicatorFromView:weakSelf.view];
            };
            loginVC.loginSuccessBlock = ^{
                [weakSelf addGoodsToCart:item withTap:tap withIndexPath:indexPath];
            };
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [weakSelf.tabBarController presentViewController:navi animated:NO completion:nil];

        }
    };
    return cell;
}

-(void)selectCountInCellWithIndexPath:(NSIndexPath *)indexPath button:(UIButton *)button
{
    GoodsListTableViewCell *cell = (GoodsListTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    NSInteger count = cell.selectCountV.countLabel.text.integerValue;
    if (button.tag == 550) {//minuse
        if (count > 1) {
            --count;
        }
    } else {//plus
        ++count;
    }
    
    cell.selectCountV.countLabel.text = [NSString stringWithFormat:@"%ld",count];
}



-(void)addGoodsToCart:(HomeGoodsItem *)model withTap:(UITapGestureRecognizer *)tap withIndexPath:(NSIndexPath *)indexPath{
    
    GoodsListTableViewCell *cell = (GoodsListTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addshopcar"] postData:[NSString stringWithFormat:@"goods_id=%d&quantity=%@&member_id=%@",model.goods_id,cell.selectCountV.countLabel.text,member_id]];
    __weak GoodsListViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *cartDic){
        [YanMethodManager hideIndicatorFromView:weakSelf.view];
        NSNumber *code = [cartDic objectForKey:@"code"];
        int loginCode = [code intValue];//请求数据成功代码号
        if (loginCode == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf addGoodsIntoCartWithGesture:tap indexPath:indexPath];

            });
            NSNumber *count = [cartDic objectForKey:@"count"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)count.integerValue] forKey:@"local_cartGoodsCount"];
            for (UINavigationController *navi in self.tabBarController.viewControllers) {
                if ([navi.topViewController isKindOfClass:[CartViewController class]]) {
                    navi.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)count.integerValue];
                }
            }
        }
        if (loginCode == 203) {
            [weakSelf.view makeToast:@"您的购物车已满,请先结算购物车" duration:1.5 position:@"center"];
        }
        if (loginCode != 200 && loginCode != 203) {
            [weakSelf.view makeToast:@"加入购物车失败" duration:1.5 position:@"center"];
        }
    };
    request.failureRequest = ^(NSError *error){
        [YanMethodManager hideIndicatorFromView:self.view];
        [weakSelf.view makeToast:@"加入购物车失败" duration:1.5 position:@"center"];
    };
    
    
}
//立即购买前先判断超市系统状态
-(void)systemIsOpenHandleWithModel:(HomeGoodsItem *)model
{
    [YanMethodManager showIndicatorOnView:self.view];
    NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [storeDic objectForKey:@"store_id"];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=isopenstore"] postData:[NSString stringWithFormat:@"store_id=%@",store_id]];
    __weak GoodsListViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *packageDic){
//        NSLog(@"===== package dic = %@",packageDic);
        _isLoadMarkStatus = NO;
        [YanMethodManager hideIndicatorFromView:weakSelf.view];
        NSNumber *code = [packageDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSNumber *isOpen = [packageDic objectForKey:@"isopen"];
            if (isOpen.integerValue == 1) {
                [weakSelf isLoginHandle:^{
                    [weakSelf payRightNow:model];
                } hasLogin:^{
                    [weakSelf payRightNow:model];
                    
                }];

            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲!店家已打烊,若有急需请电联" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"打电话", nil];
                alert.tag = 105;
                [alert show];
            }
        }
    };
    request.failureRequest = ^(NSError *error){
    
        _isLoadMarkStatus = NO;
        [YanMethodManager hideIndicatorFromView:weakSelf.view];
    };
}

-(void)payRightNow:(HomeGoodsItem *)model{
    
    NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *marketName = [storeDic objectForKey:@"store_name"];
    PayRightNowViewController *payVC = [[PayRightNowViewController alloc] init];
    payVC.market_name = marketName;
    payVC.goods_name = model.goods_name;
    payVC.goods_id = model.goods_id;
    float sendPrice = _isTejia ? model.tjprice : model.goods_price;
    payVC.price = [NSString stringWithFormat:@"%.1f", sendPrice];
    payVC.count = @"1";
    payVC.store_id = model.store_id;
    [self.navigationController pushViewController:payVC animated:YES];
    
    
}
-(void)isLoginHandle:(void(^)(void))loginSuccess hasLogin:(void(^)(void))hasLoginHandle
{
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    __weak GoodsListViewController *weakSelf = self;
    if (member_id == NULL) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.isPresent = YES;
        loginVC.loginSuccessBlock = ^{
            loginSuccess();
        };
        loginVC.dismissBlock = ^{
            [YanMethodManager hideIndicatorFromView:weakSelf.view];
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.tabBarController presentViewController:nav animated:YES completion:nil];
    } else {
        hasLoginHandle();
    }
}


-(void)gotoCart
{
    [self loginAction];
}

-(void)loginAction
{
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    if (member_id == NULL) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        loginVC.loginSuccessBlock = ^{
            CartViewController *cartVC = [[CartViewController alloc] init];
            cartVC.isPush = YES;
            _badgeView.badgeText = 0;
            [self.navigationController pushViewController:cartVC animated:YES];
        };
        
        [self presentViewController:navi animated:YES completion:nil];
    } else {
        CartViewController *cartVC = [[CartViewController alloc] init];
        cartVC.isPush = YES;
        _badgeView.badgeText = 0;
        [self.navigationController pushViewController:cartVC animated:YES];
    }
}

-(void)addGoodsIntoCartWithGesture:(UITapGestureRecognizer *)tap indexPath:(NSIndexPath *)indexPath
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width-130, (100*indexPath.row)-_tableView.contentOffset.y+120, 50, 50)];
//    imageView.center = tapPoint;
    imageView.image = kHolderImage;
    [self.view addSubview:imageView];
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, imageView.centerX, imageView.centerY);
    CGPathAddLineToPoint(path, NULL, 90, kScreen_height-49);
    pathAnimation.path = path;
    [imageView.layer addAnimation:pathAnimation forKey:@"position"];
    
    CABasicAnimation *basiAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    basiAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    basiAnimation.toValue = [NSNumber numberWithFloat:0.0];
    [imageView.layer addAnimation:basiAnimation forKey:@"transform.scale"];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setDuration:0.5];
    group.animations = @[pathAnimation, basiAnimation];
    [imageView.layer addAnimation:group forKey:@"group"];
    CGPathRelease(path);
    
    NSInteger cartCount = _badgeView.badgeText.integerValue;
    cartCount++;
    _badgeView.badgeText = [NSString stringWithFormat:@"%ld",(long)cartCount];
    
    [self performSelector:@selector(removeImageView:) withObject:imageView afterDelay:0.45];
    
    
}

-(void)removeImageView:(UIImageView *)imageView
{
    [imageView removeFromSuperview];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 105) {
        if (buttonIndex == 1) {
            NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
            NSString *telephone = [storeDic objectForKey:@"telephone"];
            
            [[YanMethodManager defaultManager] callPhoneActionWithNum:telephone viewController:self];
        }
        return;
    }
    if (buttonIndex == 1) {
        NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
        NSString *telNum = [storeDic objectForKey:@"telephone"];
        [[YanMethodManager defaultManager] callPhoneActionWithNum:telNum viewController:self];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == _subTableView) {
        return 44;
    }
//    if (_haveBuy) {
//        return 80.0;
//    }
    return 100.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _subTableView) {
        _showSubclass = !_showSubclass;
        [backGroundView removeFromSuperview];
        [_subTableView removeFromSuperview];
        backGroundView = nil;
        _subTableView = nil;
        _currentPage = 1;
        ListSubItem *item = _subItemsArr[indexPath.row];
        _sub_class_id = item.class_id;
        [YanMethodManager showIndicatorOnView:self.view];
        [self goodsListRequestDataHandleWithClassID:_sub_class_id];
    }
//    else {
//        [tableView deselectRowAtIndexPath:indexPath animated:NO];
//        
//        HomeGoodsItem *item = _goodsitemsArr[indexPath.row];
//        GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc] init];
//        detailVC.goods_id = item.goods_id;
//        [self.navigationController pushViewController:detailVC animated:YES];
//    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.tabBarController.tabBar.hidden = YES;
    if (!_isTejia) {
        [self.view makeToast:@"点击顶部箭头查看其他更多分类" duration:2.5 position:@"bottom"];
    }
    if (_badgeView) {
        NSString *badgeCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"local_cartGoodsCount"];
        if (badgeCount.integerValue > 0) {
            _badgeView.badgeText = badgeCount;
        } else {
            _badgeView.badgeText = @"";
        }
    }
   
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}



-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
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
