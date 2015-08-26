//
//  SearchResultViewController.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/24.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, assign) BOOL searchStore_Push;
@property (nonatomic, assign) BOOL searchStore_Again;

@end
