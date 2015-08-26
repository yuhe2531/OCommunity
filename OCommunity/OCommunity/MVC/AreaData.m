//
//  AreaData.m
//  OCommunity
//
//  Created by Runkun1 on 15/6/5.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "AreaData.h"

@implementation AreaData

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
    NSLog(@"========== %@ undefined key",key);
}

@end
