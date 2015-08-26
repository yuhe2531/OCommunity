//
//  CartTableViewCell.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/28.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#define Cart_cell_height 80

#import "CartTableViewCell.h"
#import "SelectCountView.h"
#import "UIImageView+WebCache.h"

@implementation CartTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isSelect = YES;
        [self createCartCellSubviews];
    }
    return self;
}

#define kMarkBtn_width 25
#define kMarkBtn_left 15

#define kCartImageV_Margin 10
#define kCartImageV_width 80
#define kCartImageV_height 60

-(void)createCartCellSubviews
{
    _markBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _markBtn.frame = CGRectMake(kMarkBtn_left, 0, kMarkBtn_width, kMarkBtn_width);
    _markBtn.layer.cornerRadius = kMarkBtn_width/2;
    _markBtn.clipsToBounds = YES;
    [_markBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    [_markBtn addTarget:self action:@selector(markBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_markBtn];
    _markBtn.centerY = Cart_cell_height/2;
    
    _titleImgV = [[UIImageView alloc] initWithFrame:CGRectMake(_markBtn.right+kCartImageV_Margin, kCartImageV_Margin, kCartImageV_width, kCartImageV_height)];
    [self.contentView addSubview:_titleImgV];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleImgV.right+kCartImageV_Margin, _titleImgV.top, kScreen_width-_titleImgV.width-_markBtn.width-35, 20)];
    _titleLabel.text = @"";
    _titleLabel.textColor = kBlack_Color_2;
    _titleLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    [self.contentView addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom+5, _titleLabel.width, 15)];
    _priceLabel.text = @"单价:¥23.60";
    _priceLabel.textColor = kRed_PriceColor;
    _priceLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    [self.contentView addSubview:_priceLabel];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(_priceLabel.left, _priceLabel.bottom+5, _priceLabel.width-120, 15)];
    _countLabel.text = @"数量:5";
    _countLabel.textColor = kColorWithRGB(102, 100, 100);
    _countLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    [self.contentView addSubview:_countLabel];
    
    _selectCountV = [[SelectCountView alloc] initWithFrame:CGRectMake(_countLabel.right, _priceLabel.bottom, 110, 25)];
    _selectCountV.minusBtn.tag = 560;
    _selectCountV.plusBtn.tag = 561;
    [_selectCountV.minusBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_selectCountV.plusBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectCountV];
    
}

-(void)setCartItem:(CartGoodsItem *)cartItem
{
    _cartItem = cartItem;
    [_titleImgV sd_setImageWithURL:[NSURL URLWithString:_cartItem.goods_pic] placeholderImage:kHolderImage];
    _titleLabel.text = cartItem.item_name;
    _priceLabel.text = [NSString stringWithFormat:@"单价:%.2f",_cartItem.price];
    _countLabel.text = [NSString stringWithFormat:@"数量:%ld",_cartItem.number];
    _selectCountV.countLabel.text = [NSString stringWithFormat:@"%ld",_cartItem.number];
    
}

-(void)selectBtnAction:(UIButton *)button
{
    if (self.selectCountViewBlock) {
        self.selectCountViewBlock(button);
    }
}

-(void)markBtnAction:(UIButton *)button
{
//    _isSelect = !_isSelect;
//    if (_isSelect) {
//        //选中图标
//        _markBtn.backgroundColor = [UIColor greenColor];
//    } else {
//        //未选中图标
//        _markBtn.backgroundColor = [UIColor redColor];
//    }
    
    if (self.selectGoodsBlock) {
        self.selectGoodsBlock();
    }
}

-(void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    if (_isSelect) {
        //选中图标
        [_markBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    } else {
        //未选中图标
        [_markBtn setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
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
