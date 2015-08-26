//
//  LoginSubView.h
//  OCommunity
//
//  Created by Runkun1 on 15/5/30.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginSubView : UIView

@property (nonatomic, strong) UITextField *textField;

-(id)initWithFrame:(CGRect)frame image:(UIImage *)image placeholder:(NSString *)holder;

@end
