//
//  PayBillTableViewCell.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "PayBillTableViewCell.h"
#import "SelectCountView.h"
#import "UIImageView+WebCache.h"

@implementation PayBillTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCartCellSubviews];
    }
    return self;
}

//#define kMarkBtn_width 15
//#define kMarkBtn_left 15

#define kCartImageV_Margin 10
#define kCartImageV_width 80
#define kCartImageV_height 60
#define kSelectCountV_width 100

-(void)createCartCellSubviews
{
    _titleImgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, kCartImageV_Margin, kCartImageV_width, kCartImageV_height)];
    _titleImgV.backgroundColor = KRandomColor;
    [self.contentView addSubview:_titleImgV];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleImgV.right+kCartImageV_Margin, _titleImgV.top, kScreen_width-_titleImgV.width-35, 20)];
    _titleLabel.text = @"";
    _titleLabel.textColor = kBlack_Color_2;
    _titleLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    [self.contentView addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom+5, _titleLabel.width, 15)];
    _priceLabel.text = @"单价:¥23.60";
    _priceLabel.textColor = kRed_PriceColor;
    _priceLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    [self.contentView addSubview:_priceLabel];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(_priceLabel.left, _priceLabel.bottom+5, 60, 15)];
    _countLabel.text = @"数量:5";
    _countLabel.textColor = kColorWithRGB(102, 100, 100);
//    _countLabel.backgroundColor = KRandomColor;
    _countLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    [self.contentView addSubview:_countLabel];
    
//    _selectCountV = [[SelectCountView alloc] initWithFrame:CGRectMake(kScreen_width-15-kSelectCountV_width, _priceLabel.bottom, kSelectCountV_width, 25)];
//    _selectCountV.minusBtn.tag = 560;
//    _selectCountV.plusBtn.tag = 561;
//    [_selectCountV.minusBtn addTarget:self action:@selector(selectCountViewClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [_selectCountV.plusBtn addTarget:self action:@selector(selectCountViewClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_selectCountV];
}

-(void)setGoodsItem:(CartGoodsItem *)goodsItem
{
    _goodsItem = goodsItem;
    [_titleImgV sd_setImageWithURL:[NSURL URLWithString:_goodsItem.goods_pic] placeholderImage:kHolderImage];
    _titleLabel.text = _goodsItem.item_name;
    _priceLabel.text = [NSString stringWithFormat:@"单价:%.2f",_goodsItem.price];
    _countLabel.text = [NSString stringWithFormat:@"数量:%ld",_goodsItem.number];
    _selectCountV.countLabel.text = [NSString stringWithFormat:@"%ld",_goodsItem.number];
}

-(void)selectCountViewClicked:(UIButton *)button
{
    if (self.selectCountBlock) {
        self.selectCountBlock(button);
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
