//
//  MyOrderDetailViewController.m
//  OCommunity
//
//  Created by runkun2 on 15/7/21.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MyOrderDetailViewController.h"
#import "OrderDetailTopView.h"
#import "OrderGoodsCategoryTableViewCell.h"
#import "OrderDetailTableViewCell.h"
#import "GoodsCommentsTableViewCell.h"
#import "MyCommentViewController.h"
#import "CommentsModel.h"
#import "OrderDetailModel.h"
#import "CommentsModel.h"
#import "Goods_ListModel.h"
#define kBottomView_height 100
#define kLogoutBtn_left 30
#define kLogoutBtn_height 45
@interface MyOrderDetailViewController ()<UIGestureRecognizerDelegate>
{
    UITableView *_tableView;
    NSArray *topSectionLabel;
    NSArray *topSectionImage;
    NSMutableArray *goodsNum;//购买的货物数量及种类、价格
    NSMutableArray *otherPay;
    NSMutableArray *priceToPay;
    NSMutableArray *commentArray;
    NSMutableArray *orderDetailArray;
    UIButton *footButtonView;
    OrderDetailModel *orderDetailModel;
    CommentsModel *commentModel;
}
@end

@implementation MyOrderDetailViewController

static float totalPrice=0;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorWithRGB(246, 246, 246);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"订单详情"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(orderDetailPop)];
    //表视图每一组的标题
    topSectionLabel = @[@"益万家超市",@"订单详情",@"我的评价"];
    //表视图每一组的图片
    topSectionImage = @[@"orderDetail_market",@"orderDetail_order",@"orderDetail_comment"];
    //除商品外其他可能的消费
    otherPay = [[NSMutableArray alloc] initWithObjects:@"配送费",@"优惠券(使用)",@"合计", nil];
    //请求订单详情数据
    [self createTableSubViews];
    [self loadOrderDetailData];

}
-(void)loadOrderDetailData{
    
    totalPrice = 0;
    commentArray= [[NSMutableArray alloc] init];
    orderDetailArray = [[NSMutableArray alloc] init];
    goodsNum = [[NSMutableArray alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
//    _order_sn = @"2015070710049102";
    NSString *para = [NSString stringWithFormat:@"order_sn=%@",_order_sn];
    __weak MyOrderDetailViewController *weakSelf = self;
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api_order.php?commend=order"] postData:para];
    request.successRequest = ^(NSDictionary *dataDic){
        NSLog(@"++++++++++++++++++++=============%@",dataDic);
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSNumber *code = [dataDic objectForKey:@"code"];
        int numCode = [code intValue];//请求数据成功代码号
        if (numCode==200) {
                NSDictionary *dic = [dataDic objectForKey:@"datas"];
                orderDetailModel = [[OrderDetailModel alloc] initWithDic:dic];
                [orderDetailArray addObject:orderDetailModel];
                NSDictionary *commentDic = [dic objectForKey:@"comments"];
                if ([[YanMethodManager defaultManager] isDictionaryEmptyWithDic:commentDic] == NO) {
                    //请求评论数据
                    if (commentDic.count>0) {
                        commentModel = [[CommentsModel alloc] initWithDic:commentDic];
                        commentModel.member_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
                        [commentArray addObject:commentModel];
                    }
                }
            //若无评论穿创建表视图的尾视图点击进入评论页面
                if (commentArray.count==0) {
                    [self creaTableFooterView];
                }else{
                    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 1)];
                    _tableView.tableFooterView = footView;
                }
                NSArray *goods_listArray = [dic objectForKey:@"goods_list"];

                if ([[YanMethodManager defaultManager] isArrayEmptyWithArray:goods_listArray] == NO) {
                    for (NSDictionary *goodsDic in [dic objectForKey:@"goods_list"]) {
                      Goods_ListModel *goods_List = [[Goods_ListModel alloc] initWithDic:goodsDic];
                        //计算商品的总价
                        totalPrice += goods_List.total_fee;
                        [goodsNum addObject:goods_List];
                    }
                }
            //总价加上运费
            totalPrice += orderDetailModel.fare
            ;
            totalPrice -= [orderDetailModel.couponamount floatValue];
            }
        [_tableView reloadData];
    };
    request.failureRequest = ^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    };
}
 //若是没有评论，设置表视图的尾视图，点击进入评论页
