//
//  PaySuccessViewController.h
//  OCommunity
//
//  Created by runkun2 on 15/7/11.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PaySuccessBlock)(void);

@interface PaySuccessViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)NSString *memberName;//收货人
@property(nonatomic,copy)NSString *phoneNum;//手机号
@property(nonatomic,copy)NSString *sendGoodsAddress;//收货地址
@property(nonatomic,copy)NSString *receiveOrderTime;//下单时间
@property(nonatomic,copy)NSString *moneyToPay;//实付金额
@property(nonatomic,copy)NSString *transportePay;//运费
@property(nonatomic,copy)NSString *sendGoodsTime;//送货时间
@property(nonatomic,copy)NSString *payMethodString;//支付方式

@property (nonatomic, copy) PaySuccessBlock paySuccessBlock;

@end
