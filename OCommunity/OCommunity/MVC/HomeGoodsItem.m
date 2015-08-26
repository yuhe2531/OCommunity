//
//  HomeGoodsItem.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/15.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "HomeGoodsItem.h"

@implementation HomeGoodsItem

-(id)init
{
    self = [super init];
    if (self) {
        self.count = 1;
    }
    return self;
}

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.tempId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]].intValue;
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
