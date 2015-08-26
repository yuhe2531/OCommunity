//
//  RuleView.m
//  OCommunity
//
//  Created by Runkun1 on 15/8/25.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "RuleView.h"

@implementation RuleView

-(id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviewsInRuleviewWithTitle:title];
    }
    return self;
}

-(void)createSubviewsInRuleviewWithTitle:(NSString *)title
{
    UIView *pointV = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 10, 10)];
    pointV.backgroundColor = kRedColor;
    pointV.layer.cornerRadius = 5;
    pointV.centerY = self.height/2;
    [self addSubview:pointV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(pointV.right+15, 0, kScreen_width, self.height)];
    label.text = title;
    label.textColor = kColorWithRGB(99, 99, 99);
    label.font = [UIFont systemFontOfSize:kFontSize_2];
    [self addSubview:label];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
