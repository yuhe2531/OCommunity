//
//  PayRightNowViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "PayRightNowViewController.h"
#import "PayTableViewCell.h"
#import "ShipAddressViewController.h"
#import "SelectCountView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "StoreInfoItem.h"
#import "payRequsestHandler.h"
#import "LoginViewController.h"
#import "PaySuccessViewController.h"
#import "AppDelegate.h"
#import "CanUsedCouponViewController.h"

#define kFootViewHeight 40

@interface PayRightNowViewController ()

{
    UIPickerView *picker;
    UIView *pickerSuperView;
    UIButton *payBtn;
    float sucPay;//成功支付后的实付金额
    NSString *sucTime;//成功支付后的订单生成时间
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *payDic;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, assign) BOOL isPayNil;
@property (nonatomic, assign) BOOL isPaying;
@property (nonatomic, assign) int local_pointCash;
@property (nonatomic, strong) NSTimer *callBakcTimer;
@property (nonatomic, strong) StoreInfoItem *storeInfoItem;

@property (nonatomic, assign) BOOL userRedPackage;//是否使用红包
@property (nonatomic, assign) float redPackage;//红包金额
@property (nonatomic, assign) float standarCarriageFee;

@property (nonatomic, copy) NSString *payType;

@property (nonatomic, assign) float discountCoupon;
@property (nonatomic, copy) NSString *coupon_id;
@property (nonatomic, assign) NSInteger couponCount;

@property (nonatomic, assign) int timeCount;

@end

@implementation PayRightNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _isPayNil = YES;
    _isPaying = NO;
    _userRedPackage = NO;
    
    _timeCount = 0;
    _coupon_id = @"";
    _discountCoupon = 0.0;
    _couponCount = 0;
    
    NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *localPoint = [storeDic objectForKey:@"jfdk"];
    _local_pointCash = localPoint.intValue;
    
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"确认订单"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(payRightNowPop)];
    
    if (_store_id == 0) {
        NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
        NSString *store_id = [storeDic objectForKey:@"store_id"];
        _store_id = store_id.intValue;
    }
    NSLog(@"============= store id = %d",_store_id);
    if (_count == nil) {
        _count = @"1";
    }
    
//////////////*************************////////////////////
//    _price = @"0.01";
//    _count = @"1";
//    _goods_name = @"达利蛋黄派";
//    _goods_id = 1891;
//    _store_id = 29;
//    _market_name = @"零步社区";
//////////////*************************////////////////////
   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";

    [self requestFareAndalisa];//获取超市运费／起送价
    
    
    // Do any additional setup after loading the view.
}

//请求在对应超市内可用的优惠券
-(void)requestCouponCount
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api_coupon.php?commend=member_coupons_isok"] postData:[NSString stringWithFormat:@"member_id=%@&store_id=%d",member_id,_store_id]];
    request.successRequest = ^(NSDictionary *couponDic){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"=============== request coupon = %@",couponDic);
        NSNumber *code = [couponDic objectForKey:@"code"];
        if (code.integerValue == 200) {
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
        [self.view makeToast:@"网络异常,下拉重新获取数据" duration:1.0 position:@"center"];
    };
}


//获取超市运费／起送价
-(void)requestFareAndalisa
{
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=findstoreinfo"] postData:[NSString stringWithFormat:@"store_id=%d",_store_id]];
    request.successRequest = ^(NSDictionary *requestDic){
        NSLog(@"============== 运费／起送价 ＝ %@",requestDic);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSNumber * code = [requestDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSArray *datasArr = [requestDic objectForKey:@"datas"];
            if (datasArr.count > 0) {
                NSDictionary *dataDic = datasArr[0];
                _storeInfoItem = [[StoreInfoItem alloc] initWithDic:dataDic];
                float totalPrice = _count.floatValue * _price.floatValue;
                
                if (!_isHotGoods) {
                    _standarCarriageFee = _storeInfoItem.fare;
                    _standardSendFee = _storeInfoItem.alisa;
                    _carriageFee = totalPrice >= _standardSendFee ? 0 : _standarCarriageFee;
                } else {
                    _standarCarriageFee = _carriageFee;
                    _carriageFee = totalPrice >= _standardSendFee ? 0 : _standarCarriageFee;
                }
            }
            [self addTableViewOnPay];
            //获取红包
//            [self requestRedPacket];
        }
    };
    request.failureRequest = ^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    };
}

