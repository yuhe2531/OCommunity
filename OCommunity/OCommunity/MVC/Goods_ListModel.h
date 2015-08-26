//
//  Goods_ListModel.h
//  OCommunity
//
//  Created by runkun2 on 15/7/23.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Goods_ListModel : NSObject
@property(nonatomic,assign)int item_id;
@property(nonatomic,copy)NSString *item_name;
@property(nonatomic,assign)float number;
@property(nonatomic,assign)float price;
@property(nonatomic,assign)float total_fee;
-(id)initWithDic:(NSDictionary *)dic;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