-(void)creaTableFooterView{
   
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kBottomView_height)];
    UIView *seperateView = [YanMethodManager lineViewWithFrame:CGRectMake(0, 0, kScreen_width, 1) superView:bottomView];
    seperateView.backgroundColor = kColorWithRGB(223,223,223);
    bottomView.backgroundColor = [UIColor whiteColor];
    footButtonView = [UIButton buttonWithType:UIButtonTypeSystem];
    footButtonView.frame = CGRectMake(kLogoutBtn_left, bottomView.height-kLogoutBtn_height-15, bottomView.width-2*kLogoutBtn_left, kLogoutBtn_height);
    footButtonView.backgroundColor = kRedColor;
    footButtonView.layer.cornerRadius = 5;
    [footButtonView setTitle:@"我要评论" forState:UIControlStateNormal];
    [footButtonView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footButtonView addTarget:self action:@selector(addCommentsOfYourself) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:footButtonView];
    _tableView.tableFooterView = bottomView;
}

-(void)createTableSubViews{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-64)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}
-(void)addCommentsOfYourself{
//进入评论页//
    MyCommentViewController *commentVC = [[MyCommentViewController alloc] init];
    commentVC.hidesBottomBarWhenPushed = YES;
    commentVC.marketPicName = _marketPicName;
    commentVC.orderDetail = orderDetailModel;
    __weak MyOrderDetailViewController *weakSelf = self;
    commentVC.addMycommentSuccess = ^{
        [weakSelf loadOrderDetailData];
    
    };
    [self.navigationController pushViewController:commentVC animated:YES];
}
-(void)orderDetailPop{

    [self.navigationController popViewControllerAnimated:YES];

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//自定义组的头视图
    OrderDetailTopView *topView = [[OrderDetailTopView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 80)];
    topView.label.text = [topSectionLabel objectAtIndex:section];
    topView.imageView.image = [UIImage imageNamed:[topSectionImage objectAtIndex:section]];
    if (section ==0) {
        topView.lineView.hidden = YES;
        topView.label.text = orderDetailModel.store_name;
    }

    return topView;     

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 80;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //最多有一条评论若无评论返回2组，添加尾视图，若有返回3组
    return 2+commentArray.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0) {
        //购买的商品种类数加上固定的配送费、优惠券和合计行数
        return goodsNum.count +otherPay.count;
        
    }else if (section ==1){
        //返回1行
        return orderDetailArray.count;
        
    }else{
        //返回评论数据，
        return commentArray.count;
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        if (indexPath.row<goodsNum.count) {
            return 35;
        }else{
        
            return 30;
        }
    }else if(indexPath.section ==1){
        
        
        return 200;
        
    }else{
        
    CGFloat height = [[YanMethodManager defaultManager] titleLabelHeightByText:commentModel.comment width:kScreen_width - 40 font:kFontSize_3];
        return height +80;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section ==0) {
        if (indexPath.row<goodsNum.count) {
            static NSString *indenty1 = @"section1";
            //客户买的东西的类别及数量
            OrderGoodsCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenty1];
            if (!cell) {
                
                cell = [[OrderGoodsCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenty1];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.goodsListModel = [goodsNum objectAtIndex:indexPath.row];
            return cell;

        }else{
            //配送费、优惠券、价格合计
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"peiSongFei"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.textColor = kColorWithRGB(67,67,67);
            cell.textLabel.textColor = kColorWithRGB(67,67,67);
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            ;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            ;
            cell.textLabel.text =[NSString stringWithFormat:@"%@",[otherPay objectAtIndex:indexPath.row - goodsNum.count]];
            if (indexPath.row == goodsNum.count) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.1f",orderDetailModel.fare];
            }else  if (indexPath.row == goodsNum.count+1) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"￥-%0.1f",[orderDetailModel.couponamount floatValue]];
            }else{
                cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
                cell.detailTextLabel.textColor = kRed_PriceColor;
            }
            return cell;
        }
        
        
    }
    if (indexPath.section == 1) {
        
        static NSString *indenty2 = @"section2";
        //订单详情订单号、下单时间、支付方式等
        OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenty2];
        if (!cell) {
          cell = [[OrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenty2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        cell.orderDetailModel = orderDetailModel;
        
        return cell;
    }
    if (indexPath.section == 2) {
        //评论
        GoodsCommentsTableViewCell *cell = [[GoodsCommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.commentsData = [commentArray firstObject];
        return cell;
    }
    return nil;
    
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
