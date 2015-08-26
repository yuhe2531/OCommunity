//
//  MineViewController.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/24.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *mineArray;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) NSArray *imageArray;
//@property (nonatomic, assign) BOOL hasCome;

@end
