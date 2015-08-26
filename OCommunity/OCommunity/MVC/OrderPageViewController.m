//
//  OrderPageViewController.m
//  diangdan
//
//  Created by runkun3 on 15/7/21.
//  Copyright (c) 2015年 runkun3. All rights reserved.
//

#import "OrderPageViewController.h"
#import "OrderTableViewCell.h"
#import "OrderModel.h"
#import "MyOrderDetailViewController.h"
@interface OrderPageViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)OrderModel *model;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation OrderPageViewController
{
    int _currentPage;
    int _totalPage;
    NSMutableArray *orderListArr;
    OrderModel *item ;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"订单"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(haveBoughtPop)];
    _currentPage =1;
    orderListArr = [[NSMutableArray alloc]init];
    [self creatTableView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestOrderData];
    
}
-(void)creatTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-64)style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 50)];
    _tableView.tableFooterView = _bottomView;

    [self.view addSubview:_tableView];
    
}
-(void)haveBoughtPop
{
    [self.navigationController popViewControllerAnimated:YES];
}
//请求已支付信息
-(void)requestOrderData{
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NSLog(@"======%@",member_id);
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *para =[NSString stringWithFormat:@"member_id=%@&pagenumber=%d&pagesize=%d",member_id,_currentPage,10];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api_order.php?commend=order_list"] postData:para];
    request.successRequest = ^(NSDictionary *requestDic){
        NSLog(@"0000%@",requestDic);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSNumber *number = [requestDic objectForKey:@"code"];
        int code = [number intValue];
        if (code ==200) {
            NSNumber *totalCount = [requestDic objectForKey:@"count"];
            int remainder = totalCount.intValue % 10;
            if (remainder > 0) {
                _totalPage = totalCount.intValue/10 + 1;
            } else {
                _totalPage = totalCount.intValue/10;
            }
            NSArray *datasArr = [requestDic objectForKey:@"datas"];
            if (datasArr.count ==0) {
                [YanMethodManager emptyDataInView:_tableView title:@"暂无订单"];
            }else{
                for (int i = 0; i < datasArr.count; i++) {
                    NSDictionary *itemDic = datasArr[i];
                     item = [[OrderModel alloc] initWithDic:itemDic];
                    [orderListArr addObject:item];
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
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
    };
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
    label.text = @"暂无更多数据";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:kFontSize_3];
    label.textColor = kDividColor;
    [view addSubview:label];
    _tableView.tableFooterView = _bottomView;
    
}
#pragma  tableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return orderListArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 185;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identy = @"identy";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (!cell) {
        cell = [[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    OrderModel *model = [orderListArr objectAtIndex:indexPath.row];
    cell.myOrders = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MyOrderDetailViewController *orderDetailVC = [[MyOrderDetailViewController alloc] init];
    OrderModel *model = [orderListArr objectAtIndex:indexPath.row];
    orderDetailVC.order_sn = model.order_sn;
    orderDetailVC.marketPicName = model.store_pic;
    orderDetailVC.marketName = model.store_name;
    orderDetailVC.hidesBottomBarWhenPushed  =YES;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}
-(BOOL)tableView:(UITableView *)tableview canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if ( editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
//    }
//}

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
                ++_currentPage;
                [self requestOrderData];
                
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
    
    self.navigationController.navigationBarHidden = NO;
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
