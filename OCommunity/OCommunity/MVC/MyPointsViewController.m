//
//  MyPointsViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/6.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MyPointsViewController.h"
#import "MypointTableViewCell.h"
#import "MypointView.h"
#import "goodsClassify.h"
#import "LoginViewController.h"
#define kHeadViewHeight 68
@interface MyPointsViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *currentPointsLabel;
@property (nonatomic, strong) UILabel *willExpiredLabel;

@end

@implementation MyPointsViewController{
    
    NSMutableArray *receiveDataArray;
    NSMutableArray *dataArray;
    NSMutableArray *allDataArray;
    NSMutableArray *payDataAray;
    UIView *headView;
    UITableView *_tableView;
    MypointView *noPointview;
    NSMutableArray *tableData;
    UISegmentedControl *segmentCtrl;
    
}
static int totalPoint;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(myPointsPop)];
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"我的积分"];
//    tableData = [[NSMutableArray alloc] init];
    receiveDataArray = [[NSMutableArray alloc] init];

    [self createMyPointsSubviews];
    [self loadMypointData];
    //请求红包数据
    [self loadEnvelopeData];

    
    // Do any additional setup after loading the view.
}
-(void)loadEnvelopeData{
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NSDictionary *storeID_Dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [storeID_Dic objectForKey:@"store_id"];
    NSLog(@"adkjadkjadkjahdkjahkjdk%@%@",member_id,store_id);
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    NSString *para = [NSString stringWithFormat:@"member_id=%@&store_id=%@",member_id,store_id];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=mshongbao"] postData:para];
    request.successRequest = ^(NSDictionary *dataDic)
    {
        NSLog(@"asdasgjsdjahdjajdg%@",dataDic);
        NSString *code = [dataDic objectForKey:@"code"];
        if (code.intValue ==200) {
            NSDictionary *hongBaoDic = [dataDic objectForKey:@"datas"];
            NSString *hongBao = [hongBaoDic objectForKey:@"hongbao"];
//            NSString *start_time = [hongBaoDic objectForKey:@"start_time"];
//            NSString *end_time = [hongBaoDic objectForKey:@"end_time"];
//            int hongbaoTime =  (end_time.intValue - start_time.intValue)/3600;
//            
            _willExpiredLabel.text = hongBao;
            
            
        }

    };

    
    
}
#define kTitleLabel_left 15
#define kTotallabel_left 50
-(void)loadMypointData{
    totalPoint =0;
NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    if (member_id == NULL) {
        
        noPointview.hidden = NO;
        _tableView.hidden = YES;
        receiveDataArray = nil;
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.isPresent = YES;
        loginVC.dismissBlock = ^{
            
            self.tabBarController.selectedIndex = 3;
        };
        loginVC.loginSuccessBlock = ^{
        };
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.tabBarController presentViewController:navi animated:NO completion:nil];
        
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//    [self.navigationController popViewControllerAnimated:YES];
//
//    });
    }else{
//    payDataAray = [[NSMutableArray alloc] init];
//        allDataArray = [[NSMutableArray alloc] init];
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *para = [NSString stringWithFormat:@"member_id=%@",member_id];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=member_score"] postData:para];
    request.successRequest = ^(NSDictionary *dataDic)
        {
            NSLog(@"dadgjadjhajhdjh%@",dataDic);
        for (NSDictionary *MypointDic in [dataDic objectForKey:@"datas"]) {
            
            goodsClassify *model = [[goodsClassify alloc] initWithDic:MypointDic];
            if ((!(model.totalScore==NULL)&&![model.totalScore isKindOfClass:[NSNull class]])&&![model.totalScore isEqualToString:@"0"]) {
                totalPoint += model.totalScore.intValue;
                [receiveDataArray addObject:model];
            }
        }
        _currentPointsLabel.text = [NSString stringWithFormat:@"%d",totalPoint];
        [_tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (receiveDataArray.count==0) {
    
            noPointview.hidden = NO;
        }else{
    
            _tableView.hidden = NO;
        }
    };
    request.failureRequest = ^(NSError *error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        };
    }
    
}
-(void)createMyPointsSubviews
{
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, kHeadViewHeight)];
    UILabel *currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, kScreen_width/2, 25)];
    currentLabel.text = @"当前积分";
    currentLabel.textColor = [UIColor redColor];
    currentLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    currentLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:currentLabel];
    
    _currentPointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, currentLabel.bottom + 5, kScreen_width/2, 20)];
    _currentPointsLabel.text = @"0";
    _currentPointsLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    _currentPointsLabel.textColor = [UIColor redColor];
    _currentPointsLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:_currentPointsLabel];

    UIView *seperateView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _currentPointsLabel.bottom +10, kScreen_width, 1)];
    seperateView1.backgroundColor = [UIColor colorWithWhite:.8 alpha:.7];
    UIView *seperateView2 = [[UIView alloc] initWithFrame:CGRectMake(kScreen_width/2-0.5,5, 1, 55)];
    seperateView2.backgroundColor = [UIColor colorWithWhite:.8 alpha:.7];
    
    [headView addSubview:seperateView1];
    [headView addSubview:seperateView2];
    UILabel *willExpired = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_width/2, 7, kScreen_width/2, 25)];
    willExpired.text = @"我的红包";
    willExpired.textColor = [UIColor brownColor];
    willExpired.textAlignment = NSTextAlignmentCenter;
    willExpired.font = [UIFont systemFontOfSize:kFontSize_2];
    [headView addSubview:willExpired];
    _willExpiredLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_width/2, willExpired.bottom +5, kScreen_width/2, 20)];
    _willExpiredLabel.text = @"0";
    _willExpiredLabel.textColor = [UIColor brownColor];
    _willExpiredLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    _willExpiredLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:_willExpiredLabel];
