//
//  HaveBoughtViewController.m
//  OCommunity
//
//  Created by runkun3 on 15/5/30.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "HaveBoughtViewController.h"
#import "GoodsListTableViewCell.h"
#import "PayRightNowViewController.h"
#import "HomeGoodsItem.h"
#import "MyCommentViewController.h"
#import "MyColllectionTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "MJRefresh.h"
#import "CartViewController.h"
#define viewX 47
@interface HaveBoughtViewController ()<UIGestureRecognizerDelegate>
{
    UIView *topView;
    UIView *view;
    int _haveBoughtPage;
    int _noBoughtPage;
//    UIButton *button;
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *goodsitemsArr;
@property (nonatomic, strong) NSMutableArray *noBoughtArr;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) BOOL isLoadAll;
@property (nonatomic, assign) BOOL isLoadMore;
@property (nonatomic, assign) BOOL isDeleting;
@property (nonatomic, copy) NSString *boughtHaveMore;
@property (nonatomic, copy) NSString *noBoughtHaveMore;
@property(nonatomic,assign)BOOL marketIsLogin;

@end

@implementation HaveBoughtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _haveBuy = YES;
    _isLoadMore = NO;
    _isDeleting = NO;
    _haveBoughtPage = 1;
    _noBoughtPage = 1;
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"已购买商品"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(haveBoughtPop)];
    _goodsitemsArr = [[NSMutableArray alloc]init];
    _noBoughtArr = [[NSMutableArray alloc]init];
    [self createTopView];
    [self haveBoughtSubviews];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [self haveBoughtRequest];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)haveBoughtSubviews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+51, kScreen_width, kScreen_height-64-51) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    UIView *footView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 0.5)];
    [footView1 setBackgroundColor:[UIColor whiteColor]];
    _tableView.tableFooterView = footView1;
    [self.view addSubview:_tableView];
    UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cleanBtn setFrame:CGRectMake(0, 0, 20, 20)];
    [cleanBtn addTarget:self action:@selector(deleteCellData) forControlEvents:UIControlEventTouchUpInside];
    [cleanBtn setBackgroundImage:[UIImage imageNamed:@"del_garbage"] forState:UIControlStateNormal];
    UIBarButtonItem *deleItem = [[UIBarButtonItem alloc] initWithCustomView:cleanBtn];
    self.navigationItem.rightBarButtonItem = deleItem;
}

