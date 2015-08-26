//
//  ListSubItem.h
//  OCommunity
//
//  Created by Runkun1 on 15/6/13.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListSubItem : NSObject

@property (nonatomic, assign) int class_id;
@property (nonatomic, copy) NSString *class_name;

-(id)initWithDic:(NSDictionary *)dic;

@end
