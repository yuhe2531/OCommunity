//
//  CartGoodsItem.h
//  OCommunity
//
//  Created by Runkun1 on 15/5/25.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartGoodsItem : NSObject

@property (nonatomic, copy) NSString *goods_pic;
@property (nonatomic, assign) NSInteger item_id;
@property (nonatomic, copy) NSString *item_name;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger order_sn;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) NSInteger shopcar_id;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, assign) BOOL isSelected;

-(id)initWithDic:(NSDictionary *)dic;

@end