-(void)deleteCellData{
    if (_goodsitemsArr.count == 0 && _haveBuy) {
        [self.view makeToast:@"已支付订单为空" duration:1.0 position:@"center"];
    } else if (_noBoughtArr.count == 0 && !_haveBuy) {
        [self.view makeToast:@"未支付订单为空" duration:1.0 position:@"center"];
    } else {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"确定清空吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 102) {
        if (buttonIndex == 1) {
            NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
            NSString *telephone = [storeDic objectForKey:@"telephone"];
            
            [[YanMethodManager defaultManager] callPhoneActionWithNum:telephone viewController:self];
        }
        return;
    }
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    if (buttonIndex==1) {
        if (_haveBuy) {
            [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=delpayorder"] postData:[NSString stringWithFormat:@"member_id=%@",member_id]];
            request.successRequest = ^(NSDictionary *boughtDic){
                NSNumber *code = [boughtDic objectForKey:@"code"];
                if (code.integerValue == 200) {
                    NSDictionary *dataDic = [boughtDic objectForKey:@"data"];
                    NSNumber *delResult = [dataDic objectForKey:@"delResult"];
                    if (delResult.integerValue == 1) {
                        NSLog(@"全部删除已支付");
                        [_goodsitemsArr removeAllObjects];
                        [_tableView reloadData];
                        if (_goodsitemsArr.count == 0) {
                            [YanMethodManager emptyDataInView:_tableView title:@"暂无已支付订单"];
                        }
                    } else {
                        [self.view makeToast:@"删除失败" duration:1.0 position:@"center"];
                    }
                }
            };
            request.failureRequest = ^(NSError *error){
                [self.view makeToast:@"删除失败" duration:1.0 position:@"center"];
            };
            
            
        }else{
            [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=delnopayorder"] postData:[NSString stringWithFormat:@"member_id=%@",member_id]];
            request.successRequest = ^(NSDictionary *noBoughtDic){
                NSNumber *code = [noBoughtDic objectForKey:@"code"];
                if (code.integerValue == 200) {
                    NSDictionary *dataDic = [noBoughtDic objectForKey:@"data"];
                    NSNumber *delResult = [dataDic objectForKey:@"delResult"];
                    if (delResult.integerValue == 1) {
                        NSLog(@"全部删除未支付");
                        [_noBoughtArr removeAllObjects];
                        [_tableView reloadData];
                        if (_noBoughtArr.count == 0) {
                            [YanMethodManager emptyDataInView:_tableView title:@"暂无未支付订单"];
                        }
                    } else {
                        [self.view makeToast:@"删除失败" duration:1.0 position:@"center"];
                    }
                }

            };
            request.failureRequest = ^(NSError *error){
              [self.view makeToast:@"删除失败" duration:1.0 position:@"center"];
            };
        }
    }
}
-(void)haveBoughtPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTopView{
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, 51)];
    NSArray *top = @[@"已支付",@"未支付"];
    
    for (int i = 0; i<top.count; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_width/2 *i, 0, kScreen_width/2, 50)];
        
        if (i == 0) {
            button.selected = YES;
        }
        [button setTitle:top[i] forState:UIControlStateNormal];
        [button setTitle:top[i] forState:UIControlStateSelected];
        [button setTitleColor:kBlack_Color_2 forState:UIControlStateSelected];
        [button setTitleColor:kBlack_Color_3 forState:UIControlStateNormal];
        button.tag = 500 + i;
        [button addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:button];
        
    }
    view = [[UIView alloc] initWithFrame:CGRectMake(0, viewX, kScreen_width/2, 3)];
    [view setBackgroundColor:[UIColor redColor]];
    [topView addSubview:view];
    UIView *separeView1 = [[UIView alloc] initWithFrame:CGRectMake(0, view.bottom, kScreen_width, 1)];
    separeView1.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [topView addSubview:separeView1];
    UIView *separeView2 = [[UIView alloc] initWithFrame:CGRectMake(kScreen_width/2, 10, 1, 30)];
    separeView2.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [topView addSubview:separeView2];
    [self.view addSubview:topView];
    
}

-(void)topButtonAction:(UIButton *)btn{
    UIButton *btn1 =(UIButton *)[topView viewWithTag:500];
    UIButton *btn2 =(UIButton *)[topView viewWithTag:501];
   
    if (btn.tag == 500&&!btn.selected) {
        btn1.selected =YES;
        btn2.selected = NO;
        view.left = 0;
        
        _haveBuy =YES;
        [_tableView reloadData];
        if (_goodsitemsArr.count == 0) {
            [YanMethodManager emptyDataInView:_tableView title:@"暂无已支付订单"];
        } else {
            [YanMethodManager removeEmptyViewOnView:_tableView];
        }
    }
    
    if (btn.tag == 501&&!btn.selected) {
        btn1.selected =NO;
        btn2.selected = YES;
        view.frame = CGRectMake(kScreen_width/2, viewX, kScreen_width/2, 7);
        
        _haveBuy=NO;
        if (_noBoughtArr.count == 0) {
            [YanMethodManager showIndicatorOnView:_tableView];
            [self noBoughtGoodsRequest];
        } else {
            [YanMethodManager removeEmptyViewOnView:_tableView];
            
        }
    }
    [_tableView reloadData];
     [self bottomViewHandle];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (_isLoadMore == NO) {
        if (self.tableView.contentSize.height-_tableView.contentOffset.y <= _tableView.height){
            //加载...
            if (_haveBuy) {//已支付
                if ([_boughtHaveMore isEqualToString:@"true"]) {
                    _isLoadMore = YES;
                    ++_haveBoughtPage;
                    [self haveBoughtRequest];
                    _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, _tableView.contentOffset.y+30);
                }
                
            } else {//未支付
                if ([_noBoughtHaveMore isEqualToString:@"true"]) {
                    _isLoadMore = YES;
                    ++_noBoughtPage;
                    [self noBoughtGoodsRequest];
                    _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, _tableView.contentOffset.y+30);
                }
            }
        }
    }
}

