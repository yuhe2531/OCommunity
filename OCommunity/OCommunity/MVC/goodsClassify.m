//
//  goodsClassify.m
//  OCommunity
//
//  Created by runkun2 on 15/5/21.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "goodsClassify.h"

@implementation goodsClassify

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
        NSString *addId = [dic objectForKey:@"id"];
        self.address_id = addId.intValue;
        NSString *dateNum = [dic objectForKey:@"add_time"];
        if (!(dateNum==NULL)&&![dateNum isKindOfClass:[NSNull class]]) {
            NSTimeInterval timePoint = [dateNum doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timePoint];
            NSDateFormatter *add_date = [[NSDateFormatter alloc] init];
            [add_date setDateFormat:@"yyyy-MM-dd"];
            NSString *add_time = [add_date stringFromDate:date];
            self.add_time = add_time;
        }
        
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    

}

-(void)setNilValueForKey:(NSString *)key
{
    
}

@end
