//
//  PayBillHeaderView.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/22.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "PayBillHeaderView.h"

@implementation PayBillHeaderView

#define kRemarkBtn_width 25

-(id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        _superNameL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreen_width-30, self.height)];
        _superNameL.textAlignment = NSTextAlignmentLeft;
        _superNameL.text = title;
        _superNameL.font = [UIFont systemFontOfSize:kFontSize_2];
        [self addSubview:_superNameL];
        
//        UIButton *remarkBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        remarkBtn.frame = CGRectMake(_superNameL.right+10, 5, kRemarkBtn_width, kRemarkBtn_width);
//        remarkBtn.centerY = self.height/2;
//        [remarkBtn setBackgroundImage:[UIImage imageNamed:@"cart_remark"] forState:UIControlStateNormal];
//        [remarkBtn addTarget:self action:@selector(remarkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:remarkBtn];
    }
    return self;
}

-(void)remarkBtnClicked:(UIButton *)button
{
    if (self.remarkBlock) {
        self.remarkBlock(self, button);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
