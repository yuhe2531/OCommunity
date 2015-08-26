//
//  NewAddressViewController.h
//  OCommunity
//
//  Created by Runkun1 on 15/5/4.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goodsClassify.h"
typedef void(^NewAddressBlock)(void);
@interface NewAddressViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,copy)goodsClassify *addressModel;
@property (nonatomic, copy) NewAddressBlock addressBlock;

@end
