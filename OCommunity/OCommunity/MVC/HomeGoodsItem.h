//
//  HomeGoodsItem.h
//  OCommunity
//
//  Created by Runkun1 on 15/5/15.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeGoodsItem : NSObject

@property (nonatomic, assign) int goods_id;
@property (nonatomic, copy) NSString *class_name;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_pic;
@property (nonatomic, assign) float goods_price;
@property (nonatomic, assign) int store_id;
@property (nonatomic, assign) int class_id;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, assign) float tjprice;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger is_tejia;
@property (nonatomic, assign) int tempId;
//"goods_pic" = "http://app.lingbushequ.com/data/upload/shop/goods/20e87c9f2b43f522a42079f55be893f3.jpg";
//"item_id" = 28286;
//"item_name" = "\U5357\U6d0b\U624b\U5957";
//number = 1;
//price = "0.00";
//"store_name" = "\U76ca\U4e07\U5bb6\U8d85\U5e02";
@property (nonatomic, assign)int item_id;
@property (nonatomic,copy)NSString *item_name;
@property (nonatomic,assign) int number;
@property (nonatomic,assign)float price;
@property (nonatomic,strong) NSString *store_name;
@property (nonatomic,assign) int order_id;


-(id)initWithDic:(NSDictionary *)dic;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
