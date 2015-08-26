//
//  FourthImageView.h
//  OCommunity
//
//  Created by Runkun1 on 15/5/14.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FourthImageView : UIView

@property (nonatomic, strong) UIImageView *imageView;
//@property (nonatomic, strong) UIImageView *cartImageView;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title subTitle:(NSString *)subTitle imageUrl:(NSString *)imageUrl price:(NSString *)price;

@end
