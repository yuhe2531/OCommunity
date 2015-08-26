//
//  LoginSubView.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/30.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "LoginSubView.h"

@implementation LoginSubView

#define kIMageView_width 30

-(id)initWithFrame:(CGRect)frame image:(UIImage *)image placeholder:(NSString *)holder
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, kIMageView_width, self.height-10)];
        imageView.image = image;
        [self addSubview:imageView];
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(imageView.right + 10, 0, self.width-imageView.width-10, self.height)];
        _textField.placeholder = holder;
        _textField.textColor = [UIColor whiteColor];
        _textField.font = [UIFont systemFontOfSize:kFontSize_2];
        [self addSubview:_textField];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [self addSubview:line];
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
