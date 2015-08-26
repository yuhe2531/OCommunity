//
//  PayRightNowViewController.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface PayRightNowViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *market_name;
@property (nonatomic, assign) int goods_id;
@property (nonatomic, assign) int store_id;
@property (nonatomic, assign) BOOL isHotGoods;

@property (nonatomic, assign) float standardSendFee;//起送价
@property (nonatomic, assign) float carriageFee;//运费（商户设定）

@end
