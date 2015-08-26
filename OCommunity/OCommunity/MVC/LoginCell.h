//
//  LoginCell.h
//  OCommunity
//
//  Created by Runkun1 on 15/5/14.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginCell : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *contentTF;

-(id)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title;

@end
