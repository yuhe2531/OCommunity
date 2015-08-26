//
//  SearchResultViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/24.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "SearchResultViewController.h"
#import "GoodsListTableViewCell.h"
#import "goodsClassify.h"
#import "SuperMarketListTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "PayRightNowViewController.h"
#import "Market.h"
#import "CommunityTabBarViewController.h"
#import "CartViewController.h"
#import "LoginViewController.h"
#import "JSBadgeView.h"
#define footHeight 35
#define kBottomView_height 40
#define kPageSize 10
@interface SearchResultViewController ()<UIGestureRecognizerDelegate>

{
    CGSize screenSize;
    UITextField *searchTF;
    NSMutableArray *searchGoodsArray;
    NSString *placeholderString;
    UITableView *_tabelViewHistory;
    NSMutableArray *historyArray;
    UIView *historyView;
    UIView *footView;
    int _currentPage;
    int _totalPage;
    UIView *_bottomView;
    UIView *footView1;
    JSBadgeView *_badgeView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isLoading;
@property(nonatomic,assign)BOOL marketIsLogin;


@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    screenSize = [[UIScreen mainScreen] bounds].size;
    _currentPage = 1;
    searchGoodsArray = [[NSMutableArray alloc] init];

    [self createSubTableView];

    [self searchResultNaviBarHandle];
    // Do any additional setup after loading the view.
}

-(void)createSubTableView
{
    if (!_searchStore_Push) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height-64-49) style:UITableViewStylePlain];
    }else{
    
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height-64) style:UITableViewStylePlain];

    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag= 750;
    footView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 0.5)];
    [footView1 setBackgroundColor:[UIColor whiteColor]];
    _tableView.tableFooterView = footView1;
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kBottomView_height)];
    if (!_searchStore_Push) {
        
        _tableView.tableFooterView = _bottomView;
    }
    [self.view addSubview:_tableView];
    //添加地步购物车实时显示购物车中的商品数量
    if (!_searchStore_Push) {
        UIView *bottomCartView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_height -49, kScreen_width, 49)];
        bottomCartView.backgroundColor = kColorWithRGB(57, 56, 62);
        [self.view addSubview:bottomCartView];
        UIView *tempCartView = [[UIView alloc] initWithFrame:CGRectMake(35, bottomCartView.top-5, 50, 50)];
        [self.view addSubview:tempCartView];
        
        UIButton *cartBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cartBtn.frame = tempCartView.bounds;
        [cartBtn setBackgroundImage:[UIImage imageNamed:@"minecart"] forState:UIControlStateNormal];
        cartBtn.layer.cornerRadius = 25;
        cartBtn.clipsToBounds = YES;
        [cartBtn addTarget:self action:@selector(titleBtnsAction:) forControlEvents:UIControlEventTouchUpInside];
        [tempCartView addSubview:cartBtn];
        _badgeView = [[JSBadgeView alloc] initWithParentView:tempCartView alignment:JSBadgeViewAlignmentTopRight];
        NSString *badgeCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"local_cartGoodsCount"];
        if (badgeCount.integerValue > 0) {
            _badgeView.badgeText = badgeCount;
        }

    }
   
}

#define kSearchTF_height 30

-(void)searchResultNaviBarHandle
{
    self.navigationController.navigationBar.barTintColor = kRedColor;
    
    // 返回上一级
    UIButton *backBarBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBarBtn.frame = CGRectMake(0, 0, 15, 20);
    [backBarBtn setBackgroundImage:[UIImage imageNamed:@"popArrow"] forState:UIControlStateNormal];
    [backBarBtn addTarget:self action:@selector(PreviousLastVC) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarBtn];
    
    //搜索按钮
    UIButton *searBarBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    searBarBtn.frame = CGRectMake(0, 0, 40, kSearchTF_height);
//    searBarBtn.backgroundColor = [UIColor orangeColor];
    [searBarBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searBarBtn.layer.cornerRadius = 3;
    searBarBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [searBarBtn addTarget:self action:@selector(searchResult) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searBarBtn];
    
    //搜索框
    searchTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, screenSize.width-backBarBtn.width-searBarBtn.width-60, kSearchTF_height)];
    searchTF.backgroundColor = kColorWithRGB(46, 156, 96);
    searchTF.delegate = self;