////获取红包
//-(void)requestRedPacket
//{
//    NetWorkRequest *request = [[NetWorkRequest alloc] init];
//     NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
//    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=hongbaostore"] postData:[NSString stringWithFormat:@"store_id=%d&member_id=%@",_store_id,member_id]];
//    request.successRequest = ^(NSDictionary *requestDic){
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        NSNumber *code = [requestDic objectForKey:@"code"];
//        if (code.integerValue == 200) {
//            NSNumber *ishonebao = [requestDic objectForKey:@"ishongbao"];
//            NSNumber *islingqu = [requestDic objectForKey:@"islingqu"];
//            NSNumber *isxiaofei = [requestDic objectForKey:@"isxiaofei"];
//            if (ishonebao.integerValue == 1 && islingqu.integerValue == 1&&isxiaofei.integerValue == 0) {
//                NSDictionary *dataDic = [requestDic objectForKey:@"data"];
//                if ([dataDic isKindOfClass:[NSNull class]] == NO){
//                NSNumber *hongbao = [dataDic objectForKey:@"hongbao"];
//                _redPackage = hongbao.floatValue;
//                }
//                NSLog(@"======= 领取的红包金额是 ＝ %.1f",_redPackage);
//            }
//        }
//        [self addTableViewOnPay];
//    };
//    request.failureRequest = ^(NSError *error){
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        [self addTableViewOnPay];
//    };
//}

-(void)payRightNowPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addTableViewOnPay
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 80)];
    payBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    payBtn.frame = CGRectMake(0, 30, kScreen_width-80, 40);
    payBtn.centerX = footer.width/2;
    payBtn.backgroundColor = kRedColor;
    payBtn.layer.cornerRadius = 5;
    [payBtn setTitle:@"在线支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:payBtn];
    _tableView.tableFooterView = footer;
}

//生成订单
-(void)requestOrderData
{
    payBtn.enabled = NO;
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    UITextField *tf1 = (UITextField *)[self.view viewWithTag:290];
    UITextField *tf2 = (UITextField *)[self.view viewWithTag:291];
    UITextField *tf3 = (UITextField *)[self.view viewWithTag:292];
    UITextField *tf4 = (UITextField *)[self.view viewWithTag:293];

    SelectCountView *selectView = (SelectCountView *)[self.view viewWithTag:700];
    float totalPrice = _count.floatValue * _price.floatValue;
    
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    NSString *paregram = [NSString stringWithFormat:@"goods_id=%d&member_id=%@&quantity=%@&goods_name=%@&store_id=%d&store_name=%@&total_fee=%.2f&con_address=%@&consigner=%@&conmobile=%@&conremark=%@&hongbao=%.1f&cost_score=%d&price=%@&fare=%.1f&couponid=%@",_goods_id,member_id,selectView.countLabel.text,_goods_name,_store_id,_market_name,totalPrice,tf1.text,tf2.text,tf3.text,tf4.text,_redPackage,0,_price,_carriageFee,_coupon_id];
    NSLog(@"============= total price = %@",paregram);
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addordergoods"] postData:paregram];
    request.successRequest = ^(NSDictionary *requestDic){
        NSLog(@"====== make order pay = %@",requestDic);
        payBtn.enabled = YES;
        _isPaying = NO;
        NSNumber *codeNum = [requestDic objectForKey:@"code"];
        if (codeNum.intValue == 200) {
            _payDic = [requestDic objectForKey:@"datas"];
            sucTime = [NSString stringWithFormat:@"%@",[_payDic objectForKey:@"add_time"]];
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
            [actionSheet showInView:self.view];
        }
        
        if (codeNum.integerValue == 120) {
            [self.view makeToast:@"系统繁忙,请稍候重试" duration:1.0 position:@"center"];
        }
    };
    request.failureRequest = ^(NSError *error){
        _isPaying = NO;
        payBtn.enabled = YES;
    };
}

-(void)payBtnAction:(id)sender
{
    float totalPrice = _count.floatValue * _price.floatValue;
    if (totalPrice < _standardSendFee && _carriageFee <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"亲,您的结算金额不足%.1f起送价哦",_standardSendFee] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [self payRightNow];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"]];
        }
    }
}

