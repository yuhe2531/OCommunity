//
//  Goods_ListModel.m
//  OCommunity
//
//  Created by runkun2 on 15/7/23.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "Goods_ListModel.h"

@implementation Goods_ListModel
-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}

-(void)setNilValueForKey:(NSString *)key
{
    
}

@end
