//
//  DuckNeckViewController.h
//  OCommunity
//
//  Created by Runkun1 on 15/6/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DuckNeckViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate>

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;

@end