-(void)payRightNow
{
    if (!_isPaying) {
        UITextField *tf1 = (UITextField *)[self.view viewWithTag:290];
        UITextField *tf2 = (UITextField *)[self.view viewWithTag:291];
        UITextField *tf3 = (UITextField *)[self.view viewWithTag:292];
        //    UITextField *tf4 = (UITextField *)[self.view viewWithTag:293];
        if (tf1.text.length < 1 || tf2.text.length < 1 || tf3.text.length < 1) {
            [self.view makeToast:@"请将收货信息填写完整" duration:1.5 position:@"center"];
        } else {
            if ([[YanMethodManager defaultManager] validateMobile:tf3.text] == NO) {
                [self.view makeToast:@"请填写正确的手机号码" duration:1.5 position:@"center"];
            }  else {
                [self requestOrderData];
            }
        }
    }
}

#pragma mark UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *pay = @"payNOw";
    PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pay];
    if (!cell) {
        cell = [[PayTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:pay];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.payTF.delegate = self;
    [self payCellHandleWithIndexPath:indexPath cell:cell];
    return cell;
}

-(void)payCellHandleWithIndexPath:(NSIndexPath *)indexPath cell:(PayTableViewCell *)cell
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.payTF.text = _address;
                cell.payTF.placeholder = @"请输入您的收货地址";
                cell.titleL.text = @"收货地址:";
                cell.payTF.tag = 290;
            }
                break;
            case 1:{
                cell.payTF.text = _name;
                cell.payTF.placeholder = @"收货人姓名";
                cell.titleL.text = @"收货人:";
                cell.payTF.tag = 291;
            }
                break;
            case 2:{
//                cell.payTF.keyboardType = UIKeyboardTypePhonePad;
                cell.payTF.text = _phoneNum;
                cell.payTF.placeholder = @"请输入电话号码";
                cell.titleL.text = @"联系电话:";
                cell.payTF.tag = 292;
            }
                break;
            case 3:{
                cell.payTF.text = _remark;
                cell.payTF.placeholder = @"嘱咐我两句";
                cell.titleL.text = @"备     注:";
                cell.payTF.tag = 293;
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:{
                cell.titleL.text = @"商    品:";
                cell.payTF.text = _goods_name;
                cell.payTF.enabled = NO;
            }
                break;
            case 1:{
                cell.titleL.text = @"单    价:";
                cell.payTF.text = [NSString stringWithFormat:@"¥%@",_price];
                cell.payTF.enabled = NO;
            }
                break;
            case 2:{
                cell.titleL.text = @"数    量:";
                cell.payTF.text = _count;
                cell.payTF.enabled = NO;
                
                SelectCountView *selectView = [[SelectCountView alloc] initWithFrame:CGRectMake(kScreen_width-15-110, 5, 110, 40-10)];
                selectView.countLabel.text = _count;
                selectView.tag = 700;
                selectView.minusBtn.tag = 500;
                selectView.plusBtn.tag = 501;
                [selectView.minusBtn addTarget:self action:@selector(selectCountAction:) forControlEvents:UIControlEventTouchUpInside];
                [selectView.plusBtn addTarget:self action:@selector(selectCountAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:selectView];
                
            }
                break;
            case 3:{
                cell.titleL.text = @"订单总额:";
                float totalPrice = _count.floatValue * _price.floatValue;
                cell.payTF.text = [NSString stringWithFormat:@"¥%.2f",totalPrice];
                cell.payTF.textColor = kRedColor;
                cell.payTF.enabled = NO;
            }
                break;
            case 4:{
                cell.titleL.text = @"运费:";
                cell.payTF.text = [NSString stringWithFormat:@"¥%.1f",_carriageFee];
                cell.payTF.textColor = kRedColor;
                cell.payTF.enabled = NO;
    }
                break;
//            case 5:{
//                cell.titleL.text = @"红包:";
//                cell.payTF.text = [NSString stringWithFormat:@"¥%.1f",_redPackage];
//                cell.payTF.textColor = kRedColor;
//                cell.payTF.enabled = NO;
//                UIButton *packageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//                packageBtn.frame = CGRectMake(kScreen_width-15-20, 0, 25, 25);
//                packageBtn.centerY = cell.titleL.centerY;
//                [packageBtn addTarget:self action:@selector(payrightpackageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//                NSString *imageName = _userRedPackage ? @"selected" : @"noSelected";
//                [packageBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//                [cell.contentView addSubview:packageBtn];
//
//            }
//                break;
            case 5:{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.titleL.hidden = YES;
                cell.payTF.hidden = YES;
                cell.textLabel.font = [UIFont systemFontOfSize:kFontSize_2];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:kFontSize_3];
                NSString *couponCountStr = [NSString stringWithFormat:@"可使用优惠券(%ld张)",_couponCount];
                cell.textLabel.attributedText = [[YanMethodManager defaultManager] attributStringWithColor:kRedColor text:couponCountStr specialStr:[NSString stringWithFormat:@"%ld张",_couponCount]];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.1f",_discountCoupon];
            }
                break;
            case 6:{
                cell.titleL.text = @"实付金额:";
                float totalPrice = _count.floatValue * _price.floatValue;
                float tempTotal = totalPrice+_carriageFee-_discountCoupon;
                cell.payTF.text = [NSString stringWithFormat:@"¥%.2f",tempTotal];
                cell.payTF.textColor = kRedColor;
                cell.payTF.enabled = NO;
                break;
            }
                
            default:
                break;
        }
    }
}

