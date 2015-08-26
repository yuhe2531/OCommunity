//
//  OrderDetailTableViewCell.h
//  OCommunity
//
//  Created by runkun2 on 15/7/21.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"
@interface OrderDetailTableViewCell : UITableViewCell
@property(nonatomic,copy)NSString *OrderNumber;//订单号
@property(nonatomic,copy)NSString *OrderTime;//下单时间
@property(nonatomic,copy)NSString *MethodOfPay;//支付方式
@property(nonatomic,copy)NSString *contactMember;//联系人
@property(nonatomic,copy)NSString *MemberPhoneNum;//手机号码
@property(nonatomic,copy)NSString *OrderAddress;//收货地址
@property(nonatomic,copy)OrderDetailModel *orderDetailModel;
@end
