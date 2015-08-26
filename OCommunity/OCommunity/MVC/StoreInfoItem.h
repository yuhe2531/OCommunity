//
//  StoreInfoItem.h
//  OCommunity
//
//  Created by Runkun1 on 15/6/26.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreInfoItem : NSObject

@property (nonatomic, assign) float alisa;//起送价
@property (nonatomic, assign) float fare;//运费
@property (nonatomic, assign) int store_id;
@property (nonatomic, copy) NSString *store_name;

-(id)initWithDic:(NSDictionary *)dic;

@end
