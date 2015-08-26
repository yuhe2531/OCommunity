//
//  OrderDetailModel.h
//  OCommunity
//
//  Created by runkun2 on 15/7/23.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

@property(nonatomic,copy)NSString *order_sn;//订单号
@property(nonatomic,copy)NSString *store_name;//商户名
@property(nonatomic,assign)float fare;//运费
@property(nonatomic,assign)int cost_score;//积分
@property(nonatomic,assign)float hongbao;//红包
@property (nonatomic,copy)NSString *add_time;//下单时间
@property(nonatomic,copy)NSString *consigner;//收货人姓名
@property(nonatomic,copy)NSString *conmobile;//手机号
@property(nonatomic,assign)int pay_type;//支付类型
@property(nonatomic,copy)NSString *member_address;//联系地址
@property(nonatomic,copy)NSString *couponamount;//优惠券

-(id)initWithDic:(NSDictionary *)dic;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
