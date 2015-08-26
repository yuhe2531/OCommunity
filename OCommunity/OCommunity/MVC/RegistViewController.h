//
//  RegistViewController.h
//  OCommunity
//
//  Created by Runkun1 on 15/5/13.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBackBlock)(NSString *,NSString *);

@interface RegistViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, assign) BOOL isRegist;
@property (nonatomic, copy) CallBackBlock callBackBlcok;

@end
