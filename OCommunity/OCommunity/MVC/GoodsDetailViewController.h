//
//  GoodsDetailViewController.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/27.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"
@interface GoodsDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, assign) int goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_pic;
@property (nonatomic, copy) NSString *goods_price;
@property (nonatomic, assign) int store_id;
@property (nonatomic, copy) NSString *pic;


@property (nonatomic, copy) GoodsDetailModel *goodsDetailModel;
@end
