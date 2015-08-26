//
//  AreaData.h
//  OCommunity
//
//  Created by Runkun1 on 15/6/5.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaData : NSObject

@property (nonatomic, assign) NSInteger add_time;
@property (nonatomic, assign) int area_id;
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, assign) int area_number;
@property (nonatomic, assign) int area_sort;
@property (nonatomic, copy) NSString *first_letter;
@property (nonatomic, assign) int hot_city;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) int parent_area_id;
@property (nonatomic, assign) int post;

-(id)initWithDic:(NSDictionary *)dic;

@end
