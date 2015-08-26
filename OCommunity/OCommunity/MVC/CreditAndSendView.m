//
//  CreditAndSendView.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/16.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "CreditAndSendView.h"

@implementation CreditAndSendView

#define kImage_width self.height-10

-(id)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image fontSize:(CGFloat)fontSize
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat width = [[YanMethodManager defaultManager] LabelWidthByText:title height:self.height font:fontSize];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width+kImage_width+10, self.height)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, kImage_width, kImage_width)];
        imageView.image = image;
        imageView.centerY = view.height/2;
        [view addSubview:imageView];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right+10, imageView.top, width, imageView.height)];
        titleL.text = title;
        titleL.textColor = kBlack_Color_2;
        titleL.font = [UIFont systemFontOfSize:fontSize];
//        titleL.textAlignment = NSTextAlignmentCenter;
        [view addSubview:titleL];
        
        view.centerX = self.width/2;
        view.centerY = self.height/2;
        [self addSubview:view];
        
//        self.layer.borderColor = kDividColor.CGColor;
//        self.layer.borderWidth = 0.5;
//        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
