//
//  MyCouponModel.m
//  OCommunity
//
//  Created by runkun3 on 15/7/31.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MyCouponModel.h"

@implementation MyCouponModel


-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
        NSString *dateNum = [dic objectForKey:@"end_time"];
        if (!(dateNum==NULL)&&![dateNum isKindOfClass:[NSNull class]]) {
            NSTimeInterval timePoint = [dateNum doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timePoint];
            NSDateFormatter *add_date = [[NSDateFormatter alloc] init];
            [add_date setDateFormat:@"yyyy-MM-dd"];
            NSString *add_time = [add_date stringFromDate:date];
            self.end_time = add_time;
           
        }
    }
    return self;
}
-(void)setNilValueForKey:(NSString *)key{
    
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
@end
