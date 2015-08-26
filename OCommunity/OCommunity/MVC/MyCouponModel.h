//
//  MyCouponModel.h
//  OCommunity
//
//  Created by runkun3 on 15/7/31.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCouponModel : NSObject
@property(nonatomic,assign)float amount;//优惠券金额
@property (nonatomic,copy)NSString *start_time;//优惠券有效期的开始时间
@property (nonatomic,copy)NSString *end_time;//优惠券有效期的结束时间
@property (nonatomic,assign)int type; //类型为2表示面向商户
@property (nonatomic,copy)NSString *store_id;
@property (nonatomic,copy)NSString *total;//优惠券可领取的数量，默认为0
@property (nonatomic,assign)float got_count;//领取的优惠券数量
@property (nonatomic, assign)float use_count;//使用的优惠券数量
@property (nonatomic,assign)float xianzhi;//限制使用额度，默认为0
@property (nonatomic,assign)float is_use;
@property (nonatomic,assign)int is_guoqi;//是否过期
@property (nonatomic,copy)NSString *coupon_id;
@property (nonatomic, copy) NSString *store_name;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
-(id)initWithDictionary:(NSDictionary *)dic;


@end
