//
//  MypointTableViewCell.h
//  OCommunity
//
//  Created by runkun2 on 15/5/19.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goodsClassify.h"
@interface MypointTableViewCell : UITableViewCell
@property(nonatomic,copy)NSString *labelText;
@property(nonatomic,copy)goodsClassify *MypointModel;
@property(nonatomic,copy)NSString *totalPoint;
@end
