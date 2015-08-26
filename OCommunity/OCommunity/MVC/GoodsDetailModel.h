//
//  GoodsDetailModel.h
//  OCommunity
//
//  Created by runkun3 on 15/5/22.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetailModel : NSObject

@property (nonatomic, assign) int class_id;
@property (nonatomic, copy) NSString *goods_content;
@property (nonatomic, assign) int goods_count;
@property (nonatomic, assign) int goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_pic;
@property (nonatomic, assign) float goods_price;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, assign) int store_id;
@property (nonatomic, copy) NSString *store_name;

-(id)initWithDic:(NSDictionary *)dic;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
