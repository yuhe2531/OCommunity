//
//  HaveBoughtViewController.h
//  OCommunity
//
//  Created by runkun3 on 15/5/30.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HaveBoughtViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIScrollViewDelegate>
@property (nonatomic, assign) BOOL haveBuy;

@property (nonatomic, assign) int class_id;
@property (nonatomic, assign) int goods_id;
@property (nonatomic, assign) BOOL footer_Refresh;
@property (nonatomic, assign) BOOL upLoadData;
@end
