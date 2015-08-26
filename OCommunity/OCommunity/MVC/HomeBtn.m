//
//  HomeBtn.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/24.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "HomeBtn.h"

@implementation HomeBtn

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createHomeBtnSubviews];
    }
    return self;
}

#define KHomeButton_width 40

-(void)createHomeBtnSubviews
{
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame = CGRectMake(0, 10, KHomeButton_width, KHomeButton_width);
    _button.layer.cornerRadius = KHomeButton_width/2;
    _button.centerX = self.width/2;
    [self addSubview:_button];
    
    _btnTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, _button.bottom, self.width, 30)];
    _btnTitle.text = @"收发快递";
    _btnTitle.font = [UIFont systemFontOfSize:kFontSize_3];
    _btnTitle.textColor = kBlack_Color_2;
    _btnTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_btnTitle];
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    _btnTitle.text = title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
