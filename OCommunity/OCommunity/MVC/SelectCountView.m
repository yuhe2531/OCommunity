//
//  SelectCountView.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/27.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "SelectCountView.h"

@implementation SelectCountView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSelectCountSubviews];
    }
    return self;
}

#define kCountBtn_width 25
#define kCountLabel_width 45

-(void)createSelectCountSubviews
{
    UIButton * minusBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    minusBtn.frame = CGRectMake(0, 0, self.width/4, self.height);
//    _minusBtn.backgroundColor = [UIColor orangeColor];
    [minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [minusBtn setTitleColor:kBlack_Color_3 forState:UIControlStateNormal];
    [self addSubview:minusBtn];
    
    _minusBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _minusBtn.frame = CGRectMake(0, 0, self.width/2, self.height);
    [self addSubview:_minusBtn];
    
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(minusBtn.right, 0, self.width/2, self.height)];
    _countLabel.layer.borderColor = [UIColor grayColor].CGColor;
    _countLabel.layer.borderWidth = 0.5;
    _countLabel.text = @"1";
    _countLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.textColor = kBlack_Color_2;
    [self addSubview:_countLabel];
    
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    plusBtn.frame = CGRectMake(_countLabel.right, 0, self.width/4, self.height);
    [plusBtn setTitle:@"+" forState:UIControlStateNormal];
//    _plusBtn.backgroundColor = [UIColor greenColor];
    [plusBtn setTitleColor:kBlack_Color_3 forState:UIControlStateNormal];
    [self addSubview:plusBtn];
    
    _plusBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _plusBtn.frame = CGRectMake(self.width/2, 0, self.width/2, self.height);
    [self addSubview:_plusBtn];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
