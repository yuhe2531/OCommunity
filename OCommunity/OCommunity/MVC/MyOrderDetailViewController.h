//
//  MyOrderDetailViewController.h
//  OCommunity
//
//  Created by runkun2 on 15/7/21.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)NSString *order_sn;//订单号
@property(nonatomic,copy)NSString *marketPicName;//商户图片
@property(nonatomic,copy)NSString *marketName;
@end
