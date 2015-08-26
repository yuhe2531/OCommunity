//
//  CustomHomeView.h
//  OCommunity
//
//  Created by Runkun1 on 15/7/4.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapMoreBtnBlock)(void);

@interface CustomHomeView : UIView

@property (nonatomic, copy) TapMoreBtnBlock moreBtnBlock;
@property (nonatomic, strong) UITableView *tableView;

-(id)initWithFrame:(CGRect)frame;

@end
