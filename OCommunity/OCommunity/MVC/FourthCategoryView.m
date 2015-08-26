//
//  FourthCategoryView.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/24.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "FourthCategoryView.h"
#import "HomeGoodsItem.h"
#import "FirstImageView.h"
#import "NoLoginViewController.h"
#import "LoginViewController.h"
#import "CommunityTabBarViewController.h"

@implementation FourthCategoryView

-(id)initWithFrame:(CGRect)frame tag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tempTag = tag;
    }
    return self;
}

-(void)setFourthItems:(NSMutableArray *)fourthItems
{
    _fourthItems = fourthItems;
    self.backgroundColor = [UIColor whiteColor];
    [self removeAllSubviews];
    if (_fourthItems.count > 0) {
        [self createFourthSubviewsWithArray:_fourthItems];
    } else {
        [YanMethodManager noTejiaGoodsInview:self title:@"更多商品正在上架中!!"];
    }
}

-(void)createFourthSubviewsWithArray:(NSMutableArray *)goodsArray
{
    for (int i = 0; i < 6; i++) {
        if (goodsArray.count-1 >= i) {
            
            HomeGoodsItem *item = goodsArray[i];
            NSString *presentPrice = item.is_tejia == 0 ? [NSString stringWithFormat:@"%.1f",item.goods_price] : [NSString stringWithFormat:@"%.1f",item.tjprice];
            NSString *originPriStr = item.is_tejia == 0 ? nil : [NSString stringWithFormat:@"%.1f",item.goods_price];
            if (i < 3) {
                FirstImageView *firstImgV = [[FirstImageView alloc] initWithFrame:CGRectMake(kScreen_width/3*i, 0, kScreen_width/3, self.height/2) imageUrl:item.goods_pic title:item.goods_name presentPrice:presentPrice originPrice:originPriStr];
                firstImgV.titleImageV.tag = _tempTag + i;
                [self addFourthTapGestureOnImageView:firstImgV.titleImageV];
                [YanMethodManager lineViewWithFrame:CGRectMake(0, firstImgV.height, firstImgV.width, 0.5) superView:firstImgV];
                if (i < 2) {
                    [YanMethodManager lineViewWithFrame:CGRectMake(firstImgV.width, 0, 0.5, firstImgV.height) superView:firstImgV];
                }
                [self addSubview:firstImgV];
            } else {
                FirstImageView *firstImgV2 = [[FirstImageView alloc] initWithFrame:CGRectMake(kScreen_width/3*(i-3), self.height/2, kScreen_width/3, self.height/2) imageUrl:item.goods_pic title:item.goods_name presentPrice:presentPrice originPrice:originPriStr];
                firstImgV2.titleImageV.tag = _tempTag + i;
                //            firstImgV2.cartImageV.tag = 270 + i;
                [self addFourthTapGestureOnImageView:firstImgV2.titleImageV];
                //            [self addFourthTapGestureOnImageView:firstImgV2.cartImageV];
                if (i < 5) {
                    [YanMethodManager lineViewWithFrame:CGRectMake(firstImgV2.width, 0, 0.5, firstImgV2.height) superView:firstImgV2];
                }
                [self addSubview:firstImgV2];
            }
            
        }
        
    }
    
}

-(void)addFourthTapGestureOnImageView:(UIImageView *)imageView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFourthAction:)];
    [imageView addGestureRecognizer:tap];
}

-(void)tapFourthAction:(UITapGestureRecognizer *)tap
{    
    if (self.tapFourthBlock) {
        self.tapFourthBlock(tap);
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
