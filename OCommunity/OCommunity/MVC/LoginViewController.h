                    //
//  LoginViewController.h
//  Broker
//
//  Created by peng on 14/12/26.
//  Copyright (c) 2014年 zhangyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoginSuccessBlock)(void);
typedef void(^loginDismissBlock)(void);

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,copy) LoginSuccessBlock loginSuccessBlock;
@property (nonatomic,copy) loginDismissBlock dismissBlock;
@property (nonatomic,copy) NSString *resetUsername;
@property (nonatomic,copy) NSString *resetPassword;
@property (nonatomic, assign) BOOL isPresent;

@end
