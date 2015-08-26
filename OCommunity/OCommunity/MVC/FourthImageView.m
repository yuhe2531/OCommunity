//
//  FourthImageView.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/14.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "FourthImageView.h"
#import "UIImageView+WebCache.h"

@implementation FourthImageView

#define kTitleL_top 10
#define kTitleL_left 10
#define kTitleL_width 150
#define kTitleL_height 15

#define kCartIMg_right 10
#define kCartImg_width 20

-(id)initWithFrame:(CGRect)frame title:(NSString *)title subTitle:(NSString *)subTitle imageUrl:(NSString *)imageUrl price:(NSString *)price
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kTitleL_left+self.width/2-80-5, kTitleL_height, self.width/2+80, self.height-kTitleL_height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:kHolderImage];
        [self addSubview:_imageView];
        
//        _cartImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-kCartIMg_right-kCartImg_width, self.height-kCartIMg_right-kCartImg_width, kCartImg_width, kCartImg_width)];
//        _cartImageView.userInteractionEnabled = YES;
//        _cartImageView.image = [UIImage imageNamed:@"home_smallCart"];
//        [self addSubview:_cartImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTitleL_left, kTitleL_top, kTitleL_width, kTitleL_height)];
        titleLabel.text = title;
        titleLabel.textColor = kBlack_Color_2;
        titleLabel.font = [UIFont systemFontOfSize:kFontSize_3];
        [self addSubview:titleLabel];
        
//        UILabel *subTitleL = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+5, titleLabel.width, titleLabel.height)];
//        subTitleL.text = subTitle;
//        subTitleL.font = [UIFont systemFontOfSize:kFontSize_4];
//        [self addSubview:subTitleL];
//        if (subTitle == nil) {
//            subTitleL.height = 0;
//        }
        
        UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+5, 80, 15)];
        priceL.text = [@"¥" stringByAppendingString:price];
        priceL.textColor = kRed_PriceColor;
        priceL.font = [UIFont systemFontOfSize:kFontSize_4];
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
