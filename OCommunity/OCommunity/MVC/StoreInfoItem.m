//
//  StoreInfoItem.m
//  OCommunity
//
//  Created by Runkun1 on 15/6/26.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "StoreInfoItem.h"

@implementation StoreInfoItem

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //do nothing
}

-(void)setNilValueForKey:(NSString *)key
{
    //do nothing
}

@end