-(void)payrightpackageBtnAction:(UIButton *)button
{
    float totalPrice = _count.floatValue * _price.floatValue;
    if (totalPrice > _redPackage) {
        _userRedPackage = !_userRedPackage;
        if (_userRedPackage) {
            [button setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        } else {
            [button setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
        }
        
    } else {
        [self.view makeToast:@"您的结算金额不足使用红包" duration:1.5 position:@"center"];
    }
    
}

-(void)selectCountAction:(UIButton *)button
{
    if (!_userRedPackage) {
        SelectCountView *selectView = (SelectCountView *)[self.view viewWithTag:700];
        PayTableViewCell *cell = (PayTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
        float count = selectView.countLabel.text.floatValue;
        float excessiveCount = 1.0;
        if (button.tag == 500) {//minus
            if (selectView.countLabel.text.floatValue > excessiveCount) {
                count -= excessiveCount;
            }
        } else {
            count += excessiveCount;
        }
        
        selectView.countLabel.text = [NSString stringWithFormat:@"%.0f",count];
        cell.payTF.text = [NSString stringWithFormat:@"%.0f",count];
        _count = [NSString stringWithFormat:@"%.0f",count];
        
        float totalPrice = _count.floatValue * _price.floatValue;
        
        _carriageFee = totalPrice >= _standardSendFee ? 0 : _standarCarriageFee;
        
        [_tableView reloadData];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return 15;
    }else{
        return kFootViewHeight;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kFootViewHeight)];
        view.backgroundColor = kColorWithRGB(253, 239, 176);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        imageView.image = [UIImage imageNamed:@"super_icon"];
        [view addSubview:imageView];
        UILabel *marketName = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right+8, 0, kScreen_width-30, view.height)];
        if (_isHotGoods) {
            _market_name = @"特色专卖店";
        }
        marketName.text = _market_name;
        marketName.font = [UIFont systemFontOfSize:kFontSize_2];
        [view addSubview:marketName];
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 && indexPath.row == 0) {
        //收货地址
        NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
        if (member_id == NULL) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.loginSuccessBlock = ^{
                ShipAddressViewController *addressVC = [[ShipAddressViewController alloc] init];
                [self.navigationController pushViewController:addressVC animated:YES];
            };
            [self.navigationController pushViewController:loginVC animated:YES];
        } else {
            ShipAddressViewController *addressVC = [[ShipAddressViewController alloc] init];
            [self.navigationController pushViewController:addressVC animated:YES];
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 5) {
        CanUsedCouponViewController *usedCouponVC = [[CanUsedCouponViewController alloc] init];
        usedCouponVC.store_id = _store_id;
        float totalPrice = _count.floatValue * _price.floatValue;
        usedCouponVC.totalPrice = totalPrice;
        usedCouponVC.discountCouponBlock = ^(float couponAmount, NSString *couponid){
            _discountCoupon = couponAmount;
            _coupon_id = couponid;
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:usedCouponVC animated:YES];
    }
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UITextField *tf1 = (UITextField *)[self.view viewWithTag:290];
    UITextField *tf2 = (UITextField *)[self.view viewWithTag:291];
    UITextField *tf3 = (UITextField *)[self.view viewWithTag:292];
    UITextField *tf4 = (UITextField *)[self.view viewWithTag:293];
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];
    [tf3 resignFirstResponder];
    [tf4 resignFirstResponder];
}

