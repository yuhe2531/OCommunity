//
//  CityData.h
//  OCommunity
//
//  Created by Runkun1 on 15/6/5.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityData : NSObject

@property (nonatomic, assign) int area_id;
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, copy) NSString *first_letter;
@property (nonatomic, assign) int hot_city;
@property (nonatomic, strong) NSArray *subclass;

-(id)initWithDic:(NSDictionary *)dic;

@end
