//
//  CategoryContentTableViewCell.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CategoryCellBlock)(UITapGestureRecognizer *);

@interface CategoryContentTableViewCell : UITableViewCell

@property (nonatomic, copy) CategoryCellBlock categoryCartBlock;

@end
