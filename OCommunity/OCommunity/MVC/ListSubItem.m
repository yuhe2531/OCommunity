//
//  ListSubItem.m
//  OCommunity
//
//  Created by Runkun1 on 15/6/13.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "ListSubItem.h"

@implementation ListSubItem

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

@end
