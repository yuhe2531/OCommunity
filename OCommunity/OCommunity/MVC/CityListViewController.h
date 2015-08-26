//
//  CityListViewController.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/23.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AreaData;

typedef void(^ClickCellBlock)(AreaData *);

@interface CityListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) ClickCellBlock clickCellBlock;

@end
