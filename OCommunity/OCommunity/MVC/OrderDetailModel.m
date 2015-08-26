//
//  OrderDetailModel.m
//  OCommunity
//
//  Created by runkun2 on 15/7/23.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel
-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
        NSString *dateNum = [dic objectForKey:@"add_time"];
        if (!(dateNum==NULL)&&![dateNum isKindOfClass:[NSNull class]]&&!(dateNum==nil)) {
            NSTimeInterval timePoint = [dateNum doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timePoint];
            NSDateFormatter *add_date = [[NSDateFormatter alloc] init];
            [add_date setDateStyle:NSDateFormatterFullStyle];
            add_date.dateStyle = kCFDateFormatterFullStyle;
            add_date.dateFormat = @"yyyy年MM月dd日 EEEHH:mm:ss ";
            add_date.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
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