#define kBottimView_height 40
-(void)bottomIndicator
{
    _tableView.tableFooterView = nil;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kBottimView_height)];
    [YanMethodManager lineViewWithFrame:CGRectMake(15, 0, kScreen_width, 0.5) superView:bottomView];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 15, 25)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    indicatorView.center = CGPointMake(bottomView.width/2, bottomView.height/2);
    [indicatorView startAnimating];
    [bottomView addSubview:indicatorView];
    _tableView.tableFooterView = bottomView;
}

-(void)bottomLoadData
{
    _tableView.tableFooterView = nil;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kBottimView_height)];
    [YanMethodManager lineViewWithFrame:CGRectMake(15, 0, kScreen_width, 0.5) superView:bottomView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, bottomView.width, 30)];
    label.text = @"暂无更多数据";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kDividColor;
    label.font = [UIFont systemFontOfSize:kFontSize_3];
    [bottomView addSubview:label];
    _tableView.tableFooterView = bottomView;
}

#pragma tableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_haveBuy) {
        return _goodsitemsArr.count;

    }else
        return _noBoughtArr.count;

}

#define kPageDefaultSize 15

-(void)haveBoughtRequest{
    
//    if (!_isRefresh) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.labelText = @"加载中...";
//    }
    [YanMethodManager removeEmptyViewOnView:_tableView];
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *memberID = [[NSUserDefaults standardUserDefaults]objectForKey:@"member_id"];
    NSString *para = [NSString stringWithFormat:@"member_id=%@&pagenumber=%d&pagesize=%d",memberID,_haveBoughtPage,kPageDefaultSize];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=memberbuygoods"] postData:para];
    request.successRequest = ^(NSDictionary *requestDic){
        NSLog(@"*********** have bought = %@",requestDic);
        if (_isRefresh) {
            [_goodsitemsArr removeAllObjects];
        }
        _isRefresh = NO;
        [_tableView.header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSNumber *code = [requestDic objectForKey:@"code"];
        int numCode = [code intValue];
        if (numCode==200) {
            //                _haveBoughtTotal = [haveCount intValue]/kPageDefaultSize+1;
            _boughtHaveMore = [requestDic objectForKey:@"haveMore"];
            NSArray *datasArr = [requestDic objectForKey:@"data"];
            if (datasArr.count == 0) {
                [YanMethodManager emptyDataInView:_tableView title:@"暂无已支付订单"];
            } else {
                for (int i = 0; i < datasArr.                                                                                                                                                                                  count; i++) {
                    NSDictionary *itemDic = datasArr[i];
                    HomeGoodsItem *item = [[HomeGoodsItem alloc] initWithDic:itemDic];
                    [_goodsitemsArr addObject:item];
                }
                [_tableView reloadData];
            }
        }
        _isLoadMore = NO;
        [self bottomViewHandle];
    };
    request.failureRequest = ^(NSError *error){
        [_tableView.header endRefreshing];
        _isLoadMore = NO;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        _isRefresh = NO;
        [_tableView.header endRefreshing];
    };
}
-(void)noBoughtGoodsRequest{
    
    [YanMethodManager removeEmptyViewOnView:_tableView];
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *memberID = [[NSUserDefaults standardUserDefaults]objectForKey:@"member_id"];
    NSString *para = [NSString stringWithFormat:@"member_id=%@&pagenumber=%d&pagesize=%d",memberID,_noBoughtPage,kPageDefaultSize];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=unpaygoods"] postData:para];
    request.successRequest = ^(NSDictionary *requestDic){
        NSLog(@"========== no bought dic = %@",requestDic);
        if (_isRefresh) {
            [_noBoughtArr removeAllObjects];
        }
        _isRefresh = NO;
        [_tableView.header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [YanMethodManager hideIndicatorFromView:_tableView];
        NSNumber *code = [requestDic objectForKey:@"code"];
        _footer_Refresh = NO;
        int numCode = [code intValue];//请求数据成功代码号
        if (numCode==200) {
            NSArray *datasArr = [requestDic objectForKey:@"data"];
            _noBoughtHaveMore = [requestDic objectForKey:@"haveMore"];
            if (datasArr.count == 0) {
                [YanMethodManager emptyDataInView:_tableView title:@"暂无未支付订单"];
            } else {
                for (int i = 0; i < datasArr.count; i++) {
                    NSDictionary *itemDic = datasArr[i];
                    HomeGoodsItem *item = [[HomeGoodsItem alloc] initWithDic:itemDic];
                    [_noBoughtArr addObject:item];
                }
                [_tableView reloadData];
            }
            [self bottomViewHandle];
        }
        _isLoadMore = NO;

        
    };
    
    request.failureRequest = ^(NSError *error){
        _isLoadMore = NO;
    };
}

-(void)bottomViewHandle
{
    if (_haveBuy) {
        if (_goodsitemsArr.count > 0) {
            if ([_boughtHaveMore isEqualToString:@"true"]) {
                [self bottomIndicator];
            } else {
                [self bottomLoadData];
            }
        }
    } else {
        if (_noBoughtArr.count > 0) {
            if ([_noBoughtHaveMore isEqualToString:@"true"]) {
                [self bottomIndicator];
                
            } else {
                [self bottomLoadData];
            }
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_haveBuy) {
        static NSString *haveBuy = @"bought";
        HomeGoodsItem *model = [_goodsitemsArr objectAtIndex:indexPath.row];
        MyColllectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:haveBuy];
        if (!cell) {
            cell = [[MyColllectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:haveBuy];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
           }
         cell.homegoodsitem = model;
        if (model.item_id<7||model.class_id!=18) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

        __weak HaveBoughtViewController *weakSelf = self;
        cell.cartBlock = ^(UIButton *button1){
            if (button1.tag == 310) {
//                if (model.item_id<7) {
//                    [weakSelf payCharacteristicsGoods:model];
//                }else{
//                    if (!_marketIsLogin) {
//                        _marketIsLogin = YES;
//                        [weakSelf systemIsOpenHandleWithModel:model];
//                        
//                    }
//
//                }
                if (model.item_id > 6) {
                    [self addGoodsToCar:model];
                } else {
                    [self.view makeToast:@"特色商品不能加入购物车" duration:1.0 position:@"center"];
                }
                
                } else {
                MyCommentViewController *commentVC = [[MyCommentViewController alloc] init];
                commentVC.dataModel = model;
                commentVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:commentVC animated:YES];
                
            }
        };
        return cell;
        
    }
    static NSString *listID = @"listCell";
    __weak HaveBoughtViewController *weakSelf = self;
    GoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listID];
    if (!cell) {
        cell = [[GoodsListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listID witnAddgoodsToCar:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_haveBuy) {
            cell.hasPurchased = YES;
        } else {
            cell.hasPurchased = NO;
        }
    }
    cell.isList = YES;
    //cell.markStr = @"满减";
    HomeGoodsItem *item = _noBoughtArr[indexPath.row];
    //选择商品数量
    cell.goodsItem = item;
    cell.selectCountBlock = ^(UIButton *button){
        [weakSelf noboughtselectCountInCellWithIndexPath:indexPath button:button];
    };
    
    cell.addCartBlock = ^(UITapGestureRecognizer *tap){
        if (item.item_id > 6) {
            [weakSelf noboughtaddGoodsToCart:item withTap:tap withIndexPath:indexPath];
        } else {
            [self.view makeToast:@"特色商品不能加入购物车" duration:1.0 position:@"center"];
        }
    };
    
    return cell;
}

-(void)noboughtaddGoodsToCart:(HomeGoodsItem *)model withTap:(UITapGestureRecognizer *)tap withIndexPath:(NSIndexPath *)indexPath{
    
    GoodsListTableViewCell *cell = (GoodsListTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addshopcar"] postData:[NSString stringWithFormat:@"goods_id=%d&quantity=%@&member_id=%@",model.item_id,cell.selectCountV.countLabel.text,member_id]];
    __weak HaveBoughtViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *cartDic){
        [YanMethodManager hideIndicatorFromView:weakSelf.view];
        NSNumber *code = [cartDic objectForKey:@"code"];
        int loginCode = [code intValue];//请求数据成功代码号
        if (loginCode == 200) {
            [weakSelf.view makeToast:@"已加入购物车,请前往购物车结算" duration:1.0 position:@"center"];
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

-(void)noboughtselectCountInCellWithIndexPath:(NSIndexPath *)indexPath button:(UIButton *)button
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

-(void)addGoodsToCar:(HomeGoodsItem *)model{
    
        NetWorkRequest *request = [[NetWorkRequest alloc]init];
            //            NSString *mobile = [NSUserDefaults ]
        NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
        NSString *para = [NSString stringWithFormat:@"goods_id=%d&quantity=%d&member_id=%@",model.item_id,1,member_id];
        [YanMethodManager showIndicatorOnView:self.view];
            [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addshopcar"] postData:para];
        __weak HaveBoughtViewController *weakSelf = self;
            request.successRequest = ^(NSDictionary *dataDic)
            {

                [YanMethodManager hideIndicatorFromView:weakSelf.view];
                NSLog(@"dajdagdjhajdgjaj%@",dataDic);
                NSNumber *codeNum = [dataDic objectForKey:@"code"];
                int code = [codeNum intValue];
                if (code == 200) {
                    NSNumber *count = [dataDic objectForKey:@"count"];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)count.integerValue] forKey:@"local_cartGoodsCount"];
                    for (UINavigationController *navi in self.tabBarController.viewControllers) {
                        if ([navi.topViewController isKindOfClass:[CartViewController class]]) {
                            navi.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)count.integerValue];
                        }
                    }
                    [weakSelf.view makeToast:@"加入购物车成功，请进入购物车结算" duration:1 position:@"center"];

                    
                }else if(code == 203){
                    
                    [weakSelf.view makeToast:@"购物车已满，请删除部分商品后重新加入" duration:1 position:@"center"];
                    
                }else
                {
                    [weakSelf.view makeToast:@"加入购物车失败" duration:1 position:@"center"];
                }
            };
            request.failureRequest = ^(NSError *error){
                [YanMethodManager hideIndicatorFromView:weakSelf.view];
                [weakSelf.view makeToast:@"加入购物车失败" duration:.8 position:@"center"];
            };
        }
//特色专卖店购买
-(void)payCharacteristicsGoods:(HomeGoodsItem *)model{
    
    PayRightNowViewController *payVC = [[PayRightNowViewController alloc] init];
    payVC.goods_name = model.item_name;
    payVC.goods_id = model.item_id;
    payVC.price = [NSString stringWithFormat:@"%.1f", model.price];
    payVC.isHotGoods = YES;
    payVC.count = @"1";
    payVC.market_name = @"特色专卖店";
    payVC.store_id = model.store_id;
    [self.navigationController pushViewController:payVC animated:YES];

}
#pragma mark 判断超市系统状态
//立即购买前先判断超市系统状态
-(void)systemIsOpenHandleWithModel:(HomeGoodsItem *)model
{
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [YanMethodManager showIndicatorOnView:self.view];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=isopenstore"] postData:[NSString stringWithFormat:@"store_id=%d",model.store_id]];
    __weak HaveBoughtViewController *weakSelf = self;
    request.successRequest = ^(NSDictionary *packageDic){
        _marketIsLogin = NO;
        [YanMethodManager hideIndicatorFromView:weakSelf.view];
        NSLog(@"===== package dic = %@",packageDic);
        NSNumber *code = [packageDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSNumber *isOpen = [packageDic objectForKey:@"isopen"];
            if (isOpen.integerValue == 1) {
                PayRightNowViewController *payVC = [[PayRightNowViewController alloc] init];
                
                payVC.goods_name = model.item_name;
                payVC.goods_id = model.item_id;
                payVC.price = [NSString stringWithFormat:@"%.1f", model.price];
                if (model.item_id == 1 || model.item_id == 2 || model.item_id == 3 || model.item_id == 4|| model.item_id == 5 || model.item_id == 6) {
                    payVC.isHotGoods = YES;
                    payVC.count = @"1";
                    payVC.market_name = @"特色专卖店";
                }else {
                    payVC.count = @"1";
                    payVC.market_name = model.store_name;
                }
                payVC.store_id = model.store_id;
                [self.navigationController pushViewController:payVC animated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲!店家已打烊,若有急需请电联" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"打电话", nil];
                alert.tag = 102;
                [alert show];
            }
        }
    };
    request.failureRequest = ^(NSError *error){
    
        _marketIsLogin = NO;
        [YanMethodManager hideIndicatorFromView:weakSelf.view];
    };
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_haveBuy) {
        return 80.0;
    }
    return 100.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_haveBuy) {
        HomeGoodsItem *item = _goodsitemsArr[indexPath.row];
        if (item.item_id>6&&item.class_id==18) {
            GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc] init];
            detailVC.goods_id = item.item_id;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除地址
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (!_isDeleting) {
            _isDeleting = YES;
            NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
            NetWorkRequest *request = [[NetWorkRequest alloc]init];
            
            if (!_haveBuy) {//未支付
                HomeGoodsItem *item = _noBoughtArr[indexPath.row];
                NSString *noParam = [NSString stringWithFormat:@"order_id=%d&member_id=%@",item.order_id,member_id];
                [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=delnopayorder"] postData:noParam];
                request.successRequest = ^(NSDictionary *noBoughtDic){
                   
                    NSNumber *code = [noBoughtDic objectForKey:@"code"];
                    if (code.integerValue == 200) {
                        NSDictionary *dataDic = [noBoughtDic objectForKey:@"data"];
                        NSNumber *delResult = [dataDic objectForKey:@"delResult"];
                        if (delResult.integerValue == 1) {
                             _isDeleting = NO;
                            [_noBoughtArr removeObjectAtIndex:indexPath.row];
                            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            if (_noBoughtArr.count == 0) {
                                [YanMethodManager emptyDataInView:_tableView title:@"暂无未支付订单"];
                            }
                            NSLog(@"未支付删除");
                        } else {
                            [self.view makeToast:@"删除失败" duration:1.0 position:@"center"];
                        }
                    }
                };
                request.failureRequest = ^(NSError *error){
                    _isDeleting = NO;
                };
                
                
            }else {//已支付
                HomeGoodsItem *item = _goodsitemsArr[indexPath.row];
                NSString *param = [NSString stringWithFormat:@"order_id=%d&member_id=%@",item.order_id,member_id];
                [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=delpayorder"] postData:param];
                request.successRequest = ^(NSDictionary *boughtDic){
                    NSLog(@"========== have bought = %@ \n param = %@",boughtDic,param);
                    NSNumber *code = [boughtDic objectForKey:@"code"];
                    if (code.integerValue == 200) {
                        NSDictionary *dataDic = [boughtDic objectForKey:@"data"];
                        NSNumber *delResult = [dataDic objectForKey:@"delResult"];
                        if (delResult.integerValue == 1) {
                            _isDeleting = NO;
                            [_goodsitemsArr removeObjectAtIndex:indexPath.row];
                            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            if (_goodsitemsArr.count == 0) {
                                [YanMethodManager emptyDataInView:_tableView title:@"暂无已支付订单"];
                            }
                            NSLog(@"已支付删除");
                        } else {
                            [self.view makeToast:@"删除失败" duration:1.0 position:@"center"];
                        }
                    }
                };
                request.failureRequest = ^(NSError *error){
                    _isDeleting = NO;
                };
            }
        }
        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return @"删除";
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.tabBarController.tabBar.hidden = YES;
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
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
