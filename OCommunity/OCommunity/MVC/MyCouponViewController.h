//
//  MyCouponViewController.h
//  OCommunity
//
//  Created by runkun3 on 15/7/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UITextField *textFied;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,assign)BOOL isRefresh;
@property  (nonatomic,assign)BOOL isDelete;
@end
