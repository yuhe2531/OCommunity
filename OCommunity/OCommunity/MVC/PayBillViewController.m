//
//  PayBillViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "PayBillViewController.h"
#import "PayBillTableViewCell.h"
#import "PayTableViewCell.h"
#import "SelectCountView.h"
#import "PayBillFooterView.h"
#import "PayBillHeaderView.h"
#import "ShipAddressViewController.h"
#import "CartGoodsItem.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "WXApi.h"
#import "payRequsestHandler.h"
#import "StoreInfoItem.h"
#import "PaySuccessViewController.h"
#import "AppDelegate.h"
#import "CanUsedCouponViewController.h"
#import "CartViewController.h"

@interface PayBillViewController ()<UIGestureRecognizerDelegate>

{
    NSString *shopcarids;
    NSString *goodsnums;
    UIButton *payBtn;
    StoreInfoItem *storeInfo;
    NSString *sucTime;
    float sucPay;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *totalPriceL;
@property (nonatomic, assign) float totalPrice;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, strong) NSArray *payCommenArr;
@property (nonatomic, assign) int cost_score;
@property (nonatomic, assign) BOOL isPayCommenArrNil;
@property (nonatomic, assign) float redPacket;
@property (nonatomic, assign) BOOL isPaying;
@property (nonatomic, assign) BOOL useRedPackage;
@property (nonatomic, strong) NSTimer *callBakcTimer;
@property (nonatomic, assign) float payCarriage;//实际支付的运费金额
@property (nonatomic, assign) BOOL payCarrigeFee;
@property (nonatomic, strong) NSMutableArray *carriage_storeIDs;
@property (nonatomic, assign) BOOL send;

@property (nonatomic, assign) float standardCarriage;//标准运费金额（商户设定）
@property (nonatomic, assign) float standardSendFee;//标准起送价
@property (nonatomic, copy) NSString *payType;

@property (nonatomic, assign) float discountCoupon;//优惠券金额
@property (nonatomic, assign) NSString *couponID;
@property (nonatomic, assign) NSInteger couponCount;//可用优惠券的数量

@property (nonatomic, assign) int timeCount;

@property (nonatomic, assign) BOOL couponUsed;//判断优惠券今天是否已使用过

@end

@implementation PayBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _isPayCommenArrNil = YES;
    _isPaying = NO;
    _payCarrigeFee = NO;
    _cost_score = 0;
    _redPacket = 0.0;
    _useRedPackage = NO;
    
    _couponID = @"";
    _discountCoupon = 0.0;
    //获取对应超市内可用的优惠券的数量
    _couponCount = 0;
    
    _carriage_storeIDs = [NSMutableArray array];
//    _standardPrice = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"购物车结算"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(payBillPop)];
    
    [self addTableViewOnPayBillVC];
    [self billTotalPriceHandle];
    
    
    //获取各个超市的起送价
    [self requestStoreInfo];
    
    // Do any additional setup after loading the view.
}

//请求在对应超市内可用的优惠券
-(void)requestCouponCount
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    CartGoodsItem *item = _bills[0][0];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api_coupon.php?commend=member_coupons_isok"] postData:[NSString stringWithFormat:@"member_id=%@&store_id=%ld",member_id,item.store_id]];
    request.successRequest = ^(NSDictionary *couponDic){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"=============== request coupon = %@",couponDic);
        NSNumber *code = [couponDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            
            NSNumber *isuse = [couponDic objectForKey:@"is_use"];
            if (isuse.integerValue == 1) {
                _couponUsed = YES;
            } else {
                _couponUsed = NO;
            }
            NSArray *datas = [couponDic objectForKey:@"datas"];
            if ([[YanMethodManager defaultManager] isArrayEmptyWithArray:datas] == NO) {
                _couponCount = datas.count;
            } else {
                _couponCount = 0;
            }
            
        }
        [_tableView reloadData];
    };
    request.failureRequest = ^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    };
}

