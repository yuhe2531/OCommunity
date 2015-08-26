//
//  FruitHomeTableViewCell.m
//  OCommunity
//
//  Created by Runkun1 on 15/7/4.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "FruitHomeTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface FruitHomeTableViewCell ()

@end

@implementation FruitHomeTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createFruitCellSubviews];
    }
    return self;
}

#define kImageView_left 15
#define kImageView_top 10
#define kImageView_width 100

#define kSub_margin 10
#define kTitleLabel_height 20
#define kSelectCountView_height 20

#define kAddCart_width 29

-(void)createFruitCellSubviews
{
    _titleImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kImageView_left, kImageView_top, kImageView_width, kImageView_width)];
    _titleImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_titleImgV];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleImgV.right+kSub_margin, _titleImgV.top, kScreen_width-_titleImgV.width-40, kTitleLabel_height)];
    _titleLabel.text = @"时令水果草莓";
    _titleLabel.textColor = kBlack_Color_2;
    _titleLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    [self.contentView addSubview:_titleLabel];
    
    _selectCountView = [[SelectCountView alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom+kSub_margin, 100, kSelectCountView_height)];
    _selectCountView.minusBtn.tag = 1200;
    _selectCountView.plusBtn.tag = 1300;
    [_selectCountView.minusBtn addTarget:self action:@selector(fruitSelectCountAction:) forControlEvents:UIControlEventTouchUpInside];
    [_selectCountView.plusBtn addTarget:self action:@selector(fruitSelectCountAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectCountView];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _selectCountView.bottom+(_titleImgV.height-_titleLabel.height-_selectCountView.height-kSub_margin-kTitleLabel_height), 100, kTitleLabel_height)];
    _priceLabel.text = @"¥20/500克";
    _priceLabel.textColor = kRed_PriceColor;
    _priceLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    [self.contentView addSubview:_priceLabel];
    
    UIImageView *addCartBtn = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width-kSub_margin-kAddCart_width, _priceLabel.top-5, kAddCart_width, kAddCart_width)];
    addCartBtn.image = [UIImage imageNamed:@"fruit_cart"];
    addCartBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fruitAddintoCart:)];
    [addCartBtn addGestureRecognizer:tap];
    [self.contentView addSubview:addCartBtn];
}

-(void)setGoodsItem:(HomeGoodsItem *)goodsItem
{
    _goodsItem = goodsItem;
    _titleLabel.text = _goodsItem.goods_name;
    _priceLabel.text = [NSString stringWithFormat:@"¥%.1f",_goodsItem.goods_price];
    [_titleImgV sd_setImageWithURL:[NSURL URLWithString:_goodsItem.goods_pic] placeholderImage:kHolderImage];
    
}

-(void)fruitSelectCountAction:(UIButton *)button
{
    NSInteger count = _selectCountView.countLabel.text.integerValue;
    if (button.tag == 1200) {//minus
        if (count > 1) {
            --count;
        }
    } else {//plus
        ++count;
    }
    _selectCountView.countLabel.text = [NSString stringWithFormat:@"%ld",count];
}

-(void)fruitAddintoCart:(UITapGestureRecognizer *)tap
{
    if (self.fruitActionBlock) {
        self.fruitActionBlock(tap);
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
