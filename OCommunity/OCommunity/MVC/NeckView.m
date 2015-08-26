//
//  NeckView.m
//  OCommunity
//
//  Created by Runkun1 on 15/6/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "NeckView.h"

@implementation NeckView

-(id)initWithFrame:(CGRect)frame tastStyle:(NSString *)tast price:(float)price imageName:(NSString *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addNeckViewWithImage:image tast:tast price:price];
    }
    return self;
}

-(void)addNeckViewWithImage:(NSString *)image tast:(NSString *)tast price:(float)price
{
    UIImageView *bolderImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    bolderImgV.image = [UIImage imageNamed:@"neckBolder"];
    [self addSubview:bolderImgV];
    
    UIImageView *neckImgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, bolderImgV.width-10, 80)];
    neckImgV.image = [UIImage imageNamed:image];
    [self addSubview:neckImgV];
    
    UIView *tastView = [[UIView alloc] initWithFrame:CGRectMake(0, neckImgV.height-15, neckImgV.width, 15)];
    tastView.backgroundColor = [UIColor whiteColor];
    tastView.alpha = 0.7;
    UILabel *tastLabel = [[UILabel alloc] initWithFrame:tastView.bounds];
    tastLabel.backgroundColor = [UIColor clearColor];
    tastLabel.textAlignment = NSTextAlignmentCenter;
    tastLabel.text = tast;
    tastLabel.textColor = kColorWithRGB(146, 70, 36);
    tastLabel.font = [UIFont systemFontOfSize:kFontSize_4];
    [tastView addSubview:tastLabel];
    [neckImgV addSubview:tastView];
    
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, neckImgV.bottom, neckImgV.width, 40)];
//    payView.backgroundColor = [UIColor blackColor];
    [self addSubview:payView];
    
    UILabel *horrifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, (payView.width-20)/2, 15)];
    horrifyLabel.text = @"惊爆价";
    horrifyLabel.backgroundColor = kColorWithRGB(218, 12, 39);
    horrifyLabel.textColor = [UIColor whiteColor];
    horrifyLabel.font = [UIFont systemFontOfSize:8];
    horrifyLabel.centerY = payView.height/2;
    horrifyLabel.layer.cornerRadius = 7.5;
    horrifyLabel.clipsToBounds = YES;
    horrifyLabel.textAlignment = NSTextAlignmentCenter;
    [payView addSubview:horrifyLabel];
    
//    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(horrifyLabel.right, 0, payView.width/3, payView.height)];
//    priceLabel.textColor = kColorWithRGB(218, 12, 39);
//    priceLabel.text = [NSString stringWithFormat:@"¥%.1f",price];
//    priceLabel.font = [UIFont systemFontOfSize:kFontSize_4];
//    priceLabel.textAlignment = NSTextAlignmentCenter;
//    priceLabel.centerY = payView.height/2;
//    [payView addSubview:priceLabel];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    buyBtn.frame = CGRectMake(self.width-10-payView.width/3, 2, payView.width/3, payView.width/3);
    [buyBtn setBackgroundImage:[UIImage imageNamed:@"buy_neck"] forState:UIControlStateNormal];
    [buyBtn setTitle:[NSString stringWithFormat:@"立即\n抢购"] forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    buyBtn.titleLabel.numberOfLines = 2;
    [payView addSubview:buyBtn];
    
    _buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _buyBtn.frame = CGRectMake(0, 0, self.width, self.height);
    [self addSubview:_buyBtn];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