//    [searchTF becomeFirstResponder];
    placeholderString = _searchStore_Push ? @"请输入超市关键字" : @"请输入商品关键字";
    searchTF.placeholder = placeholderString;
    searchTF.textColor = kBlack_Color_2;
    searchTF.font = [UIFont systemFontOfSize:15];
//    searchTF.borderStyle = UITextBorderStyleRoundedRect;
    searchTF.layer.cornerRadius = 5;
//    [searchTF becomeFirstResponder];
    searchTF.returnKeyType = UIReturnKeySearch;
    self.navigationItem.titleView = searchTF;
    historyView =[[UIView alloc] initWithFrame:CGRectMake(50, 64, searchTF.width, 155)];
//    historyView.layer.borderColor = kDividColor.CGColor;
//    historyView.layer.borderWidth = 1;
//    historyView.layer.cornerRadius = 5;
    historyView.layer.shadowColor = kColorWithRGB(179, 178, 178).CGColor;
    historyView.layer.shadowOpacity = 1;
    historyView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    
    _tabelViewHistory = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, searchTF.width+5, (kScreen_height-64)/2) style:UITableViewStylePlain];
    _tabelViewHistory.delegate = self;
    _tabelViewHistory.dataSource = self;
//    _tabelViewHistory.layer.borderColor = kDividColor.CGColor;
//    _tabelViewHistory.layer.borderWidth = 1;
//    _tabelViewHistory.layer.cornerRadius = 5;

    _tabelViewHistory.tag = 751;
