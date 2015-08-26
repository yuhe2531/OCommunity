//
//  PayBillViewController.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PaySuccessBlock)(void);

@interface PayBillViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *bills;
@property (nonatomic, copy) PaySuccessBlock paySuccessBlock;

@end