-(void)requestStoreInfo
{
    NetWorkRequest *reques = [[NetWorkRequest alloc] init];
    NSString *storeInfo_id;
    for (int i = 0; i < _bills.count; i++) {
        NSMutableArray *array = _bills[i];
        CartGoodsItem *item = array[0];
        if (i == 0) {
            storeInfo_id = [NSString stringWithFormat:@"%ld",(long)item.store_id];
        } else {
            storeInfo_id = [storeInfo_id stringByAppendingString:[NSString stringWithFormat:@",%ld",(long)item.store_id]];
        }
    }
    NSLog(@"========== store info id = %@",storeInfo_id);
    CartGoodsItem *cartItem = _bills[0][0];
    [reques requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=findstoreinfo"] postData:[NSString stringWithFormat:@"store_id=%@",storeInfo_id]];
    reques.successRequest = ^(NSDictionary *infoDic){
        NSLog(@"============ cart store info = %@",infoDic);
        NSNumber * code = [infoDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSArray *datasArr = [infoDic objectForKey:@"datas"];
            if (datasArr.count > 0) {
                NSDictionary *dataDic = datasArr[0];
                storeInfo = [[StoreInfoItem alloc] initWithDic:dataDic];
                if (cartItem.item_id <= 3) {
                    _standardCarriage = 3.0;
                    _standardSendFee = 29.5;
                } else if (cartItem.item_id <= 6){
                    _standardCarriage = 3.0;
                    _standardSendFee = 72;
                } else {
                    _standardCarriage = storeInfo.fare;
                    _standardSendFee = storeInfo.alisa;
                }
                
                _payCarriage = _totalPrice >= _standardSendFee ? 0 : _standardCarriage;
            }
            
        }
        [self billTotalPriceHandle];
        
//        [self takeRedpackage];
        
        
    };
    reques.failureRequest = ^(NSError *error){
        _payCarriage = 0;
//        [self takeRedpackage];
    };
    
}

-(void)takeRedpackage
{
    //购物车结算是只有一家超市并且store_id符合红包规定
    if (_bills.count > 0) {
        NSMutableArray *arr = _bills[0];
        CartGoodsItem *item = arr[0];
        NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
        NSString *store_id = [storeDic objectForKey:@"store_id"];
        if (_bills.count == 1 && item.store_id == store_id.integerValue) {
            [self requestRedPacket];
        } else {
            payBtn.enabled = YES;
            _redPacket = 0;
            [_tableView reloadData];
        }
    }
}

//获取红包金额
-(void)requestRedPacket
{
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [storeDic objectForKey:@"store_id"];
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=hongbaostore"] postData:[NSString stringWithFormat:@"store_id=%d&member_id=%@",store_id.intValue,member_id]];
    request.successRequest = ^(NSDictionary *requestDic){
        payBtn.enabled = YES;
        NSNumber *code = [requestDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSNumber *ishonebao = [requestDic objectForKey:@"ishongbao"];
            NSNumber *islingqu = [requestDic objectForKey:@"islingqu"];
            NSNumber *isxiaofei = [requestDic objectForKey:@"isxiaofei"];
            if (ishonebao.integerValue == 1 && islingqu.integerValue == 1 && isxiaofei.integerValue == 0) {
                NSDictionary *dataDic = [requestDic objectForKey:@"data"];
                NSNumber *hongbao = [dataDic objectForKey:@"hongbao"];
                _redPacket = hongbao.floatValue;
                NSLog(@"======= 领取的红包金额是 ＝ %.1f",_redPacket);
            }
        }
        [_tableView reloadData];
    };
    request.failureRequest = ^(NSError *error){
        payBtn.enabled = YES;
    };
}


-(void)payBillPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#define kBottomView_height 50
#define kPayBtn_width 80
#define kPayBtn_height 40

-(void)addTableViewOnPayBillVC
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-64-kBottomView_height) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_height-kBottomView_height, kScreen_width, kBottomView_height)];
    bottomView.backgroundColor = kBackgroundColor;
    [self.view addSubview:bottomView];
    
    payBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    payBtn.frame = CGRectMake(kScreen_width-15-kPayBtn_width, 0, kPayBtn_width, kPayBtn_height);
    payBtn.layer.cornerRadius = 5;
    payBtn.centerY = bottomView.height/2;
    payBtn.backgroundColor = kRedColor;
    [payBtn setTitle:@"我要支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payBillAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:payBtn];
    _totalPriceL = [[UILabel alloc] initWithFrame:CGRectMake(payBtn.left -150, 0, 150, 30)];
    _totalPriceL.centerY = bottomView.height/2;
    _totalPriceL.text = @"合计:¥0.0";
    _totalPriceL.textColor = kRedColor;
    _totalPriceL.textAlignment = NSTextAlignmentCenter;
    _totalPriceL.font = [UIFont boldSystemFontOfSize:kFontSize_1];
    [bottomView addSubview:_totalPriceL];
    [self billTotalPriceHandle];
}


