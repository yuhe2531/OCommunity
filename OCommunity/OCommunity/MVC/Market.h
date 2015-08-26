//
//  Market.h
//  OCommunity
//
//  Created by Runkun1 on 15/5/18.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Market : NSObject

@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *store_name;
@property (nonatomic, strong) NSNumber *alisa;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *dis;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *daliver_description;
@property (nonatomic, assign) int jfdk;
@property (nonatomic, strong) NSNumber *fare;
@property (nonatomic, assign) int class_id;

-(id)initWithDic:(NSDictionary *)dic;

@end