///    _tabelViewHistory.tableFooterView = footView1;
//    UIView *footView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _tabelViewHistory.bottom, kScreen_width-50, 0.5)];
//    [footView2 setBackgroundColor:kDividColor];
//    [historyView addSubview:footView2];
       footView = [[UIView alloc] initWithFrame:CGRectMake(0, _tabelViewHistory.bottom, _tabelViewHistory.width, footHeight)];
      UIView *seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tabelViewHistory.width, 0.5)];
    [seperateView setBackgroundColor:kDividColor];
    
    [footView addSubview:seperateView];
    UIView *footSubView = [[UIView alloc] initWithFrame:CGRectMake((footView.width-150)/2, 0, 150, footHeight)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 7.5, 20, 20)];
    imageView.image = [UIImage imageNamed:@"history"];
    [footSubView addSubview:imageView];
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(imageView.left+10, 0, 120, footHeight);
//    clearButton.layer.cornerRadius = 5;
    clearButton.titleLabel.font =[UIFont systemFontOfSize:14];
    [clearButton setTitle:@"清除历史记录" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
    [footSubView addSubview:clearButton];
    [footSubView addSubview:imageView];
    [footView setBackgroundColor:kColorWithRGB(245, 242, 242)];
    [footView addSubview:footSubView];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(footView.width - 200, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
    historyView.hidden = YES;

    historyView.backgroundColor = [UIColor whiteColor];
//    _tabelViewHistory.tableFooterView = footView;
    [historyView addSubview:_tabelViewHistory];
    [historyView addSubview:footView];
    [self.view addSubview:historyView];
    [searchTF becomeFirstResponder];

    
}
-(void)titleBtnsAction:(UIButton *)button{
    __weak SearchResultViewController *weakSelf = self;
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
////没有登录先登录//(void(^)(NSMutableArray *items))successHandle
//-(void)isLoginHandle:(void(^)(void))loginSuccess hasLogin:(void(^)(void))hasLoginHandle
//{
//    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
//    if (member_id == NULL) {
//        LoginViewController *loginVC = [[LoginViewController alloc] init];
//        loginVC.isPresent = YES;
//        loginVC.loginSuccessBlock = ^{
//            loginSuccess();
//        };
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//        [self.tabBarController presentViewController:nav animated:YES completion:nil];
//    } else {
//        hasLoginHandle();
//    }
//}

-(void)clearHistory{
    if (!_searchStore_Push) {

    NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"searchHistory"]];
    [array removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"searchHistory"];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"searchHistory"];
    }else{
    
        NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"searchStoreHistory"]];
        [array removeAllObjects];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"searchStoreHistory"];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"searchStoreHistory"];
    
    
    }
    historyView.hidden = YES;

}
-(void)turnDown{

    historyView.hidden = YES;

}
-(void)loadHistoryData{
    if (!_searchStore_Push) {
    historyArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"searchHistory"]];

    }else{
    historyArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"searchStoreHistory"]];
    }
    _tabelViewHistory.height = historyArray.count * 31;

    historyView.height = _tabelViewHistory.height + footHeight;

    if (historyView.height>(kScreen_height -64)/3.f) {
        historyView.height = (kScreen_height -64)/3.f;
        //
        _tabelViewHistory.height = (kScreen_height -64)/3.f - footHeight;
        
    }
    footView.top = _tabelViewHistory.bottom-2;
    historyView.height = historyView.height-2;

    [_tabelViewHistory reloadData];
}
-(void)addData{
        [searchTF resignFirstResponder];
    if (!_searchStore_Push) {
        if (searchTF.text.length !=0) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"searchHistory"]];
            if (array.count==0) {
                [array addObject:searchTF.text];
            }else{
                for (int i=0; i<array.count; i++) {
                    
                    if ([searchTF.text isEqualToString:[array objectAtIndex:i]]) {
                        [array removeObjectAtIndex:i];
                        [array insertObject:searchTF.text atIndex:0];
                        break;
                    }
                    if (i==array.count-1) {
                        [array addObject:searchTF.text];
                        
                    }
                }
                
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"searchHistory"];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"searchHistory"];
        }
        
    }else{
        if (searchTF.text.length !=0) {

        NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"searchStoreHistory"]];
        if (array.count==0) {
            [array addObject:searchTF.text];
        }
        else
        {
            for (int i=0; i<array.count; i++) {
                
                if ([searchTF.text isEqualToString:[array objectAtIndex:i]]) {
                    [array removeObjectAtIndex:i];
                    [array insertObject:searchTF.text atIndex:0];
                    break;
                }
                if (i==array.count-1) {
                    [array addObject:searchTF.text];
                    
                }
            }
            
        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"searchStoreHistory"];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"searchStoreHistory"];
        }
    
    }
    _tableView.tableFooterView = footView1;

    _searchStore_Again = YES;
    _currentPage = 1;
    _tableView.contentOffset = CGPointZero;


}
-(void)searchResult{
    if (_searchStore_Push&&searchTF.text.length==0) {
        
    }else{
    [self addData];
    [self searchResultAction];
    historyView.hidden = YES;

    }

}
-(void)searchResultAction
{
    NSDictionary *storeID_Dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [storeID_Dic objectForKey:@"store_id"];
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    if (!_isLoading) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    }
    if (!_searchStore_Push) {
        NSString *para = [NSString stringWithFormat:@"keyword=%@&pagenumber=%d&pagesize=%d&store_id=%@",searchTF.text,_currentPage,kPageSize,store_id];

        [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=searchgoods"] postData:para];
    }else{
        NSString *para = [NSString stringWithFormat:@"keyword=%@",searchTF.text];

        [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=storelist"] postData:para];
    }
        request.successRequest = ^(NSDictionary *dataDic)
    {
//        NSLog(@"=============== data dic = %@",dataDic);
        NSNumber *codeNum = [dataDic objectForKey:@"code"];
        if (codeNum.intValue == 200) {
            if (_searchStore_Again) {
                if (searchGoodsArray.count>0) {
                [searchGoodsArray removeAllObjects];

                }
            }
            NSNumber *totalCount = [dataDic objectForKey:@"count"];

            int remainder = totalCount.intValue % kPageSize;
            if (remainder > 0) {
                _totalPage = totalCount.intValue/kPageSize + 1;
            } else {
                _totalPage = totalCount.intValue/kPageSize;
            }

            for (NSDictionary *dic in [dataDic objectForKey:@"datas"]) {
                if (!_searchStore_Push) {
                    goodsClassify *dataModel = [[goodsClassify alloc] initWithDic:dic];
                    [searchGoodsArray addObject:dataModel];

                }else{
                
                    Market *marketModel = [[Market alloc] initWithDic:dic];
                    [searchGoodsArray addObject:marketModel];

                }
                
                
            }
            [_tableView reloadData];
            if (searchGoodsArray.count ==0) {
                if (!_searchStore_Push) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.view makeToast:@"找不到您所需要的商品" duration:1 position:@"center"];
                        _tableView.tableFooterView = footView1;

                    });
                }else{
        
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.view makeToast:@"找不到您所需要的超市" duration:1 position:@"center"];
                        _tableView.tableFooterView = footView1;


                    });
                }
            }else{
                if (!_searchStore_Push) {
                    
                    NSString *haveMore = [dataDic objectForKey:@"haveMore"];
                    if ([haveMore isEqualToString:@"true"]&&!_searchStore_Push) {
                        [self loadMoreHandleInView:_bottomView];
                    } else if([haveMore isEqualToString:@"false"]&&!_searchStore_Push) {
                        
                        [self loadMoreHasDoneHandleInView:_bottomView];
                    }
                    

                }
                
            
            }
            if (_isLoading&&!_searchStore_Push) {
                
                _tableView.contentOffset = CGPointMake(0, _tableView.contentOffset.y+40);

            }
            _isLoading = NO;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];


}
            //
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        
        
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
    _searchStore_Again = NO;
    if (!_searchStore_Push&&scrollView.tag==750) {
        if (self.tableView.contentSize.height-_tableView.contentOffset.y <= _tableView.height){
            if (_currentPage < _totalPage) {
                if (!_isLoading) {
                    _isLoading = YES;
                    ++_currentPage;
                    [self searchResultAction];
                }
            }
        }

    }
    }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag ==750) {
        if (!_searchStore_Push) {
            return 100.0;
        }else{
            
            return 70;
        }

    }else{
    
        return 31;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==750) {
        return searchGoodsArray.count;
    }else{
            return historyArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==750) {
        if (!_searchStore_Push) {
            
            static NSString *search = @"goodsSearch";
            GoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:search];
            if (!cell) {
                cell = [[GoodsListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:search];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.isList = YES;
            NSDictionary *marketDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
            NSString *store_id = [marketDic objectForKey:@"store_id"];
            NSLog(@"============= home store id = %@",store_id);

            goodsClassify *model = [searchGoodsArray objectAtIndex:indexPath.row];
            cell.searchModel = model;
            __weak SearchResultViewController *weakSelf = self;
            
            //选择商品数量
            cell.selectCountBlock = ^(UIButton *button){
                [weakSelf searchselectCountInCellWithIndexPath:indexPath button:button];
            };
            
            cell.addCartBlock = ^(UITapGestureRecognizer *tap){
                [YanMethodManager showIndicatorOnView:weakSelf.view];
                NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
                if (member_id !=NULL) {
                    [weakSelf addGoodsToCart:model tap:tap indexpath:indexPath];

                }else{
                
                    LoginViewController *loginVC = [[LoginViewController alloc] init];
                    loginVC.isPresent = YES;
                    loginVC.dismissBlock = ^{
                        [YanMethodManager hideIndicatorFromView:weakSelf.view];
                    };
                    loginVC.loginSuccessBlock = ^{
                        [weakSelf addGoodsToCart:model tap:tap indexpath:indexPath];
                    };
                    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
                    [self.tabBarController presentViewController:navi animated:NO completion:nil];
                }
        
            };
            return cell;
            
        }else{
            static NSString *search = @"storeSearch";
            SuperMarketListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:search];
            if (!cell) {
                cell = [[SuperMarketListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:search];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            Market *model = [searchGoodsArray objectAtIndex:indexPath.row];
            cell.marketModel = model;
            return cell;
        }

    }else if(tableView.tag ==751){
    
        static NSString *searchHistory = @"history";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchHistory];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchHistory];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor= [UIColor grayColor];
        }
        cell.textLabel.text = historyArray[indexPath.row];

        return cell;
    
    }
       return nil;
}

