//
//  TableHeadView.m
//  OCommunity
//
//  Created by runkun2 on 15/5/20.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "TableHeadView.h"
#import "UIImageView+WebCache.h"
@implementation TableHeadView{

    UIView *seperateView;

}

-(id)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName{


    if (self =[super initWithFrame:frame])
    {
        
//        _topImgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
//        if ([imageName isKindOfClass:[NSNull class]]) {
//            _topImgV.image = kHolderImage;
//        }else{
//            [_topImgV sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:kHolderImage];
//        }
//        [self addSubview:_topImgV];
        
        _titleL = [[UILabel alloc] initWithFrame:self.bounds];
        _titleL.text = @"包装食品";
        _titleL.font = [UIFont systemFontOfSize:kFontSize_2];
        _titleL.textColor = kColorWithRGB(102, 102, 102);
        _titleL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleL];
//        _topImgV.centerX = _titleL.centerX;
//        seperateView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.bounds.size.height)];
//        [seperateView setBackgroundColor:kColorWithRGB(236, 161, 0)];
//        seperateView.hidden = YES;
//        [self addSubview:seperateView];
////        seperateView
        _bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.left, _titleL.bottom-1, _titleL.width, 1)];
        _bottomLine.backgroundColor = kColorWithRGB(231, 229, 230);
        [self addSubview:_bottomLine];
        [self setBackgroundColor:kColorWithRGB(243, 243, 243)];

    }
    return self;

}
-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (_isSelected) {
//        _titleL.textColor = kColorWithRGB(236, 161, 0);
//        seperateView.hidden = NO;
        _bottomLine.hidden = YES;
        [self setBackgroundColor:[UIColor whiteColor]];
    } else {
//        _titleL.textColor = kBlack_Color_3;
//        seperateView.hidden = YES;
        _bottomLine.hidden = NO;

        [self setBackgroundColor:kColorWithRGB(243, 243, 243)];

    }
}
-(void)setTitle:(NSString *)title{


    _title = title;
    _titleL.text = _title;

}


@end
