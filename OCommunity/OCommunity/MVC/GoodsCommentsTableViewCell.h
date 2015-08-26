//
//  GoodsCommentsTableViewCell.h
//  OCommunity
//
//  Created by runkun2 on 15/6/16.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsModel.h"
@interface GoodsCommentsTableViewCell : UITableViewCell
@property(nonatomic,copy)CommentsModel *commentsData;
@property(nonatomic,copy)CommentsModel *myComments;

@end
