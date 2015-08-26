//
//  CartGoodsItem.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/25.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "CartGoodsItem.h"

@implementation CartGoodsItem

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.isSelected = YES;
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setNilValueForKey:(NSString *)key
{
    NSLog(@"========== nil key = %@",key);
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"======== undefine key = %@",key);
}

@end
