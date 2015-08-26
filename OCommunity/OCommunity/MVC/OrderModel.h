//
//  OrderModel.h
//  OCommunity
//
//  Created by runkun3 on 15/7/23.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property (nonatomic,copy)NSString *order_sn;//订单号
@property (nonatomic,copy)NSString *add_time;//添加时间
@property (nonatomic,copy)NSString *store_name;//店铺名称
@property (nonatomic,copy)NSString *store_pic;//店铺图片
@property (nonatomic,assign)float zongjia;//商品合计价
@property (nonatomic,assign)float fare;
@property (nonatomic,assign)float hongbao;
@property (nonatomic,assign)float couponamount;//优惠券

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
-(id)initWithDic:(NSDictionary *)dic;

@end
