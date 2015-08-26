//
//  CrayFishViewController.h
//  OCommunity
//
//  Created by runkun2 on 15/6/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrayFishViewController : UIViewController<UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate>
@property(nonatomic,assign)float width;
@property(nonatomic,assign)float height;
@property(nonatomic,copy)NSString *urlImageString;
@end
