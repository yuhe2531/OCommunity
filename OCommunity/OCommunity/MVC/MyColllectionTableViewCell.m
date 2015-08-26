//
//  MyColllectionTableViewCell.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/13.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MyColllectionTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface MyColllectionTableViewCell ()

@property (nonatomic, strong) UIImageView *listImgV;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *priceL;

@end

@implementation MyColllectionTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createGoodsListCellSubviews];
    }
    return self;
}

#define kImageV_left 15
#define kImageV_top 10
#define kImageV_width 80
#define kImageV_height 60
#define kShopCartWidth 25

-(void)createGoodsListCellSubviews
{
    _listImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kImageV_left, kImageV_top, kImageV_width, kImageV_height)];
    _listImgV.image = kHolderImage;
    [self.contentView addSubview:_listImgV];
    
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(kImageV_left+_listImgV.right, _listImgV.top, kScreen_width-kImageV_left*2-_listImgV.width-50, 20)];
    _titleL.text = @"汇源果肉饮料 2.5L";
    _titleL.textColor = kBlack_Color_2;
    _titleL.font = [UIFont systemFontOfSize:kFontSize_2];
    [self.contentView addSubview:_titleL];
    
    _priceL = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.left, _titleL.bottom+15, 80, _titleL.height)];
    _priceL.text = @"¥25.0";
    _priceL.textColor = kRed_PriceColor;
    _priceL.font = [UIFont systemFontOfSize:kFontSize_3];
    [self.contentView addSubview:_priceL];
    //
    _cartBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _cartBtn.frame = CGRectMake(kScreen_width-30-85-60, 0, 85, kShopCartWidth);
    //    [cartBtn setBackgroundImage:[UIImage imageNamed:@"holder.png"] forState:UIControlStateNormal];
    [_cartBtn setTitle:@"再次购买" forState:UIControlStateNormal];
    [_cartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cartBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    _cartBtn.layer.cornerRadius = 5;
    _cartBtn.backgroundColor = kRedColor;
    _cartBtn.centerY = _priceL.centerY;
    _cartBtn.tag = 310;
    [_cartBtn addTarget:self action:@selector(cartBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_cartBtn];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    commentBtn.frame = CGRectMake(_cartBtn.right+10, _cartBtn.top, 45, _cartBtn.height);
    commentBtn.layer.cornerRadius = 5;
    commentBtn.backgroundColor = kColorWithRGB(255, 142, 86);
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(cartBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    commentBtn.tag = 311;
    [self.contentView addSubview:commentBtn];
}

-(void)cartBtnAction:(UIButton *)button
{
    if (self.cartBlock) {
        self.cartBlock(button);
    }
}

-(void)setHomegoodsitem:(HomeGoodsItem*)homegoodsitem{
    
    _homegoodsitem = homegoodsitem;
    [_listImgV sd_setImageWithURL:[NSURL URLWithString:_homegoodsitem.goods_pic] placeholderImage:kHolderImage];
    _titleL.text = _homegoodsitem.item_name;
    _priceL.text = [NSString stringWithFormat:@"￥%.1f",_homegoodsitem.price];
}

-(void)setHasPurchased:(BOOL)hasPurchased
{
    _hasPurchased = hasPurchased;
    if (_hasPurchased) {
        [_cartBtn setTitle:@"再次购买" forState:UIControlStateNormal];
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