//    headView.height = 
    //    NSArray *array = @[,nil];
//    NSArray *array = [NSArray arrayWithObjects:@"全部",@"获得",@"支出", nil];
//    segmentCtrl = [[UISegmentedControl alloc] initWithItems:array];
//    segmentCtrl.frame = CGRectMake(10, _willExpiredLabel.bottom + 17, kScreen_width - 20, 35);
//    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
//                                             NSForegroundColorAttributeName: [UIColor whiteColor]};
//    NSDictionary* selectedTextAttributes1 = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
//    [segmentCtrl setTitleTextAttributes:selectedTextAttributes1 forState:UIControlStateNormal];//设置文字属性
//    
//    [segmentCtrl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
//    //    segmentCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
//    segmentCtrl.selectedSegmentIndex = 1;
//    segmentCtrl.tintColor = [UIColor redColor];
//    [segmentCtrl addTarget:self action:@selector(segmentAction:)  forControlEvents:UIControlEventValueChanged];
//    [headView addSubview:segmentCtrl];
//    UIView *seperateView3 = [[UIView alloc] initWithFrame:CGRectMake(0, segmentCtrl.bottom +5, kScreen_width, 1)];
//    [seperateView3 setBackgroundColor:[UIColor colorWithWhite:.8 alpha:.7]];
//    [headView addSubview:seperateView3];
//    
    [self.view addSubview:headView];
    //    [headView setBackgroundColor:[UIColor greenCol
//    dataArray = [[NSMutableArray alloc] initWithObjects:@"您还没有积分记录",@"您还没有获得积分记录",@"您还没有积分支出记录" ,nil];
//        receiveDataArray = [[NSMutableArray alloc] init];
//    receiveDataArray = [[NSMutableArray alloc] initWithObjects:@"购物下单",@"超市活动",nil];
//    allDataArray = [[NSMutableArray alloc] initWithObjects:@"购物下单",@"超市活动",@"其他",
//                    nil];

    //看数据是否有，现在是写死的状态
    //    if (receiveDataArray.count==0) {
    
    
    //    }else{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headView.bottom, kScreen_width, kScreen_height - 64-headView.height)style:UITableViewStylePlain];
    //    UITableView *aaa = [[UITableView alloc] in]
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    UIView *footView1 = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreen_width, 0.5)];
    [footView1 setBackgroundColor:kDividColor];
    _tableView.tableFooterView = footView1;
    //    [tableView setTableHeaderView:headView];
    [self .view addSubview:_tableView];
    noPointview = [[MypointView alloc] initWithFrame:CGRectMake(0,headView.bottom +80,kScreen_width, 200) withImageName:@"em_points"];
    noPointview.title = @"您还没有积分记录";
    noPointview.hidden = YES;
    [self.view addSubview:noPointview];
    

}
////分段控制点击方法
//- (void)segmentAction:(UISegmentedControl *)segment
//{//
//    
//    if (receiveDataArray.count ==0) {
//        noPointview.title = dataArray[segment.selectedSegmentIndex];
//        
//    }else if(payDataAray.count ==0&&segment.selectedSegmentIndex ==2){
//        noPointview.title = dataArray[segment.selectedSegmentIndex];
//        _tableView.hidden = YES;
//        noPointview.hidden = NO;
//        //根据 全部 获得 支出对tableView做操作
//    }else{
//        noPointview.hidden = YES;
//        _tableView.hidden = NO;
//        _tableView.contentOffset = CGPointMake(0, 0);
//        [_tableView reloadData];
//    }
//
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (segmentCtrl.selectedSegmentIndex ==0) {
//        tableData = allDataArray;
//    }else if(segmentCtrl.selectedSegmentIndex ==1){
//        tableData = receiveDataArray;
//    }else{
//        tableData = payDataAray;
//    }
    return receiveDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"myPointCell";
    
    MypointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[MypointTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    goodsClassify *model = [receiveDataArray objectAtIndex:indexPath.row];
    cell.MypointModel = model;
    
//    cell.labelText = tableData[indexPath.row];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(void)myPointsPop
{
    [self.navigationController popViewControllerAnimated:YES];
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
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
