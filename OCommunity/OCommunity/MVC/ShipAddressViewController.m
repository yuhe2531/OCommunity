//
//  ShipAddressViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/4.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "ShipAddressViewController.h"
#import "ShipAddressTableViewCell.h"
#import "NewAddressViewController.h"
#import "goodsClassify.h"

@interface ShipAddressViewController ()<UIGestureRecognizerDelegate>

{
    NSString *testAddress;
    NSMutableArray *addressDataArray;
    NSMutableArray *markArray;
    NSInteger _selectedRow;

}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isDelete;

@end
@class ShipAddressTableViewCell;
@implementation ShipAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    markArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _selectedRow = -1;
    addressDataArray = [[NSMutableArray alloc] init];
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"管理收货地址"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(shipAddressPop)];
    testAddress = @"山东济南历下区洪家楼山东济南历下区洪家楼山东济南历下区洪家楼";
    [self rightNaviBarItemHandle];
    [self addAddressTableview];
    
    [self loadData];
}
-(void)defaultAddressRequest:(NSInteger)row {
    
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    goodsClassify *model = addressDataArray[_selectedRow];
    NSString *memberID = [[NSUserDefaults standardUserDefaults]objectForKey:@"member_id"];
    NSString *para = [NSString stringWithFormat:@"id=%d&member_id=%@",model.address_id,memberID];
    NSLog(@"============= para = %@",para);
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=moddeaddress"] postData:para];
    request.successRequest = ^(NSDictionary *dataDic){
        NSLog(@"22222222%@",dataDic);
        [self.view makeToast:@"已设置为默认地址" duration:.5 position:@"center"];
        NSNumber *codeNum = [dataDic objectForKey:@"code"];
        if (codeNum.intValue == 200){
            goodsClassify *model = addressDataArray[row];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"consignee_address"];
            NSDictionary *addressDic = @{@"address":model.address,@"consiger":model.consigner,@"mobile":model.mobile};
            [[NSUserDefaults standardUserDefaults] setObject:addressDic forKey:@"consignee_address"];
            [_tableView reloadData];
        }
        
    };

}
-(void)loadData{
    //加载收货地址列表
    _selectedRow = -1;

    [addressDataArray removeAllObjects];
    [YanMethodManager removeEmptyViewOnView:self.view];
    NetWorkRequest *request = [[NetWorkRequest alloc]init];
    NSString *member_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"member_id"];
    NSString *para = [NSString stringWithFormat:@"member_id=%d",member_id.intValue];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addresslist"] postData:para];
    request.successRequest = ^(NSDictionary *dataDic)
    {
        NSNumber *codeNum = [dataDic objectForKey:@"code"];
        if (codeNum.intValue == 200) {
            if (addressDataArray.count>0) {
                [addressDataArray removeAllObjects];
            }
            NSArray *dicArr =[dataDic objectForKey:@"data"];
            if (dicArr.count>0) {
                for (NSDictionary *MypointDic in [dataDic objectForKey:@"data"]) {
                    goodsClassify *model = [[goodsClassify alloc] initWithDic:MypointDic];
                    [addressDataArray addObject:model];
                    if (model.isdefault == 1) {
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"consignee_address"];
                        NSDictionary *addressDic = @{@"address":model.address,@"consiger":model.consigner,@"mobile":model.mobile};
                        [[NSUserDefaults standardUserDefaults] setObject:addressDic forKey:@"consignee_address"];
                    }
                }
                
                [_tableView reloadData];
            } else {
                [YanMethodManager emptyDataInView:self.view title:@"点击右上角添加收获地址"];
            }
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    };
    
    request.failureRequest = ^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    };
}


-(void)shipAddressPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightNaviBarItemHandle
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setTitle:@"+" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:30];
    [button addTarget:self action:@selector(addAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)addAddressTableview
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    UIView *footView1 = [[UIView alloc] initWithFrame:CGRectMake(16, 0, kScreen_width, 0.5)];
    [footView1 setBackgroundColor:kDividColor];
    _tableView.tableFooterView = footView1;
    [self.view addSubview:_tableView];
}

#pragma mark UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return addressDataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewAddressViewController *newVC =  [[NewAddressViewController alloc]init];
    __weak ShipAddressViewController *blockVC = self;
    newVC.addressBlock=^{
        
        [blockVC loadData];
        
    };

    goodsClassify *model = [addressDataArray objectAtIndex:indexPath.row];
    
    newVC.addressModel = model;
    [self.navigationController pushViewController:newVC animated:YES];


}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    goodsClassify *model = [addressDataArray objectAtIndex:indexPath.row];
     CGFloat width = kScreen_width-20-15-20;
    CGFloat height = [[YanMethodManager defaultManager] titleLabelHeightByText:model.address width:width font:kFontSize_3];
    return height + 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"addressCell";
    ShipAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[ShipAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil address:testAddress];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    goodsClassify *model = [addressDataArray objectAtIndex:indexPath.row];
    cell.addressModel = model;
    if (_selectedRow == -1) {
        if (model.isdefault == 1) {
            cell.isSelect = YES;
        } else {
            cell.isSelect = NO;
        }
    }
    
    
    if (_selectedRow == indexPath.row) {
        cell.isSelect = YES;
    } else {
        if (_selectedRow != -1) {
            cell.isSelect = NO;
        }
        
    }
    
    cell.markBtnBlock = ^{
        _selectedRow = indexPath.row;
        [self defaultAddressRequest:_selectedRow];
     
    };

     return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除地址
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (_isDelete == NO) {
            _isDelete = YES;
            NetWorkRequest *request = [[NetWorkRequest alloc]init];
            goodsClassify *model = [addressDataArray objectAtIndex:indexPath.row];
            NSString *para = [NSString stringWithFormat:@"id=%d",model.address_id];
            [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=deladdressinfo"] postData:para];
            request.successRequest = ^(NSDictionary *dataDic)
            {
                NSString *code = [dataDic objectForKey:@"code"];
                if (code.intValue==200) {
                    _isDelete = NO;
                    [addressDataArray removeObjectAtIndex:indexPath.row];
                    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                    if (addressDataArray.count == 0) {
                        [YanMethodManager emptyDataInView:self.view title:@"点击右上角添加收获地址"];
                    }
                    [_tableView reloadData];
                    
                }
            };
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return @"删除";
}

-(void)addAddressAction:(UIButton *)button
{
    NSLog(@"============= 增加收获地址");
    NewAddressViewController *newAddressVC = [[NewAddressViewController alloc] init];
    __weak ShipAddressViewController *blockVC = self;
    newAddressVC.addressBlock=^{
    
        [blockVC loadData];
    
    };

    [self.navigationController pushViewController:newAddressVC animated:YES];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
