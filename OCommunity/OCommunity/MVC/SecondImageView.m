//
//  SecondImageView.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/14.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "SecondImageView.h"
#import "UIImageView+WebCache.h"

@implementation SecondImageView

#define kTitleL_left 5
#define kTitleL_top 10
#define kTitleL_width 100
#define kTitleL_height 15

#define kCartImgV_right 10
#define kCartImgV_width 20
#define kCartImgV_bottom 10

#define kPriceL_width 15

-(id)initWithFrame:(CGRect)frame title:(NSString *)title subTitle:(NSString *)subTitle price:(NSString *)price imageUrl:(NSString *)imageurl
{
    self = [super initWithFrame:frame];
    if (self) {
//        _cartImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-kCartImgV_right-kCartImgV_width, self.height-kCartImgV_bottom-kCartImgV_width, kCartImgV_width, kCartImgV_width)];
//        _cartImgView.userInteractionEnabled = YES;
//        _cartImgView.image = [UIImage imageNamed:@"home_smallCart"];
//        [self addSubview:_cartImgView];
        
//        self.backgroundColor = [UIColor whiteColor];
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(kTitleL_left, kTitleL_top, self.width-30, kTitleL_height)];
        titleL.text = title;
        titleL.textColor = kBlack_Color_2;
        titleL.font = [UIFont systemFontOfSize:kFontSize_3];
        [self addSubview:titleL];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-2*kCartImgV_right-kCartImgV_width-(self.width*2/3-kCartImgV_width), titleL.bottom+kTitleL_top, self.width*2/3-kCartImgV_width, self.height-titleL.height-2*kTitleL_top)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:kHolderImage];
        [self addSubview:_imageView];
        
//        UILabel *subTitleL = [[UILabel alloc] initWithFrame:CGRectMake(titleL.left, titleL.bottom+5, self.width-20, 15)];
//        subTitleL.text = subTitle;
//        subTitleL.font = [UIFont systemFontOfSize:kFontSize_4];
//        subTitleL.textColor = kRedColor;
//        [self addSubview:subTitleL];
        
        UIButton *priceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        priceBtn.frame = CGRectMake(titleL.left, titleL.bottom, 40, kPriceL_width);
        priceBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//        priceBtn.layer.cornerRadius = kPriceL_width/2;
//        priceBtn.clipsToBounds = YES;
        [priceBtn setTitle:[@"¥" stringByAppendingString:price] forState:UIControlStateNormal];
        [priceBtn setTitleColor:kRed_PriceColor forState:UIControlStateNormal];
        priceBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_4];
//        priceBtn.backgroundColor = [UIColor blueColor];
        [self addSubview:priceBtn];
        priceBtn.enabled = NO;
        
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
