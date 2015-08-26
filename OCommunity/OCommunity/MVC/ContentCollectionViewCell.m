//
//  ContentCollectionViewCell.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/15.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "ContentCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ContentCollectionViewCell

-(id)initWithFrame:(CGRect)frame item:(HomeGoodsItem *)item
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#define kTopImageView_left 10
#define kTopImageView_top 10

#define kCartImageView_width 20

#define kLine_Count 2

-(void)setItem:(HomeGoodsItem *)item
{
    _item = item;
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kTopImageView_left, kTopImageView_top+1, (kScreen_width-90)/kLine_Count-2*kTopImageView_left, (kScreen_width-90)/kLine_Count-2*kTopImageView_left-20)];
    _topImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_topImageView sd_setImageWithURL:[NSURL URLWithString:_item.goods_pic] placeholderImage:kHolderImage];
    [self.contentView addSubview:_topImageView];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(_topImageView.left, _topImageView.bottom, _topImageView.width, 15)];
    titleL.text = _item.goods_name;
    titleL.textColor = kBlack_Color_2;
    titleL.font = [UIFont systemFontOfSize:kFontSize_4];
    [self.contentView addSubview:titleL];
    
    UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(titleL.left, titleL.bottom, titleL.width, 20)];
    priceL.text = [NSString stringWithFormat:@"单价:   %.2f",_item.goods_price];
    priceL.font = [UIFont systemFontOfSize:kFontSize_4];
    priceL.textColor = kRed_PriceColor;
    [self.contentView addSubview:priceL];
    
//    UILabel *countL = [[UILabel alloc] initWithFrame:CGRectMake(priceL.left, priceL.bottom, 27, 20)];
//    countL.text = @"数量:";
//    countL.font = [UIFont systemFontOfSize:kFontSize_4];
//    [self.contentView addSubview:countL];
    
    UIImageView *cartImgeV = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_width-90)/kLine_Count-kTopImageView_left-kCartImageView_width, priceL.bottom, kCartImageView_width, kCartImageView_width)];
    cartImgeV.image = [UIImage imageNamed:@"home_smallCart"];
    cartImgeV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCartGesture:)];
    [cartImgeV addGestureRecognizer:tap];
    [self.contentView addSubview:cartImgeV];
    
    _selectCountView = [[SelectCountView alloc] initWithFrame:CGRectMake(priceL.left, priceL.bottom, priceL.width-kCartImageView_width-5, 15)];
    _selectCountView.minusBtn.tag = 530;
    _selectCountView.plusBtn.tag = 531;
    [_selectCountView.minusBtn addTarget:self action:@selector(selectCountAction:) forControlEvents:UIControlEventTouchUpInside];
    [_selectCountView.plusBtn addTarget:self action:@selector(selectCountAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectCountView];
    
    cartImgeV.centerY = _selectCountView.centerY;
    
    [YanMethodManager lineViewWithFrame:CGRectMake((kScreen_width-90)/kLine_Count, 0, 0.5, (kScreen_width-90)/kLine_Count+30) superView:self.contentView];
    [YanMethodManager lineViewWithFrame:CGRectMake(0, (kScreen_width-90)/kLine_Count+30, (kScreen_width-90)/kLine_Count, 0.5) superView:self.contentView];
    
}

-(void)selectCountAction:(UIButton *)button
{
    NSInteger count = _selectCountView.countLabel.text.integerValue;
    
    if (button.tag == 530) {//minus
        if (count > 1) {
            --count;
        }
    } else {//plus
        ++count;
    }

    _selectCountView.countLabel.text = [NSString stringWithFormat:@"%ld",count];
}

-(void)tapCartGesture:(UITapGestureRecognizer *)tap
{
    if (self.tapCartBlock) {
        self.tapCartBlock(tap);
    }
}
-(void)setGoodsModel:(goodsClassify *)goodsModel
{
    _goodsModel = goodsModel;
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kTopImageView_left, kTopImageView_top+1, (kScreen_width-90)/kLine_Count-2*kTopImageView_left, (kScreen_width-90)/kLine_Count-2*kTopImageView_left-20)];
    [topImageView sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goods_pic] placeholderImage:kHolderImage];
    [self.contentView addSubview:topImageView];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(topImageView.left, topImageView.bottom, topImageView.width, 15)];
    titleL.text = _goodsModel.goods_name;
    titleL.textColor = kBlack_Color_2;
    titleL.font = [UIFont systemFontOfSize:kFontSize_4];
    [self.contentView addSubview:titleL];
    
    UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(titleL.left, titleL.bottom, titleL.width, 20)];
    priceL.text = [NSString stringWithFormat:@"单价:  ￥%.2f",_goodsModel.goods_price];
    priceL.font = [UIFont systemFontOfSize:kFontSize_4];
    priceL.textColor = kRed_PriceColor;
    [self.contentView addSubview:priceL];
    UIImageView *cartImgeV = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_width-90)/kLine_Count-kTopImageView_left-kCartImageView_width, priceL.bottom, kCartImageView_width, kCartImageView_width)];
    cartImgeV.image = [UIImage imageNamed:@"home_smallCart"];
    cartImgeV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCartGesture:)];
    [cartImgeV addGestureRecognizer:tap];
    [self.contentView addSubview:cartImgeV];
    
    _selectCountView = [[SelectCountView alloc] initWithFrame:CGRectMake(priceL.left, priceL.bottom, priceL.width-kCartImageView_width-5, 15)];
    _selectCountView.minusBtn.tag = 530;
    _selectCountView.plusBtn.tag = 531;
    [_selectCountView.minusBtn addTarget:self action:@selector(selectCountAction:) forControlEvents:UIControlEventTouchUpInside];
    [_selectCountView.plusBtn addTarget:self action:@selector(selectCountAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectCountView];
    
    cartImgeV.centerY = _selectCountView.centerY;
    
    [YanMethodManager lineViewWithFrame:CGRectMake((kScreen_width-90)/kLine_Count, 0, 0.5, (kScreen_width-90)/kLine_Count+30) superView:self.contentView];
    [YanMethodManager lineViewWithFrame:CGRectMake(0, (kScreen_width-90)/kLine_Count+30, (kScreen_width-90)/kLine_Count, 0.5) superView:self.contentView];


}
@end
