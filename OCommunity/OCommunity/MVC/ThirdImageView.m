//
//  ThirdImageView.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/14.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "ThirdImageView.h"
#import "UIImageView+WebCache.h"

@implementation ThirdImageView

#define kTitleLabel_left 10
#define kTitleLabel_top 10
#define kTitleLabel_height 15

#define kCartImgV_width 20
#define kPriceBtn_width 40

-(id)initWithFrame:(CGRect)frame title:(NSString *)title subTitle:(NSString *)subTitle price:(NSString *)price imageUrl:(NSString *)imageUrl
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor whiteColor];
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(kTitleLabel_left, kTitleLabel_top, self.width-2*kTitleLabel_left, kTitleLabel_height)];
        titleL.text = title;
        titleL.textColor = kBlack_Color_2;
        titleL.font = [UIFont systemFontOfSize:kFontSize_3];
        [self addSubview:titleL];
        
//        UILabel *subTitleL = [[UILabel alloc] initWithFrame:CGRectMake(titleL.left, titleL.bottom+5, titleL.width, titleL.height)];
//        subTitleL.text = subTitle;
//        subTitleL.font = [UIFont systemFontOfSize:kFontSize_4];
//        [self addSubview:subTitleL];
//        
//        if (subTitle == nil) {
//            subTitleL.height = 0;
//        }
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(titleL.left, titleL.bottom+5, self.width-2*kTitleLabel_left, self.height-titleL.height-30)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:kHolderImage];
        [self addSubview:_imageView];
        
        UIButton *priceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        priceBtn.frame = CGRectMake(titleL.left, titleL.bottom+5, kPriceBtn_width, titleL.height);
        priceBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [priceBtn setTitle:[@"¥" stringByAppendingString:price] forState:UIControlStateNormal];
//        priceBtn.backgroundColor = KRandomColor;
        [priceBtn setTitleColor:kRed_PriceColor forState:UIControlStateNormal];
        priceBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_4];
        priceBtn.enabled = NO;
//        priceBtn.layer.cornerRadius = kPriceBtn_width/2;
        [self addSubview:priceBtn];
        
//        _cartImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-kTitleLabel_left-kCartImgV_width, self.height-kTitleLabel_left-kCartImgV_width, kCartImgV_width, kCartImgV_width)];
//        _cartImageView.userInteractionEnabled = YES;
//        _cartImageView.image = [UIImage imageNamed:@"home_smallCart"];
//        [self addSubview:_cartImageView];
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