#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    switch (buttonIndex) {
        case 0:{//支付宝
            _payType = @"支付宝";
            [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=getalipay"] postData:nil];
            request.successRequest = ^(NSDictionary *aliDic){
                NSLog(@"============ 支付宝 ＝ %@",aliDic);
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
                    NSNumber *codeNum = [wxDic objectForKey:@"code"];
                    if (codeNum.intValue == 200) {
                        NSDictionary *dataDic = [wxDic objectForKey:@"datas"];
                        payRequsestHandler *req = [[payRequsestHandler alloc] init];
                        NSString *app_id = [dataDic objectForKey:@"mempid_wxpay"];
                        NSString *mch_id = [dataDic objectForKey:@"wxPartnerId"];
                        NSString *partner_id = [dataDic objectForKey:@"wxPartnerKey"];
                        [req init:app_id mch_id:mch_id];
                        [req setKey:partner_id];
                        float totalPrice = _count.floatValue * _price.floatValue;
                        NSInteger amount;
                        
                        amount = totalPrice*100-_redPackage*100 + _carriageFee*100 - _discountCoupon*100;
                        
                        sucPay = amount/100.0;
                        NSMutableDictionary *dict = [req sendPay_demo:app_id mch_id:mch_id order_name:_goods_name order_price:[NSString stringWithFormat:@"%ld",(long)amount] receive_URL:kwxCallBackUrl trade_sn:[_payDic objectForKey:@"order_sn"]];
                        [self wxPayHandleWithDic:dict];
                    }
                };
            } else {
//                [self.view makeToast:@"您还没有安装微信客户端,请先去appStore下载" duration:1.5 position:@"center"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有安装微信,请前往appStore下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 999;
                [alert show];
            }
            
        }
            break;
        default:
            break;
    }
}

//支付宝支付
-(void)aliPayHandleWithDic:(NSDictionary *)dic
{
    NSString *partner = [NSString stringWithFormat:@"%@",[dic objectForKey:@"mempid_alipay"]];
    NSString *seller = [dic objectForKey:@"memreceive_alipay"];
    if ([partner isKindOfClass:[NSNull class]]==NO && [seller isKindOfClass:[NSNull class]]==NO) {
        
        if (partner.length == 0 || seller.length == 0) {
            [self.view makeToast:@"由于网络原因支付无法完成,请稍候重试" duration:1.5 position:@"center"];
        } else {
            Order *order = [[Order alloc] init];
            order.partner = partner;
            order.seller = seller;
            order.tradeNO = [_payDic objectForKey:@"order_sn"];
            order.productName = [_payDic objectForKey:@"goods_name"];
            order.productDescription = [_payDic objectForKey:@"goods_name"];
            float totalPrice = _count.floatValue * _price.floatValue;
            //        int pointCash = _usePoints ? _cost_score/kPointForCash : 0;
            float amount;
            
            amount = totalPrice - _redPackage + _carriageFee - _discountCoupon;
            
            //        else {
            //            amount = totalPrice + _carriageFee;
            //        }
            sucPay = amount;
            order.amount = [NSString stringWithFormat:@"%.2f",amount];
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
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSNumber *code = [resultDic objectForKey:@"resultStatus"];
                if (code.integerValue == 9000) {//成功
                    
                    
                    NSLog(@"====== 支付成功");
                    [self paySuccessCallBackWithType:_payType];
                    
                    
                    
                } else if (code.integerValue == 4000) {//支付失败
                    [self.view makeToast:@"您的订单支付失败,请重新支付" duration:1.5 position:@"center"];
                } else if (code.integerValue == 6001){//用户取消
                    [self.navigationController popViewControllerAnimated:YES];
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.window makeToast:@"您的订单已取消支付" duration:1.5 position:@"center"];
                } else if (code.integerValue == 6002){//网络连接失败
                    [self.view makeToast:@"由于网络原因您的订单支付失败,请重新支付" duration:1.5 position:@"center"];
                } else {//正在处理
                    [self.view makeToast:@"系统正在处理您的订单,请耐心等待" duration:1.5 position:@"center"];
                }
            }];
        }
    }
}

