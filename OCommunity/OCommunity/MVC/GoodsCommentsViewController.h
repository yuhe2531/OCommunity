//
//  GoodsCommentsViewController.h
//  OCommunity
//
//  Created by runkun2 on 15/6/16.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCommentsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) int goods_id;
@end
