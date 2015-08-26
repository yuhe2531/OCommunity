//
//  TopHomeModel.h
//  OCommunity
//
//  Created by runkun2 on 15/5/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopHomeModel : NSObject
@property(nonatomic,assign)int ap_id;
@property(nonatomic,copy)NSString *ap_name;
@property(nonatomic,copy)NSString *ap_intro;
@property(nonatomic,copy)NSString *default_content;
@property(nonatomic,copy)NSString *link;
@property (nonatomic,assign) float ap_height;
@property (nonatomic, assign) float ap_width;
@property (nonatomic, assign) int is_type;
@property (nonatomic, assign) int is_use;

-(id)initWithDic:(NSDictionary *)dic;

@end
