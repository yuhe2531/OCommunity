//
//  FirstCategoryView.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/24.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "FirstCategoryView.h"
#import "SecondImageView.h"
#import "ThirdImageView.h"
#import "HomeGoodsItem.h"
#import "NoLoginViewController.h"
#import "LoginViewController.h"
#import "CommunityTabBarViewController.h"
@implementation FirstCategoryView

-(id)initWithFrame:(CGRect)frame goodsArray:(NSMutableArray *)goodsArray
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

-(void)setFirstItems:(NSMutableArray *)firstItems
{
    _firstItems = firstItems;
    self.backgroundColor = [UIColor whiteColor];
    [self removeAllSubviews];
    if (_firstItems.count >= 5) {
        [self createFirstSubviewsWithArray:_firstItems];
    } else {
        [YanMethodManager noTejiaGoodsInview:self title:@"更多商品正在上架中!!"];
    }
}

#define kFirst_height 100

-(void)createFirstSubviewsWithArray:(NSMutableArray *)goodsArray
{
    for (int i = 0; i < 5; i++) {
        HomeGoodsItem *item = goodsArray[i];
        if (i < 2) {
            SecondImageView *imageView = [[SecondImageView alloc] initWithFrame:CGRectMake(kScreen_width/2*i, 0, kScreen_width/2, self.height/2) title:item.goods_name subTitle:nil price:[NSString stringWithFormat:@"%.1f",item.goods_price] imageUrl:item.goods_pic];
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.height, imageView.width, 0.5)];
            bottomLine.backgroundColor = kDividColor;
            [imageView addSubview:bottomLine];
            if (i == 0) {
                [YanMethodManager lineViewWithFrame:CGRectMake(imageView.width, 0, 0.5, imageView.height) superView:imageView];
            }
            imageView.imageView.tag = 100 + i;
//            imageView.cartImgView.tag = 120 + i;
            [self addTapGestureOnImageView:imageView.imageView];
//            [self addTapGestureOnImageView:imageView.cartImgView];
            [self addSubview:imageView];
        } else {
            CGRect frame = CGRectMake(kScreen_width/3*(i-2), self.height/2, kScreen_width/3, self.height/2);
            ThirdImageView *thirdImgV = [[ThirdImageView alloc] initWithFrame:frame title:item.goods_name subTitle:nil price:[NSString stringWithFormat:@"%.1f",item.goods_price] imageUrl:item.goods_pic];
            if (i < 4) {
                [YanMethodManager lineViewWithFrame:CGRectMake(thirdImgV.width, 0, 0.5, thirdImgV.height) superView:thirdImgV];
            }
            [YanMethodManager lineViewWithFrame:CGRectMake(0, thirdImgV.height, thirdImgV.width, 0.5) superView:thirdImgV];
            thirdImgV.imageView.tag = 100 + i;
//            thirdImgV.cartImageView.tag = 120 + i;
            [self addTapGestureOnImageView:thirdImgV.imageView];
//            [self addTapGestureOnImageView:thirdImgV.cartImageView];
            [self addSubview:thirdImgV];
        }
    }
    
}

-(void)addTapGestureOnImageView:(UIImageView *)imageView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViewAction:)];
    [imageView addGestureRecognizer:tap];
}

-(void)tapImageViewAction:(UITapGestureRecognizer *)tap
{
    if (self.tapFirstBlock) {
        self.tapFirstBlock(tap);
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
