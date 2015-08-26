//
//  ThirdCategoryView.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/24.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "ThirdCategoryView.h"
#import "HomeGoodsItem.h"
#import "FirstImageView.h"
#import "FourthImageView.h"
#import "SecondImageView.h"
#import "NoLoginViewController.h"
#import "LoginViewController.h"
#import "CommunityTabBarViewController.h"

@implementation ThirdCategoryView

-(id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)setThirdItems:(NSMutableArray *)thirdItems
{
    _thirdItems = thirdItems;
    self.backgroundColor = [UIColor whiteColor];
    [self removeAllSubviews];
    if (_thirdItems.count >= 4) {
         [self createThirdSubviewsWithArray:_thirdItems];
    } else {
        [YanMethodManager noTejiaGoodsInview:self title:@"更多商品正在上架中!!"];
    }
}

-(void)createThirdSubviewsWithArray:(NSMutableArray *)goodsArray
{
    for (int i = 0; i < 4; i++) {
        HomeGoodsItem *item = goodsArray[i];
        if (i == 0) {
            FirstImageView *firstImgV = [[FirstImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width/3, self.height) imageUrl:item.goods_pic title:item.goods_name presentPrice:[NSString stringWithFormat:@"%.1f",item.goods_price] originPrice:nil];
            firstImgV.titleImageV.tag = 200 + i;
//            firstImgV.cartImageV.tag = 220 + i;
            [self addThirdTapGestureOnImageView:firstImgV.titleImageV];
//            [self addThirdTapGestureOnImageView:firstImgV.cartImageV];
            [YanMethodManager lineViewWithFrame:CGRectMake(firstImgV.width, 0, 0.5, firstImgV.height) superView:firstImgV];
            [self addSubview:firstImgV];
        } else if(i == 1){
            FourthImageView *fourImgV = [[FourthImageView alloc] initWithFrame:CGRectMake(kScreen_width/3, 0, kScreen_width*2/3, self.height/2) title:item.goods_name subTitle:nil imageUrl:item.goods_pic price:[NSString stringWithFormat:@"%.1f",item.goods_price]];
            fourImgV.imageView.tag = 200 + i;
//            fourImgV.cartImageView.tag = 220 + i;
            [self addThirdTapGestureOnImageView:fourImgV.imageView];
//            [self addThirdTapGestureOnImageView:fourImgV.cartImageView];
            [YanMethodManager lineViewWithFrame:CGRectMake(0, fourImgV.height, fourImgV.width, 0.5) superView:fourImgV];
            [self addSubview:fourImgV];
            
        } else {
            SecondImageView *secondImgV = [[SecondImageView alloc] initWithFrame:CGRectMake(kScreen_width/3*(i-1), self.height/2, self.width/3, self.height/2) title:item.goods_name subTitle:nil price:[NSString stringWithFormat:@"%.1f",item.goods_price] imageUrl:item.goods_pic];
            secondImgV.imageView.tag = 200 + i;
//            secondImgV.cartImgView.tag = 220 + i;
            [self addThirdTapGestureOnImageView:secondImgV.imageView];
//            [self addThirdTapGestureOnImageView:secondImgV.cartImgView];
            if (i == 2) {
                [YanMethodManager lineViewWithFrame:CGRectMake(secondImgV.width, 0, 0.5, secondImgV.height) superView:secondImgV];
            }
            [self addSubview:secondImgV];
            
        }
    }

}

-(void)addThirdTapGestureOnImageView:(UIImageView *)imageView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapThirdAction:)];
    [imageView addGestureRecognizer:tap];
}

-(void)tapThirdAction:(UITapGestureRecognizer *)tap
{
    if (self.tapThirdBlock) {
        self.tapThirdBlock(tap);
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
