//
//  SecondCategoryView.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/24.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "SecondCategoryView.h"
#import "FirstImageView.h"
#import "HomeGoodsItem.h"
#import "NoLoginViewController.h"
#import "LoginViewController.h"
#import "CommunityTabBarViewController.h"

@implementation SecondCategoryView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#define kSecond_height_top 150
#define kSecond_height_bottom 120

#define kExcess_width 40

-(void)setSecondItems:(NSMutableArray *)secondItems
{
    _secondItems = secondItems;
    self.backgroundColor = [UIColor whiteColor];
    [self removeAllSubviews];
    if (_secondItems.count > 0) {
        [self createSecondSubviewsWithArray:_secondItems];
    } else {
        [YanMethodManager noTejiaGoodsInview:self title:@"一大波特价正在来袭!!"];
    }
    
}
//今日特价
-(void)createSecondSubviewsWithArray:(NSMutableArray *)array
{
    for (int i = 0; i < array.count; i++) {
        HomeGoodsItem *item = array[i];
        if (i < 3) {
            CGRect frame = CGRectMake(i*(kScreen_width/3+1), 0, kScreen_width/3, self.height/2);
            FirstImageView *topImageV = [[FirstImageView alloc] initWithFrame:frame imageUrl:item.goods_pic title:item.goods_name presentPrice:[NSString stringWithFormat:@"%.1f",item.tjprice] originPrice:[NSString stringWithFormat:@"%.1f",item.goods_price]];
            topImageV.titleImageV.tag = 150 + i;
            [self addSubview:topImageV];
            
            [self addSecondTapGestureWithImageView:topImageV.titleImageV];
//            [self addSecondTapGestureWithImageView:topImageV.cartImageV];
            
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, topImageV.height, topImageV.width, 0.5)];
            bottomLine.backgroundColor = kDividColor;
            [topImageV addSubview:bottomLine];
            if (i < 2) {
                UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(topImageV.width, 0, 0.5, topImageV.height)];
                rightLine.backgroundColor = kDividColor;
                [topImageV addSubview:rightLine];
            }
        } else if (i == 3){

            CGRect frame = CGRectMake(0, self.height/2+1, self.width*2/3+1, self.height/2);
            FirstImageView *bImageV = [[FirstImageView alloc] initWithFrame:frame imageUrl:item.goods_pic title:item.goods_name presentPrice:[NSString stringWithFormat:@"%.1f",item.tjprice]originPrice:[NSString stringWithFormat:@"%.1f",item.goods_price]];
            bImageV.titleImageV.tag = 150 + i;
            [self addSecondTapGestureWithImageView:bImageV.titleImageV];
//            [self addSecondTapGestureWithImageView:bImageV.cartImageV];
            [self addSubview:bImageV];
            
            UIView *bLine = [[UIView alloc] initWithFrame:CGRectMake(0, bImageV.height, bImageV.width, 0.5)];
            bLine.backgroundColor = kDividColor;
            [bImageV addSubview:bLine];
            
            UIView *bRightLine = [[UIView alloc] initWithFrame:CGRectMake(bImageV.width, 0, 0.5, bImageV.height)];
            bRightLine.backgroundColor = kDividColor;
            [bImageV addSubview:bRightLine];
        } else if(i == 4) {
            CGRect frame = CGRectMake(self.width*2/3+1, self.height/2+1, self.width/3, self.height/2);
            FirstImageView *lastImageV = [[FirstImageView alloc] initWithFrame:frame imageUrl:item.goods_pic title:item.goods_name presentPrice:[NSString stringWithFormat:@"%.1f",item.tjprice] originPrice:[NSString stringWithFormat:@"%.1f",item.goods_price]];
            lastImageV.titleImageV.tag = 150 + i;
            [self addSecondTapGestureWithImageView:lastImageV.titleImageV];
//            [self addSecondTapGestureWithImageView:lastImageV.cartImageV];
            [self addSubview:lastImageV];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, lastImageV.height, lastImageV.width, 0.5)];
            line.backgroundColor = kDividColor;
            [lastImageV addSubview:line];
        }
    }
}

-(void)addSecondTapGestureWithImageView:(UIImageView *)imageview
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSecondAction:)];
    [imageview addGestureRecognizer:tap];
}

-(void)tapSecondAction:(UITapGestureRecognizer *)tap
{
   
    if (self.tapBlock) {
        self.tapBlock(tap);
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