-(void)payBillAction
{
    if (_standardSendFee > 0 && _standardCarriage <= 0 && _totalPrice < _standardSendFee) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"亲,您的结算金额不足%.1f的起送价",_standardSendFee] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [self payBillRightNow];
    
}

-(void)payBillRightNow
{
    if (!_isPaying) {
        if (_address.length==0 || _name.length==0 || _phoneNum==0) {
            [self.view makeToast:@"请将收货信息填写完整" duration:1.5 position:@"center"];
        } else {
            if ([[YanMethodManager defaultManager] validateMobile:_phoneNum]) {
                [YanMethodManager showIndicatorOnView:_tableView];
                shopcarids = nil;
                goodsnums = nil;
                CartGoodsItem *tempItem = _bills[0][0];
                for (int i = 0; i < _bills.count; i++) {
                    NSMutableArray *array = _bills[i];
                    for (int j = 0; j < array.count; j++) {
                        CartGoodsItem *item = array[j];
                        if (i == 0 && j == 0) {
                            shopcarids = [NSString stringWithFormat:@"%ld",(long)item.shopcar_id];
                            goodsnums = [NSString stringWithFormat:@"%ld",(long)item.number];
                        } else {
                            shopcarids = [shopcarids stringByAppendingString:[NSString stringWithFormat:@",%ld",(long)item.shopcar_id]];
                            goodsnums = [goodsnums stringByAppendingString:[NSString stringWithFormat:@",%ld",(long)item.number]];
                        }
                    }
                }
                //                NSLog(@"======= shopcarids = %@ \n nums = %@",shopcarids,goodsnums);
                
//                NSString *carrageStoreIds;
//                for (int i = 0; i < _carriage_storeIDs.count; i++) {
//                    if (i == 0) {
//                        carrageStoreIds = _carriage_storeIDs[i];
//                    } else {
//                        carrageStoreIds = [carrageStoreIds stringByAppendingString:[NSString stringWithFormat:@",%@",_carriage_storeIDs[i]]];
//                    }
//                }
                
                payBtn.enabled = NO;
                NetWorkRequest *request = [[NetWorkRequest alloc] init];
                NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
                NSString *params = [NSString stringWithFormat:@"shopcarids=%@&goodsnums=%@&member_id=%@&total_fee=%.2f&con_address=%@&consigner=%@&conmobile=%@&conremark=%@&hongbao=%.1f&cost_score=%d&store_ids=%ld&couponid=%@",shopcarids,goodsnums,member_id,_totalPrice,_address,_name,_phoneNum,_remark,_redPacket,0,tempItem.store_id,_couponID];
                [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addshopcarorder"] postData:params];
                request.successRequest = ^(NSDictionary *requestDic){
                    NSLog(@"========== request dic = %@",requestDic);
                    
                    [YanMethodManager hideIndicatorFromView:_tableView];
                    _isPaying = NO;
                    payBtn.enabled = YES;
                    NSNumber *code = [requestDic objectForKey:@"code"];
                    if (code.integerValue == 200) {
                        _payCommenArr = [requestDic objectForKey:@"datas"];
                        NSDictionary *itemdic = _payCommenArr[0];
                        sucTime = [NSString stringWithFormat:@"%@",[itemdic objectForKey:@"add_time"]];
                        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
                        [actionSheet showInView:self.view];
                    }
                    
                    if (code.integerValue == 120) {
                        [self.view makeToast:@"系统繁忙,请稍候重试" duration:1.0 position:@"center"];
                    }
                };
                request.failureRequest = ^(NSError *error){
                    [YanMethodManager hideIndicatorFromView:_tableView];
                    _isPaying = NO;
                    payBtn.enabled = YES;
                };
                
            } else {
                [self.view makeToast:@"请填写正确的手机号码" duration:1.5 position:@"center"];
            }
        }
    }
}

#pragma mark TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _bills.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }
    NSMutableArray *rowArr = _bills[section - 1];
    return rowArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40;
    }
    return 80;
}

