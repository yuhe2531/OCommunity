//
//  GoodsSecondClassifyTableViewCell.h
//  OCommunity
//
//  Created by runkun2 on 15/7/2.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsSecondClassifyTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UIView *selectView;
@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,assign)BOOL isSelected;

@end
