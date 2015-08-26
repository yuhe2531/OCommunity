//
//  MoreSubView.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/24.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MoreSubView.h"

@implementation MoreSubView

-(id)initWithFrame:(CGRect)frame title:(NSString *)title color:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBackgroundColor;
        [self createMoreSubviewsWithTitle:title color:color];
    }
    return self;
}

#define kMoreImg_width 15
#define kMoreLabel_width 60

-(void)createMoreSubviewsWithTitle:(NSString *)title color:(UIColor *)color
{
    UIView *markView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 2, self.height-20)];
    markView.backgroundColor = kRedColor;
    [self addSubview:markView];
    
    UILabel *goodsCategory = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, self.height)];
    goodsCategory.text = title;
    goodsCategory.textColor = color;
    goodsCategory.font = [UIFont systemFontOfSize:kFontSize_2];
    [self addSubview:goodsCategory];
    
    UIImageView *moreImgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-kMoreImg_width-15, 0, kMoreImg_width, kMoreImg_width)];
    moreImgV.centerY = self.height/2;
    moreImgV.image = [UIImage imageNamed:@"right_arrow"];
    [self addSubview:moreImgV];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width-kMoreImg_width-kMoreLabel_width-15, 0, kMoreLabel_width, self.height)];
    moreLabel.text = @"显示更多";
    moreLabel.textColor = kColorWithRGB(102, 100, 100);
    moreLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    moreLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:moreLabel];
    
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _moreBtn.frame = CGRectMake(moreLabel.left, 0, kMoreLabel_width+kMoreImg_width, self.height);
    [self addSubview:_moreBtn];
    
    [YanMethodManager lineViewWithFrame:CGRectMake(0, 0, self.width, 0.5) superView:self];
    [YanMethodManager lineViewWithFrame:CGRectMake(0, self.height, self.width, 0.5) superView:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