#define kTable_header_height 35
#define kTable_footer_height 40

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        NSMutableArray *rowArr = _bills[section-1];
        CartGoodsItem *item = rowArr[0];
        PayBillHeaderView *sectionHeader = [[PayBillHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kTable_header_height) title:item.store_name];
        sectionHeader.remarkBlock = ^(PayBillHeaderView *headerView, UIButton *button){
            [button removeFromSuperview];
            button = nil;
            UITextView *remartTV = [[UITextView alloc] initWithFrame:CGRectMake(100, 5, kScreen_width-75-30, headerView.height-10)];
            [remartTV becomeFirstResponder];
            remartTV.tag = 900 + section;
            remartTV.delegate = self;
            [headerView addSubview:remartTV];
        };
        return sectionHeader;
    }
    return nil;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

-(void)billTotalPriceHandle
{
    _totalPrice = 0;
    for (int i = 0; i < _bills.count; i++) {
        NSMutableArray *rowArr = _bills[i];
        for (int j = 0; j < rowArr.count; j++) {
            CartGoodsItem *item = rowArr[j];
            _totalPrice += item.number * [NSString stringWithFormat:@"%.2f",item.price].floatValue;
        }
    }
    
    float tempTotal = _totalPrice+_payCarriage-_discountCoupon;
    _totalPriceL.text = [NSString stringWithFormat:@"实付:¥%.2f",tempTotal];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (int i = 0; i < 910; i++) {
        UITextView *textView = (UITextView *)[self.view viewWithTag:i];
        [textView resignFirstResponder];
    }
    for (int i = 0; i < 4; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        PayTableViewCell *payCell = (PayTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        [payCell.payTF resignFirstResponder];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        return 35;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        static NSString *payBill = @"payBill";
        PayBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:payBill];
        if (!cell) {
            cell = [[PayBillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:payBill];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSMutableArray *rowArr = _bills[indexPath.section-1];
        CartGoodsItem *item = rowArr[indexPath.row];
        cell.goodsItem = item;
        return cell;
    }
   static NSString *payAdress = @"adress";
    PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:payAdress];
    if (!cell) {
        cell = [[PayTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:payAdress];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self addressCellHandleWithCell:cell indexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //查看地址
    if (indexPath.section == 0 && indexPath.row == 0) {
        ShipAddressViewController *shipVC = [[ShipAddressViewController alloc] init];
        [self.navigationController pushViewController:shipVC animated:YES];
    }
    //查看会员在这个商户可用的优惠券
    if (indexPath.section == 0 && indexPath.row == 5) {
        if (!_couponUsed) {
            CartGoodsItem *item = _bills[0][0];
            CanUsedCouponViewController *usedCouponVC = [[CanUsedCouponViewController alloc] init];
            usedCouponVC.store_id = item.store_id;
            usedCouponVC.totalPrice = _totalPrice;
            usedCouponVC.discountCouponBlock = ^(float couponAmount, NSString *couponid){
                _discountCoupon = couponAmount;
                _couponID = couponid;
                [self billTotalPriceHandle];
                [_tableView reloadData];
            };
            [self.navigationController pushViewController:usedCouponVC animated:YES];
        } else {
            [self.view makeToast:@"一天只能使用一次优惠券哦!" duration:1.5 position:@"center"];
        }
    }
}

-(void)clickCellSelectCountBtn:(UIButton *)button indexPath:(NSIndexPath *)indexPath
{
    NSLog(@"======== button tag = %ld",(long)button.tag);
    PayBillTableViewCell *cell = (PayBillTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    NSInteger count = cell.selectCountV.countLabel.text.integerValue;
    if (button.tag == 560) {//-
        if (count > 1) {
            count--;
        }
    } else {//+
        count++;
    }
    cell.selectCountV.countLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
    cell.countLabel.text = [NSString stringWithFormat:@"数量:%ld",(long)count];
    NSMutableArray *rowArr = _bills[indexPath.section-1];
    CartGoodsItem *item = rowArr[indexPath.row];
    item.number = count;
    [rowArr replaceObjectAtIndex:indexPath.row withObject:item];
    [self billTotalPriceHandle];
    [_tableView reloadData];
}

-(void)addressCellHandleWithCell:(PayTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    cell.payTF.tag = 400 + indexPath.row;
    cell.payTF.delegate = self;
    switch (indexPath.row) {
        case 0:{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.titleL.text = @"收货地址:";
            cell.payTF.text = _address;
            cell.payTF.placeholder = @"请输入收货地址";
        }
            break;
        case 1:{
            cell.titleL.text = @"收货人:";
            cell.payTF.text = _name;
            cell.payTF.placeholder = @"收货人姓名";
        }
            break;
        case 2:{
            cell.titleL.text = @"联系电话:";
            cell.payTF.text = _phoneNum;
            cell.payTF.placeholder = @"请输入您的手机号码";
        }
            break;
        case 3:{
            cell.titleL.text = @"订单总额:";
            cell.payTF.text = [NSString stringWithFormat:@"¥%.2f",_totalPrice];
            cell.payTF.textColor = kRedColor;
            cell.payTF.enabled = NO;
        }
            break;
        case 4:{
            cell.titleL.text = @"运费:";
            cell.payTF.text = [NSString stringWithFormat:@"¥%.1f",_payCarriage];
            cell.payTF.textColor = kRedColor;
            cell.payTF.enabled = NO;
        }
            break;
//        case 5:{
//            cell.titleL.text = @"红包:";
//            cell.payTF.text = [NSString stringWithFormat:@"¥%.1f",_redPacket];
//            cell.payTF.textColor = kRedColor;
//            cell.payTF.enabled = NO;
//            UIButton *packageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//            packageBtn.frame = CGRectMake(kScreen_width-15-20, 0, 25, 25);
//            packageBtn.centerY = cell.titleL.centerY;
//            [packageBtn addTarget:self action:@selector(packageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//            NSString *imageName = _useRedPackage ? @"selected" : @"noSelected";
//            [packageBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//            [cell.contentView addSubview:packageBtn];
//        }
//            break;
        case 5:{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.titleL.hidden = YES;
            cell.payTF.hidden = YES;
            cell.textLabel.font = [UIFont systemFontOfSize:kFontSize_2];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:kFontSize_3];
            NSString *string = [NSString stringWithFormat:@"可使用优惠券(%ld张)",_couponCount];
            cell.textLabel.attributedText = [[YanMethodManager defaultManager] attributStringWithColor:kRedColor text:string specialStr:[NSString stringWithFormat:@"%ld张",_couponCount]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.1f",_discountCoupon];
        }
            break;
        default:
            break;
    }
}

//-(void)packageBtnAction:(UIButton *)button
//{
//    if (_totalPrice > _redPacket) {
//        _useRedPackage = !_useRedPackage;
//        if (_useRedPackage) {
//            [button setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
//        } else {
//            [button setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
//        }
//        [self billTotalPriceHandle];
//    } else {
//        [self.view makeToast:@"您的结算金额不足使用红包" duration:1.5 position:@"center"];
//    }
//    
//}

#pragma mark UITextField 
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 400:{
            _address = textField.text;
        }
            break;
        case 401:{
            _name = textField.text;
        }
            break;
        case 402:{
            _phoneNum = textField.text;
        }
            break;
        case 403:{
            _remark = textField.text;
        }
            break;
            
        default:
            break;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self billTotalPriceHandle];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    switch (buttonIndex) {
        case 0:{//支付宝
            _payType = @"支付宝";
            [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=getalipay"] postData:nil];
            request.successRequest = ^(NSDictionary *aliDic){
                NSLog(@"=========== 支付宝 ＝ %@",aliDic);
                NSNumber *codeNum = [aliDic objectForKey:@"code"];
                if (codeNum.intValue == 200) {
                    NSDictionary *dataDic = [aliDic objectForKey:@"datas"];
                    [self aliPayHandleWithDic:dataDic];
                }
            };
        }
            break;
        case 1:{//微信
            if ([WXApi isWXAppInstalled]) {
                _payType = @"微信";
                [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=getweixinpay"] postData:nil];
                request.successRequest = ^(NSDictionary *wxDic){
                    NSLog(@"========= wx = %@",wxDic);
                    NSNumber *codeNum = [wxDic objectForKey:@"code"];
                    if (codeNum.intValue == 200) {
                        NSDictionary *dataDic = [wxDic objectForKey:@"datas"];
                        payRequsestHandler *req = [[payRequsestHandler alloc] init];
                        NSString *app_id = [dataDic objectForKey:@"mempid_wxpay"];
                        NSString *mch_id = [dataDic objectForKey:@"wxPartnerId"];
                        NSString *partner_id = [dataDic objectForKey:@"wxPartnerKey"];
                        [req init:app_id mch_id:mch_id];
                        [req setKey:partner_id];
                        //                    float totalPrice = _count.intValue * _price.floatValue;
                        NSDictionary *payDic = _payCommenArr[0];
                        NSString *goodsName = [@"购物车" stringByAppendingString:[payDic objectForKey:@"order_sn"]];
                        float payTotal = _totalPrice + _payCarriage - _discountCoupon;
                        NSInteger amount = payTotal * 100;
                        sucPay = amount/100.0;
                        NSMutableDictionary *dict = [req sendPay_demo:app_id mch_id:mch_id order_name:goodsName order_price:[NSString stringWithFormat:@"%ld",(long)amount] receive_URL:kwxCallBackUrl trade_sn:[payDic objectForKey:@"order_sn"]];
                        [self wxPayHandleWithDic:dict];
                    }
                };
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有安装微信,请前往appStore下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 1200;
                [alert show];
            }
            
        }
            break;
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1200) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"]];
        }
    }
}

-(void)wxPayHandleWithDic:(NSMutableDictionary *)dict
{
    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [dict objectForKey:@"appid"];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [dict objectForKey:@"package"];
    req.sign                = [dict objectForKey:@"sign"];
    
    [WXApi sendReq:req];
    
}

-(void)changeCartBadgeValueWhenPayed
{
    NSString *cartCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"local_cartGoodsCount"];
    if (cartCount != NULL) {
        
        for (UINavigationController *navi in self.tabBarController.viewControllers) {
            if ([navi.topViewController isKindOfClass:[CartViewController class]]) {
                if (cartCount.integerValue-_bills.count > 0) {
                    navi.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",cartCount.integerValue-_bills.count];
                } else {
                    navi.tabBarItem.badgeValue = nil;
                }
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",cartCount.integerValue-_bills.count] forKey:@"local_cartGoodsCount"];
            }
        }
    }
}

-(void)wxNotiHandle:(NSNotification *)noti
{
    NSDictionary *info = noti.userInfo;
    BaseResp *resp = [info objectForKey:@"resp"];
    switch (resp.errCode) {
        case WXSuccess:
            if (self.paySuccessBlock) {
                self.paySuccessBlock();
            }
            [self paySuccessCallBackWithType:_payType];
            break;
        case WXErrCodeUserCancel:{
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.window makeToast:@"您的订单已取消支付" duration:1.5 position:@"center"];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            [self.view makeToast:@"支付失败,请重新支付" duration:1.5 position:@"center"];
            break;
    }
}

//支付宝支付
-(void)aliPayHandleWithDic:(NSDictionary *)dic
{
    NSString *partner = [NSString stringWithFormat:@"%@",[dic objectForKey:@"mempid_alipay"]];
    NSString *seller = [dic objectForKey:@"memreceive_alipay"];
    NSDictionary *payDic = _payCommenArr[0];
    if (partner.length == 0 || seller.length == 0) {
        [self.view makeToast:@"由于网络原因支付无法完成,请稍候重试" duration:1.5 position:@"center"];
    } else {
        Order *order = [[Order alloc] init];
        order.partner = partner;
        order.seller = seller;
        order.tradeNO = [payDic objectForKey:@"order_sn"];
        order.productName = [payDic objectForKey:@"item_name"];
        order.productDescription = [payDic objectForKey:@"item_name"];
        float payTotal = _totalPrice+_payCarriage-_discountCoupon;
        sucPay = payTotal;
        payTotal = 0.01;
        order.amount = [NSString stringWithFormat:@"%.2f",payTotal];
        order.notifyURL = kaliCallBackUrl;
        
        order.service = @"mobile.securitypay.pay";
        order.paymentType = @"1";
        order.inputCharset = @"utf-8";
        order.itBPay = @"30m";
        order.showUrl = @"m.alipay.com";
        
        NSString *appScheme = @"Iso2o";
        //将商品信息拼接成字符串
        NSString *orderSpec = [order description];
        
        //支付宝私钥
        NSString *privateKey = [dic objectForKey:@"mempkcs_alipay"];
        id<DataSigner>signer = CreateRSADataSigner(privateKey);
        NSString *signedString = [signer signString:orderSpec];
        
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec,signedString,@"RSA"];
        //        NSLog(@"========= orderstring = %@",orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSNumber *code = [resultDic objectForKey:@"resultStatus"];
            if (code.integerValue == 9000) {//成功
                NSLog(@"====== 支付成功");
                if (self.paySuccessBlock) {
                    self.paySuccessBlock();
                }
                [self paySuccessCallBackWithType:_payType];
            } else if (code.integerValue == 4000) {//支付失败
                [self.view makeToast:@"您的订单支付失败,请重新支付" duration:1.5 position:@"center"];
            } else if (code.integerValue == 6001){//用户取消
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.window makeToast:@"您的订单已取消支付" duration:1.5 position:@"center"];
                [self.navigationController popViewControllerAnimated:YES];
            } else if (code.integerValue == 6002){//网络连接失败
                [self.view makeToast:@"由于网络原因您的订单支付失败,请重新支付" duration:1.5 position:@"center"];
            } else {//正在处理
                [self.view makeToast:@"系统正在处理您的订单,请耐心等待" duration:1.5 position:@"center"];
            }
        }];
    }
}