//支付成功后更改订单状态
-(void)successCallBackRequest:(int)paytype
{
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    float totalPrice = _count.floatValue * _price.floatValue;
//    int pointCash = _usePoints ? _cost_score/kPointForCash : 0;
//    _cost_score = _usePoints ? (_cost_score % kPointForCash) : _cost_score;
    CGFloat paraRedPacket = _userRedPackage ? _redPackage : 0;
    NSString *para = [NSString stringWithFormat:@"order_sn=%@&total_fees=%.2f&cost_score=%d&pay_type=%d&hongbao=%.1f",[_payDic objectForKey:@"order_sn"],totalPrice,0,paytype,paraRedPacket];
     [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=updatestatus"] postData:para];
    request.successRequest = ^(NSDictionary *successDic){
        NSLog(@"============ success dic = %@",successDic);
        NSNumber *code = [successDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSDictionary *datasDic = [successDic objectForKey:@"datas"];
            NSString *eitherSucc = [datasDic objectForKey:@"success"];
            if ([eitherSucc isEqualToString:@"true"]) {
                [self successLaterHandleWithPayType:@"支付宝"];
                [self.view makeToast:@"您的订单已提交,商品正在配送中!" duration:1.5 position:@"center"];
                [_tableView reloadData];
            }
        }
    };
}

//微信支付
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

//微信支付的回调
-(void)wxPayNoti:(NSNotification *)noti
{
    NSDictionary *info = noti.userInfo;
    BaseResp *resp = [info objectForKey:@"resp"];
    switch (resp.errCode) {
            
        case WXSuccess:
            NSLog(@"========支付成功");
//
            [self paySuccessCallBackWithType:_payType];
            break;
        case WXErrCodeUserCancel:{
            [self.navigationController popViewControllerAnimated:YES];
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.window makeToast:@"您的订单已取消支付" duration:1.5 position:@"center"];
        }
            break;
            
        default:
            [self.view makeToast:@"支付失败,请重新支付" duration:1.5 position:@"center"];
            break;
    }
}

//支付成功后跳页
-(void)successLaterHandleWithPayType:(NSString *)type
{
    PaySuccessViewController *paySucVC = [[PaySuccessViewController alloc] init];
    paySucVC.paySuccessBlock = ^{
        _coupon_id = @"";
        _discountCoupon = 0.0;
        _couponCount = 0;
        [_tableView reloadData];
    };
    paySucVC.memberName = _name;
    paySucVC.phoneNum = _phoneNum;
    paySucVC.sendGoodsAddress = _address;
    paySucVC.receiveOrderTime = [[YanMethodManager defaultManager] getShortDateFromTime:sucTime];
    paySucVC.moneyToPay = [NSString stringWithFormat:@"%.1f",sucPay];
    paySucVC.transportePay = [NSString stringWithFormat:@"%.1f",_carriageFee];
    paySucVC.payMethodString = type;
    [self.navigationController pushViewController:paySucVC animated:YES];
}

-(void)paySuccessCallBackWithType:(NSString *)type
{
    
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    NSNumber *order_sn = [_payDic objectForKey:@"order_sn"];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=findorderstatus"] postData:[NSString stringWithFormat:@"order_sn=%@",order_sn]];
    request.successRequest = ^(NSDictionary *callBackDic){
        NSLog(@"========== wx paydic = %@",callBackDic);
        
        NSNumber *code = [callBackDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSDictionary *datasDic = [callBackDic objectForKey:@"datas"];
            NSString *payStatus = [datasDic objectForKey:@"paystatus"];
            if ([payStatus isEqualToString:@"success"]) {
                [self successLaterHandleWithPayType:type];
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
    NSLog(@"======== time count = %d",_timeCount);
    if (_timeCount > 3) {
        [self requestCouponCount];//获取
        _discountCoupon = 0.0;
        [_tableView reloadData];
        [_callBakcTimer invalidate];
        _callBakcTimer = nil;
    } else {
        [self paySuccessCallBackWithType:_payType];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 290:{
           _address = textField.text;
        }
            break;
        case 291:{
           _name = textField.text;
        }
            break;
        case 292:{
           _phoneNum = textField.text;
        }
            break;
        case 293:{
            _remark = textField.text;
        }
            break;
            
        default:
            break;
    }
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    NSDictionary *addressDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"consignee_address"];
    if (addressDic != NULL) {
        _address = [addressDic objectForKey:@"address"];
        _name = [addressDic objectForKey:@"consiger"];
        _phoneNum = [addressDic objectForKey:@"mobile"];
    }
    
    [self requestCouponCount];//获取
    [_tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [_tableView reloadData];
    [TalkingData trackPageBegin:@"单品结算页面"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayNoti:) name:@"wxPay_noti" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [TalkingData trackPageEnd:@"单品结算页面"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
