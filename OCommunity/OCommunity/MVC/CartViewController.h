//
//  CartViewController.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/28.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CartPopBlock)(void);

@interface CartViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, copy) CartPopBlock cartPopBlock;

@end