-(void)successCallBackRequest:(int)paytype
{
    NSDictionary *payDic = _payCommenArr[0];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    
    CGFloat paraRedPacket = _useRedPackage ? _discountCoupon : 0;
    
    NSString *para = [NSString stringWithFormat:@"order_sn=%@&total_fees=%.2f&cost_score=%d&pay_type=%d&shopcarid=%@&hongbao=%.1f",[payDic objectForKey:@"order_sn"],_totalPrice,_cost_score,paytype,shopcarids,paraRedPacket];
    NSLog(@"===== para = %@",para);
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=updatestatus"] postData:para];
    request.successRequest = ^(NSDictionary *successDic){
        NSLog(@"============ success dic = %@",successDic);
        
        [self billSuccessLaterHandleWithPayType:@"支付宝"];
        NSNumber *code = [successDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSDictionary *datasDic = [successDic objectForKey:@"datas"];
            NSString *eitherSucc = [datasDic objectForKey:@"success"];
            if ([eitherSucc isEqualToString:@"true"]) {
                [self.view makeToast:@"您的订单已提交,商品正在配送中!" duration:1.5 position:@"center"];
            }
        }
    };
}


//支付成功后跳页
-(void)billSuccessLaterHandleWithPayType:(NSString *)type
{
    PaySuccessViewController *paySucVC = [[PaySuccessViewController alloc] init];
    paySucVC.paySuccessBlock = ^{
        _couponID = @"";
        _discountCoupon = 0.0;
        //获取对应超市内可用的优惠券的数量
        _couponCount = 0;
        [self billTotalPriceHandle];
    };
    paySucVC.memberName = _name;
    paySucVC.phoneNum = _phoneNum;
    paySucVC.sendGoodsAddress = _address;
    paySucVC.receiveOrderTime = [[YanMethodManager defaultManager] getShortDateFromTime:sucTime];
    paySucVC.moneyToPay = [NSString stringWithFormat:@"%.2f",sucPay];
    paySucVC.transportePay = [NSString stringWithFormat:@"%.2f",_payCarriage];
    paySucVC.payMethodString = type;
    [self.navigationController pushViewController:paySucVC animated:YES];
}

