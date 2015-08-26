//
//  MyCollectionViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/4.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyColllectionTableViewCell.h"
#import "PayRightNowViewController.h"
#import "GoodsDetailViewController.h"
#import "GoodsListTableViewCell.h"
#import "SuperMarketListTableViewCell.h"
#import "MyCollectTableViewCell.h"
#import "Market.h"
#import "CommunityTabBarViewController.h"
#import "CartViewController.h"
#define viewX 47

@interface MyCollectionViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isGoodsCollectionDelete;
@property (nonatomic, assign) BOOL isMarketsCollectionDelete;
@property(nonatomic,assign)BOOL marketIsLogin;


@end

@implementation MyCollectionViewController{
    
    UIView *topView;
    UIScrollView *_scrollView;
    UIView *view;
    NSMutableArray *collectionDataArray;
    NSMutableArray *marketsCollectionArry;
}

static  CGFloat currentOffset = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"我的收藏"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(myCollectionPop)];
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(0, 0, 20, 20);
    [clearButton setBackgroundImage:[UIImage imageNamed:@"del_garbage"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    self.navigationItem.rightBarButtonItem = clearItem;
   // [self createTopView];
    [self createBottomView];
    //请求商品收藏
    [self loadGoodsCollectionData];
    //请求超市收藏
  //  [self loadMarksCollectionData];
        // Do any additional setup after loading the view.
}

-(void)clearAction{
    
        if (collectionDataArray.count == 0 && _scrollView.contentOffset.x==0) {
            [self.view makeToast:@"商品收藏为空" duration:.5 position:@"center"];
        } else if (marketsCollectionArry.count == 0 && _scrollView.contentOffset.x== kScreen_width) {
            [self.view makeToast:@"商户收藏为空" duration:.5 position:@"center"];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否全部删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }

    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 103) {
        if (buttonIndex == 1) {
            NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
            NSString *telephone = [storeDic objectForKey:@"telephone"];
            
            [[YanMethodManager defaultManager] callPhoneActionWithNum:telephone viewController:self];
        }
        return;
    }
    if (buttonIndex==1) {

        NetWorkRequest *request = [[NetWorkRequest alloc]init];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
        NSString *para = [NSString stringWithFormat:@"member_id=%@",memberId];
        if (_scrollView.contentOffset.x == 0) {
            
            NSLog(@"删除全部商品收藏");

            [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=delfavorite_goods"] postData:para];
            request.successRequest = ^(NSDictionary *dataDic){
                NSNumber *code = [dataDic objectForKey:@"code"];
                int numCode = [code intValue];//请求数据成功代码号
                if (numCode==200) {
                    
                    [collectionDataArray removeAllObjects];
                    UITableView *tableView1 =(UITableView *)[_scrollView viewWithTag:700];
                    [tableView1 reloadData];
                    if (collectionDataArray.count == 0) {
                        [YanMethodManager emptyDataInView:tableView1 title:@"暂无商品收藏"];
                    }
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                };
            request.failureRequest = ^(NSError *error){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            };
        }
        else
        {
        
            NSLog(@"删除全部商户收藏");
            [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=delfavorite_stores"] postData:para];
            request.successRequest = ^(NSDictionary *dataDic){
                NSNumber *code = [dataDic objectForKey:@"code"];
                int numCode = [code intValue];//请求数据成功代码号
                if (numCode==200) {
                    
                    [marketsCollectionArry removeAllObjects];
                    UITableView *tableView2 =(UITableView *)[_scrollView viewWithTag:701];
                    [tableView2 reloadData];
                    if (marketsCollectionArry.count == 0) {
                        [YanMethodManager emptyDataInView:tableView2 title:@"暂无商户收藏"];
                    }
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            
            };
            request.failureRequest = ^(NSError *error){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            };

        
        }
    }


}
-(void)loadMarksCollectionData{

    marketsCollectionArry = [[NSMutableArray alloc] init];
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NSString *para = [NSString stringWithFormat:@"member_id=%@",memberId];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=favorite_storeslist"] postData:para];
    request.successRequest = ^(NSDictionary *dataDic){
        NSLog(@"========== market collec = %@",dataDic);
        NSNumber *code = [dataDic objectForKey:@"code"];
        int numCode = [code intValue];//请求数据成功代码号
        if (numCode==200) {
            
            UITableView *tableView2 =(UITableView *)[_scrollView viewWithTag:701];
            NSArray *dataArray = [dataDic objectForKey:@"data"];
            if (dataArray.count > 0) {
                for (NSDictionary *dic in dataArray) {
                    
                    goodsClassify *model = [[goodsClassify alloc] initWithDic:dic];
                    [marketsCollectionArry addObject:model];
                }
            } else {
                [YanMethodManager emptyDataInView:tableView2 title:@"暂无商户收藏"];
            }
            
            
            [tableView2 reloadData];
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        
    };
    request.failureRequest = ^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    };
    

}
-(void)loadGoodsCollectionData{
    collectionDataArray = [[NSMutableArray alloc] init];
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NSString *para = [NSString stringWithFormat:@"member_id=%@",memberId];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=favorite_goodslist"] postData:para];
    request.successRequest = ^(NSDictionary *dataDic){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"-------------- collection dic = %@",dataDic);
        NSNumber *code = [dataDic objectForKey:@"code"];
        int numCode = [code intValue];//请求数据成功代码号
        if (numCode==200) {
            UITableView *tableView1 =(UITableView *)[_scrollView viewWithTag:700];
            NSArray *dataArray = [dataDic objectForKey:@"data"];
            if (dataArray.count > 0) {
                for (NSDictionary *dic in dataArray) {
                    
                    HomeGoodsItem *model = [[HomeGoodsItem alloc] initWithDic:dic];
                    [collectionDataArray addObject:model];
                }
            } else {
                [YanMethodManager emptyDataInView:tableView1 title:@"暂无商品收藏"];
            }
            
            [tableView1 reloadData];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];


        }
    };
    
    request.failureRequest = ^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    };
}
-(void)createBottomView{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64, kScreen_width, kScreen_height - 64)];
    _scrollView.scrollEnabled = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(kScreen_width * 2, kScreen_height - 64);
    _scrollView.showsHorizontalScrollIndicator = false;
    [self.view addSubview:_scrollView];
    for (int i = 0; i<2; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreen_width * i, 0, kScreen_width, kScreen_height-64) style:UITableViewStylePlain];
        tableView.tag = 700+i;
        tableView.dataSource = self;
        tableView.delegate = self;
        UIView *footView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 0.5)];
        [footView1 setBackgroundColor:kDividColor];
        tableView.tableFooterView = footView1;
        [_scrollView addSubview:tableView];
    }
    
    [self.view addSubview:_scrollView];
}
-(void)createTopView{
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, 51)];
    NSArray *top = @[@"商品收藏",@"商户收藏"];
    
    for (int i = 0; i<top.count; i++) {
        
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_width/2 *i, 0, kScreen_width/2, 50)];
        
        if (i == 0) {
            btn1.selected = YES;
        }
        [btn1 setTitle:top[i] forState:UIControlStateNormal];
        [btn1 setTitle:top[i] forState:UIControlStateSelected];
        [btn1 setTitleColor:kBlack_Color_2 forState:UIControlStateSelected];
        [btn1 setTitleColor:kBlack_Color_3 forState:UIControlStateNormal];
        btn1.tag = 500 + i;
        [btn1 addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:btn1];
        
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
    }
    if (btn.tag == 501&&!btn.selected) {
        btn1.selected =NO;
        btn2.selected = YES;
        view.frame = CGRectMake(kScreen_width/2, viewX, kScreen_width/2, 3);
    }
    if (btn.tag == 500) {
        [UIView animateWithDuration:.4 animations:^{
            _scrollView.contentOffset = CGPointZero;
            
        }];
    } else
    {
        [UIView animateWithDuration:.4 animations:^{
            _scrollView.contentOffset = CGPointMake(kScreen_width, 0);
        }];
        
    }
    
    
}
-(void)myCollectionPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 700) {
        
        return collectionDataArray.count;
    }
    return marketsCollectionArry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 700) {
        return 100;
    }
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *collection = @"collection";
    HomeGoodsItem *model = [collectionDataArray objectAtIndex:indexPath.row];
    GoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collection];
    
    if (!cell) {
        cell = [[GoodsListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:collection witnAddgoodsToCar:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.isList = YES;
    cell.goodsItem = model;
    __weak MyCollectionViewController *weakSelf = self;
    cell.selectCountBlock = ^(UIButton *button){
        [weakSelf noboughtselectCountInCellWithIndexPath:indexPath button:button];
    };
    
    cell.addCartBlock = ^(UITapGestureRecognizer *tap){
        [weakSelf noboughtaddGoodsToCart:model withTap:tap withIndexPath:indexPath];
    };
    
    return cell;
}

-(void)noboughtaddGoodsToCart:(HomeGoodsItem *)model withTap:(UITapGestureRecognizer *)tap withIndexPath:(NSIndexPath *)indexPath{
    
    UITableView *tableView1 =(UITableView *)[_scrollView viewWithTag:700];
    GoodsListTableViewCell *cell = (GoodsListTableViewCell *)[tableView1 cellForRowAtIndexPath:indexPath];
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addshopcar"] postData:[NSString stringWithFormat:@"goods_id=%d&quantity=%@&member_id=%@",model.goods_id,cell.selectCountV.countLabel.text,member_id]];
    __weak MyCollectionViewController *weakSelf = self;
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
    UITableView *tableView1 =(UITableView *)[_scrollView viewWithTag:700];
    GoodsListTableViewCell *cell = (GoodsListTableViewCell *)[tableView1 cellForRowAtIndexPath:indexPath];
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


-(void)addGoodsToCar:(goodsClassify *)model{
    
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    //            NSString *mobile = [NSUserDefaults ]
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NSString *para = [NSString stringWithFormat:@"goods_id=%d&quantity=%d&member_id=%@",model.goods_id,1,member_id];
    [YanMethodManager showIndicatorOnView:self.view];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addshopcar"] postData:para];
    __weak MyCollectionViewController *weakSelf = self;
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
#pragma mark 判断超市系统状态


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x != currentOffset) {
        
        UIButton *btn1 =(UIButton *)[topView viewWithTag:500];
        UIButton *btn2 =(UIButton *)[topView viewWithTag:501];
        btn1.selected =!btn1.selected;
        btn2.selected =!btn2.selected;
        currentOffset = scrollView.contentOffset.x;
    }
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
        if (tableView.tag == 700) {
            if (_isGoodsCollectionDelete == NO&&collectionDataArray.count>0) {
                _isGoodsCollectionDelete = YES;
                [YanMethodManager showIndicatorOnView:self.view];
            NetWorkRequest *request = [[NetWorkRequest alloc]init];
            HomeGoodsItem *model = [collectionDataArray objectAtIndex:indexPath.row];
            NSString *para = [NSString stringWithFormat:@"id=%d&member_id=%@",model.tempId,memberId];
            [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=delfavorite_goods"] postData:para];
            
            request.successRequest = ^(NSDictionary *dataDic)
            {
                [YanMethodManager hideIndicatorFromView:self.view];
                NSString *code = [dataDic objectForKey:@"code"];
                if (code.intValue==200) {
                    [collectionDataArray removeObjectAtIndex:indexPath.row];
                    UITableView *goodsTableView = (UITableView *)[_scrollView viewWithTag:700];
                    UITableView *_tableView =(UITableView *)[_scrollView viewWithTag:700];
                    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                    [goodsTableView reloadData];
                    _isGoodsCollectionDelete = NO;
                    if (collectionDataArray.count == 0) {
                        [YanMethodManager emptyDataInView:tableView title:@"暂无商品收藏"];
                    }

                }
            };
                request.failureRequest = ^(NSError *error){
                    _isGoodsCollectionDelete = NO;
                [YanMethodManager hideIndicatorFromView:self.view];
  
                };
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
    self.tabBarController.tabBar.hidden = NO;

    self.navigationController.navigationBarHidden = YES;
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
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