-(void)searchselectCountInCellWithIndexPath:(NSIndexPath *)indexPath button:(UIButton *)button
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



-(void)addGoodsToCart:(goodsClassify *)model tap:(UITapGestureRecognizer *)tap indexpath:(NSIndexPath *)indexpath
{

    UITableView *goodsTableView = (UITableView *)[self.view viewWithTag:750];
    GoodsListTableViewCell *cell = (GoodsListTableViewCell *)[goodsTableView cellForRowAtIndexPath:indexpath];
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addshopcar"] postData:[NSString stringWithFormat:@"goods_id=%d&quantity=%@&member_id=%@",model.goods_id,cell.selectCountV.countLabel.text,member_id]];
    __weak SearchResultViewController *weakSelf = self;
    [self addGoodsIntoCartWithGesture:tap];
    request.successRequest = ^(NSDictionary *cartDic){
        [YanMethodManager hideIndicatorFromView:self.view];
        NSNumber *code = [cartDic objectForKey:@"code"];
        int loginCode = [code intValue];//请求数据成功代码号
        if (loginCode == 200) {

            dispatch_async(dispatch_get_main_queue(), ^{
                NSNumber *count = [cartDic objectForKey:@"count"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)count.integerValue] forKey:@"local_cartGoodsCount"];
                _badgeView.badgeText = [NSString stringWithFormat:@"%ld",count.integerValue];
                for (UINavigationController *navi in self.tabBarController.viewControllers) {
                    if ([navi.topViewController isKindOfClass:[CartViewController class]]) {
                        navi.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)count.integerValue];
                    }
                }
            });
