//
//  goodsClassify.h
//  OCommunity
//
//  Created by runkun2 on 15/5/21.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface goodsClassify : NSObject
@property(nonatomic,assign)int class_id;
@property(nonatomic,copy)NSString *class_name;
@property(nonatomic,copy)NSString *class_image;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_pic;
@property (nonatomic, assign) float goods_price;
@property (nonatomic, assign) int store_id;
@property(nonatomic,assign)int goods_id;
@property(nonatomic,copy)NSString *add_time;//添加的时间
@property(nonatomic, copy)NSString *store_name;
@property(nonatomic,copy)NSString *totalScore;
@property(nonatomic,copy)NSString *member_name;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *consigner;
@property(nonatomic,assign)int address_id;//已建收货地址的id
@property(nonatomic,copy)NSString *remark;//备注
@property(nonatomic,assign)double dis;//店铺距离
@property(nonatomic,assign)double store_dis;//店铺距离
@property (nonatomic, assign) int isdefault;

@property(nonatomic,copy)NSString *pic;//商户图片
@property(nonatomic,copy)NSString *lat;//纬度
@property(nonatomic,copy)NSString *lon;//经度
@property(nonatomic,copy)NSString *jfdk;//1积分抵现金额
@property(nonatomic,assign)int zje;//购物满多少送积分
@property(nonatomic,assign)int jf;//送多少积分
@property(nonatomic,copy)NSString *alisa;
@property(nonatomic,copy)NSString *store_address;
@property(nonatomic,assign)int hasChind;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
-(id)initWithDic:(NSDictionary *)dic;
@end
