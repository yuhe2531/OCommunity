//
//  TopHomeModel.m
//  OCommunity
//
//  Created by runkun2 on 15/5/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "TopHomeModel.h"

@implementation TopHomeModel
-(id)initWithDic:(NSDictionary *)dic
{
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
