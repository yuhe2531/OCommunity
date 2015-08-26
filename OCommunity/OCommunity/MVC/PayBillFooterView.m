//
//  PayBillFooterView.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/19.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "PayBillFooterView.h"

@implementation PayBillFooterView

-(id)initWithFrame:(CGRect)frame count:(NSInteger)count totalPrice:(float)totalPrice
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 25, self.height)];
        numLabel.text = [NSString stringWithFormat:@"%ld",count];
        UILabel *countL = [[UILabel alloc] initWithFrame:CGRectMake(numLabel.right, 0, 100, self.height)];
        countL.text = [NSString stringWithFormat:@"件商品"];
        countL.font = [UIFont systemFontOfSize:kFontSize_3];
        countL.textColor = [UIColor lightGrayColor];
        [self addSubview:numLabel];
        [self addSubview:countL];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(countL.right, 7, 1, self.height-14)];
        view.backgroundColor = kDividColor;
        [self addSubview:view];
        UILabel *totalL = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_width-150, 0, 40, self.height)];
        totalL.text = [NSString stringWithFormat:@"合计:"];
        UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(totalL.right, 0, 100, self.height)];
        priceL.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
        priceL.textColor = kRedColor;
        totalL.font = [UIFont systemFontOfSize:kFontSize_2];
//        totalL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:totalL];
        [self addSubview:priceL];
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
