//
//  PaySuccessViewController.m
//  OCommunity
//
//  Created by runkun2 on 15/7/11.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "PaySuccessgoodsMessageTableViewCell.h"
#import "PaySuccessmemberMessageTableViewCell.h"
@interface PaySuccessViewController ()<UIGestureRecognizerDelegate>
{
    UITableView *_tableView;
}
@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"下单成功"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(pop)];
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, .5)];
    footView.backgroundColor = kDividColor;
    _tableView.tableFooterView = footView;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 110)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:headView.bounds];
    imageView.image = [UIImage imageNamed:@"success_pay"];
    [headView addSubview:imageView];
    _tableView.tableHeaderView = headView;
    [self.view addSubview:_tableView];
    
}
-(void)pop{

    [self.navigationController popToRootViewControllerAnimated:YES];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    if (indexPath.row ==0) {
        
//        CGFloat height = [[YanMethodManager defaultManager] titleLabelHeightByText:_sendGoodsAddress width:kScreen_width-40 font:kFontSize_3];
        return 80;

    }else{
        return 125;
    
    }


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
//
        PaySuccessmemberMessageTableViewCell *cell = [[PaySuccessmemberMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"paySucccess1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.memberName = _memberName;
        cell.phoneNum = _phoneNum;
        cell.sendGoodsAddress = _sendGoodsAddress;
        return cell;

    }else{
    
        PaySuccessgoodsMessageTableViewCell *cell = [[PaySuccessgoodsMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"paySucccess1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.receiveOrderTime = _receiveOrderTime;
        cell.moneyToPay = _moneyToPay;
        cell.transportePay = _transportePay;
        cell.sendGoodsTime = _sendGoodsTime;
        cell.payMethodString = _payMethodString;
        return cell;
    }
//
 
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if (self.paySuccessBlock) {
        self.paySuccessBlock();
    }
}


@end