-(void)paySuccessCallBackWithType:(NSString *)type
{
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    NSDictionary *payDic = _payCommenArr[0];
    NSNumber *order_sn = [payDic objectForKey:@"order_sn"];
    NSLog(@"order_sn:%@",order_sn);
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=findorderstatus"] postData:[NSString stringWithFormat:@"order_sn=%@",order_sn]];
    request.successRequest = ^(NSDictionary *callBackDic){
        
        NSNumber *code = [callBackDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSLog(@"++++++++++---------%@",callBackDic);
            NSDictionary *datasDic = [callBackDic objectForKey:@"datas"];
            NSString *payStatus = [datasDic objectForKey:@"paystatus"];
            if ([payStatus isEqualToString:@"success"]) {
                [self changeCartBadgeValueWhenPayed];//付款成功后更改badgeValue
                [self billSuccessLaterHandleWithPayType:type];
                [_callBakcTimer invalidate];
                _callBakcTimer = nil;
            } else {
                ++_timeCount;
                if (!_callBakcTimer) {
                    _callBakcTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(callBakcTimerAction:) userInfo:nil repeats:YES];
                    // 3秒后销毁定时器
                }
            }
        }
    };
}

-(void)callBakcTimerAction:(NSTimer *)timer
{
    if (_timeCount > 3) {
        [self requestCouponCount];
        _discountCoupon = 0.0;
        [_tableView reloadData];
        [_callBakcTimer invalidate];
        _callBakcTimer = nil;
    } else {
        [self paySuccessCallBackWithType:_payType];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxNotiHandle:) name:@"wxPay_noti" object:nil];
    
    NSDictionary *addressDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"consignee_address"];
    _couponUsed = NO;
    if (addressDic != NULL) {
        _address = [addressDic objectForKey:@"address"];
        _name = [addressDic objectForKey:@"consiger"];
        _phoneNum = [addressDic objectForKey:@"mobile"];
    }
    _timeCount = 0;
    
    [self requestCouponCount];
    [_tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
    [TalkingData trackPageEnd:@"购物车结算页面"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [TalkingData trackPageBegin:@"购物车结算页面"];
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
