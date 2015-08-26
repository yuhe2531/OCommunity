//
//  GoodsListViewController.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/27.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, copy) NSString *naviTitle;
//@property (nonatomic, assign) BOOL haveBuy;
@property (nonatomic, assign) int class_id;
@property (nonatomic,assign) BOOL isTejia;
@property (nonatomic, assign) int sub_calss_id;

@end
