//
//  DuckNecksView.m
//  OCommunity
//
//  Created by Runkun1 on 15/6/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "DuckNecksView.h"
#import "NeckView.h"

@implementation DuckNecksView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addDuckNecksSubviews];
    }
    return self;
}

#define kMargin 15
-(void)addDuckNecksSubviews
{
    UIImageView *bolderImgV = [[UIImageView alloc] initWithFrame:self.bounds];
    bolderImgV.image = [UIImage imageNamed:@"duck_bolder"];
    [self addSubview:bolderImgV];
    
    NSArray *tasts = @[@"微辣口味",@"中辣口味",@"麻辣口味"];
    CGFloat width = kScreen_width - 2*kMargin;
    for (int i = 0; i < tasts.count; i++) {
        NeckView *neckView = [[NeckView alloc] initWithFrame:CGRectMake(kMargin+((width-2*kMargin)/3+kMargin)*i, 50, (width-2*kMargin)/3, 120) tastStyle:tasts[i] price:32.8 imageName:@"neck.jpg"];
        neckView.buyBtn.tag = 730 + i;
        [neckView.buyBtn addTarget:self action:@selector(buyNeckAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:neckView];
    }
}

-(void)buyNeckAction:(UIButton *)button
{
    NSLog(@"============= button tag = %ld",button.tag);
    if (self.buyNeckBlock) {
        self.buyNeckBlock(button);
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
