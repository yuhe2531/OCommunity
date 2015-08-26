//
//  FirstImageView.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/14.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "FirstImageView.h"
#import "UIImageView+WebCache.h"

@implementation FirstImageView

#define kPresentL_left 10
#define kPresentL_height 15
#define kPresentL_width 45
#define kPresentL_bottom 5

#define kOriginL_left 5
#define kOriginL_width 40

#define kCart_width 20
#define kTitleL_height 20

-(id)initWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl title:(NSString *)title presentPrice:(NSString *)presentPrice originPrice:(NSString *)originPrice
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        UILabel *presentL = [[UILabel alloc] initWithFrame:CGRectMake(kPresentL_left, self.height-kPresentL_height-kPresentL_bottom, kPresentL_width, kPresentL_height)];
        presentL.text = [@"¥" stringByAppendingString:presentPrice];
        presentL.textColor = kRed_PriceColor;
        presentL.font = [UIFont systemFontOfSize:kFontSize_3];
        [self addSubview:presentL];
        
        if (originPrice != nil) {
            CGFloat left = 0;
            if (kScreen_width == 320) {
                left = -15;
            }
            UILabel *originL = [[UILabel alloc] initWithFrame:CGRectMake(presentL.right+kOriginL_left+left, presentL.top, kOriginL_width, presentL.height)];
            originL.text = [@"¥" stringByAppendingString:originPrice];
            originL.textColor = kBlack_Color_3;
            originL.font = [UIFont systemFontOfSize:kFontSize_3];
            [[YanMethodManager defaultManager] addMiddleLineOnString:originL];
            [self addSubview:originL];
        }
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(kPresentL_left, self.height-kPresentL_bottom-presentL.height-kTitleL_height-5, self.width-2*kPresentL_left, kTitleL_height)];
        titleL.text = title;
        titleL.textColor = kBlack_Color_2;
        titleL.font = [UIFont systemFontOfSize:kFontSize_3];
        [self addSubview:titleL];
//        _cartImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-kPresentL_left-kCart_width, self.height-kPresentL_bottom-kCart_width, kCart_width, kCart_width)];
//        _cartImageV.image = [UIImage imageNamed:@"home_smallCart"];
//        _cartImageV.userInteractionEnabled = YES;
//        [self addSubview:_cartImageV];
        
        _titleImageV = [[UIImageView alloc] initWithFrame:CGRectMake(1, 5, self.width, self.height-2*kPresentL_bottom-presentL.height-titleL.height-10)];
        _titleImageV.userInteractionEnabled = YES;
        _titleImageV.contentMode = UIViewContentModeScaleAspectFit;
        [_titleImageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:kHolderImage];
        [self addSubview:_titleImageV];
        
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
