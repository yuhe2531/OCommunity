//
//  GoodsDetailModel.m
//  OCommunity
//
//  Created by runkun3 on 15/5/22.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "GoodsDetailModel.h"

@implementation GoodsDetailModel

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
@end
