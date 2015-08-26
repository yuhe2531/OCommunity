//
//  MatchView.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/16.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MatchView.h"
#import "HomeGoodsItem.h"
#import "FirstImageView.h"

@implementation MatchView

-(id)initWithFrame:(CGRect)frame title:(NSString *)title matchGoods:(NSMutableArray *)goodsArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatMatchViewSubviewsWithTitle:title goods:goodsArray];
//        [YanMethodManager lineViewWithFrame:CGRectMake(0, 0, kScreen_width, 0.5) superView:self];
        [YanMethodManager lineViewWithFrame:CGRectMake(0, self.height, kScreen_width, 0.5) superView:self];
    }
    return self;
}


#define kMatchImgV_width 100


-(void)creatMatchViewSubviewsWithTitle:(NSString *)title goods:(NSMutableArray *)goodsArray
{
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    titleL.text = title;
    titleL.font = [UIFont systemFontOfSize:kFontSize_2];
    [self addSubview:titleL];
    
    UIScrollView *matchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleL.bottom+10, kScreen_width, self.height-titleL.height-20)];
    [YanMethodManager lineViewWithFrame:CGRectMake(0, titleL.bottom+10, kScreen_width, 0.5) superView:self];
    for (int i = 0; i < goodsArray.count; i++) {
        HomeGoodsItem *item = goodsArray[i];
        CGRect frame = CGRectMake(kMatchImgV_width*i, 0, kMatchImgV_width, matchScrollView.height);
        FirstImageView *firstImgV = [[FirstImageView alloc] initWithFrame:frame imageUrl:item.goods_pic title:item.goods_name presentPrice:[NSString stringWithFormat:@"%.2f",item.goods_price]  originPrice:nil];
        firstImgV.titleImageV.tag = 600 + i;
//        firstImgV.cartImageV.tag = 650 + i;
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMatchAction:)];
        [firstImgV.titleImageV addGestureRecognizer:imageTap];
//        UITapGestureRecognizer *cartTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMatchAction:)];
//        [firstImgV.cartImageV addGestureRecognizer:cartTap];
        [matchScrollView addSubview:firstImgV];
        
        [YanMethodManager lineViewWithFrame:CGRectMake(firstImgV.width, 0, 0.5, firstImgV.height) superView:firstImgV];
    }
    matchScrollView.contentSize = CGSizeMake(kMatchImgV_width*goodsArray.count, matchScrollView.height);
    [self addSubview:matchScrollView];
}

-(void)tapMatchAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"====== %ld",(long)tap.view.tag);
    
    if (self.matchTapBlock) {
        self.matchTapBlock(tap);
    }
}

@end
