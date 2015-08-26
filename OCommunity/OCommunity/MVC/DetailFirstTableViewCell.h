//
//  DetailFirstTableViewCell.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/27.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectCountView;

typedef void(^SelectCellBlock)(UIButton *);

@interface DetailFirstTableViewCell : UITableViewCell

@property (nonatomic, copy) SelectCellBlock selectBlock;
@property (nonatomic, strong) SelectCountView *selectView;
@end
