//
//  CanUsedCouponViewController.h
//  OCommunity
//
//  Created by Runkun1 on 15/8/4.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DiscountCouponBlock)(float, NSString *);

@interface CanUsedCouponViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, assign) float totalPrice;
@property (nonatomic, copy) DiscountCouponBlock discountCouponBlock;

@end