//
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
-(void)addGoodsIntoCartWithGesture:(UITapGestureRecognizer *)tap
{
   CGPoint _tapPoint = [tap locationInView:self.view];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_tapPoint.x, _tapPoint.y, 50, 50)];
    imageView.image = kHolderImage;
    [self.view addSubview:imageView];
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, _tapPoint.x, _tapPoint.y);
    CGPathAddLineToPoint(path, NULL, 35, kScreen_height-50);
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
    [self performSelector:@selector(removeImageView:) withObject:imageView afterDelay:0.45];
}
-(void)removeImageView:(UIImageView *)imageView
{
    [imageView removeFromSuperview];
}
//立即购买前先判断超市系统状态
-(void)systemIsOpenHandleWithModel:(goodsClassify *)model
{
    NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [storeDic objectForKey:@"store_id"];
    [YanMethodManager showIndicatorOnView:self.view];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=isopenstore"] postData:[NSString stringWithFormat:@"store_id=%@",store_id]];
    request.successRequest = ^(NSDictionary *packageDic){
        NSLog(@"===== package dic = %@",packageDic);
        _marketIsLogin = NO;
        [YanMethodManager hideIndicatorFromView:self.view];
        NSNumber *code = [packageDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSNumber *isOpen = [packageDic objectForKey:@"isopen"];
            if (isOpen.integerValue == 1) {
                __weak SearchResultViewController *weakSelf = self;
                [self isLoginHandle:^{
                    [weakSelf payRightNow:model];
                } hasLogin:^{
                    [weakSelf payRightNow:model];

                }];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲!店家已打烊,若有急需请电联" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"打电话", nil];
                alert.tag = 102;
                [alert show];
            }
        }
    };
    request.failureRequest = ^(NSError *error){
        _marketIsLogin = NO;
        [YanMethodManager hideIndicatorFromView:self.view];
    };
}
-(void)payRightNow:(goodsClassify *)model{

    NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *marketName = [storeDic objectForKey:@"store_name"];
    PayRightNowViewController *payVC = [[PayRightNowViewController alloc] init];
    payVC.market_name = marketName;
    payVC.goods_name = model.goods_name;
    payVC.goods_id = model.goods_id;
    payVC.price = [NSString stringWithFormat:@"%.1f", model.goods_price];
    payVC.count = @"1";
    payVC.store_id = model.store_id;
    [self.navigationController pushViewController:payVC animated:YES];


}
-(void)isLoginHandle:(void(^)(void))loginSuccess hasLogin:(void(^)(void))hasLoginHandle
{
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    __weak SearchResultViewController *weakSelf = self;
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        if (buttonIndex == 1) {
            NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
            NSString *telephone = [storeDic objectForKey:@"telephone"];
            
            [[YanMethodManager defaultManager] callPhoneActionWithNum:telephone viewController:self];
        }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView.tag==750) {
       
        if (!_searchStore_Push) {
            
//            NSDictionary *marketDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
//            NSString *store_id = [marketDic objectForKey:@"store_id"];
//            NSLog(@"============= home store id = %@",store_id);
//            NSString *store_Classid = [marketDic objectForKey:@"class_id"];
//            if (store_Classid.integerValue == 18) {
//                goodsClassify *model = [searchGoodsArray objectAtIndex:indexPath.row];
//                GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc] init];
//                detailVC.goods_id = model.goods_id;
//                
//                [self.navigationController pushViewController:detailVC animated:YES];
//            }
            
        }else{
            Market *marketItem = searchGoodsArray[indexPath.row];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMarket_name];
            [[NSUserDefaults standardUserDefaults] setObject:marketItem.store_name forKey:kMarket_name];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            CommunityTabBarViewController *bossTBV = mainStoryboard.instantiateInitialViewController;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"market_item_local"];
            
            
            NSDictionary *itemDic = @{@"store_id":marketItem.store_id,@"store_name":marketItem.store_name,@"alisa":marketItem.alisa,@"pic":marketItem.pic,@"address":marketItem.address,@"lat":marketItem.lat,@"lon":marketItem.lon,@"dis":marketItem.dis,@"telephone":marketItem.telephone,@"daliver_description":marketItem.daliver_description,@"jfdk":[NSString stringWithFormat:@"%d",marketItem.jfdk],@"fare":marketItem.fare,@"class_id":[NSString stringWithFormat:@"%d",marketItem.class_id]};
            [[NSUserDefaults standardUserDefaults] setObject:itemDic forKey:@"market_item_local"];
            [self presentViewController:bossTBV animated:YES completion:nil];
        }
    }else{
    
        searchTF.text = historyArray[indexPath.row];
        historyView.hidden = YES;

        [self addData];

        [self searchResultAction];
    
    }
    
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    if (scrollView.tag ==750) {
        
        [searchTF resignFirstResponder];
        historyView.hidden = YES;
    }

}
#pragma mark UITextFildDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
        if (_searchStore_Push&&searchTF.text.length==0) {
        
    }else{
        [self addData];
        [self searchResultAction];
        [textField resignFirstResponder];
        historyView.hidden = YES;

    }
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(searchGoodsArray.count==0){
    [searchTF becomeFirstResponder];
    }
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    if (_badgeView) {
        NSString *badgeCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"local_cartGoodsCount"];
        if (badgeCount.integerValue > 0) {
            _badgeView.badgeText = badgeCount;
        } else {
            _badgeView.badgeText = @"";
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [searchTF resignFirstResponder];

    self.navigationController.navigationBarHidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

-(void)PreviousLastVC
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    [self loadHistoryData];
    if (historyArray.count !=0) {
        historyView.hidden = NO;

    }else{
        historyView.hidden = YES;
    }
    return YES;
}

@end
