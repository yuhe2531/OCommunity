//
//  Market.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/18.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "Market.h"

@implementation Market

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
    NSLog(@"======== key = %@",key);
}

@end
