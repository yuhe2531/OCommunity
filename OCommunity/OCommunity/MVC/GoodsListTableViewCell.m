//
//  GoodsListTableViewCell.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/27.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "GoodsListTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface GoodsListTableViewCell ()

@property (nonatomic, strong) UIImageView *listImgV;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *priceL;
@property (nonatomic, strong) UILabel *tejiaLabel;
@property (nonatomic, assign) BOOL addGoodsToCar;
@end

@implementation GoodsListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createGoodsListCellSubviews];
    }
    return self;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier witnAddgoodsToCar:(BOOL)car{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.addGoodsToCar = car;
        [self createGoodsListCellSubviews];
    }
    return self;
}
#define kImageV_left 15
#define kImageV_top 10
#define kImageV_width 90
#define kImageV_height 80
#define kShopCartWidth 25

-(void)createGoodsListCellSubviews
{
    _listImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kImageV_left, kImageV_top, kImageV_width, kImageV_height)];
    _listImgV.contentMode = UIViewContentModeScaleAspectFit;
    _listImgV.image = kHolderImage;
    [self.contentView addSubview:_listImgV];
    
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(kImageV_left+_listImgV.right, _listImgV.top, kScreen_width-kImageV_left*2-_listImgV.width, 20)];
    _titleL.text = @"汇源果肉饮料 2.5L";
    _titleL.textColor = kBlack_Color_2;
    _titleL.font = [UIFont systemFontOfSize:kFontSize_2];
    [self.contentView addSubview:_titleL];
    
    _priceL = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.left, _titleL.bottom+(_listImgV.height-_titleL.height-_titleL.height), 60, _titleL.height)];
    _priceL.text = @"¥25.0";
    _priceL.textColor = kRed_PriceColor;
    _priceL.font = [UIFont systemFontOfSize:kFontSize_3];
    [self.contentView addSubview:_priceL];
    
//    _cartBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    _cartBtn.frame = CGRectMake(kScreen_width-30-70, 0, 70, kShopCartWidth);
//    if (!_addGoodsToCar) {
//        [_cartBtn setTitle:@"立即购买" forState:UIControlStateNormal];
//    }else{
//    
//        [_cartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
//
//    }
//    [_cartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _cartBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_3];
//    _cartBtn.layer.cornerRadius = 5;
//    _cartBtn.backgroundColor = kRedColor;
//    _cartBtn.centerY = _priceL.centerY;
//    [_cartBtn addTarget:self action:@selector(cartBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_cartBtn];
    
    _selectCountV = [[SelectCountView alloc] initWithFrame:CGRectMake(kScreen_width-20-90, 0, 90, kShopCartWidth)];
    _selectCountV.centerY = _priceL.centerY;
    _selectCountV.minusBtn.tag = 550;
    _selectCountV.plusBtn.tag = 551;
    [_selectCountV.minusBtn addTarget:self action:@selector(listCountAction:) forControlEvents:UIControlEventTouchUpInside];
    [_selectCountV.plusBtn addTarget:self action:@selector(listCountAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectCountV];
    
}

-(void)listCountAction:(UIButton *)button
{
    if (self.selectCountBlock) {
        self.selectCountBlock(button);
    }
}

-(void)setIsList:(BOOL)isList
{
    _isList = isList;
    if (_isList) {
        UIImageView *addCartBtn = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width-20-_selectCountV.width-10-kShopCartWidth, _selectCountV.top, kShopCartWidth, kShopCartWidth)];
        addCartBtn.image = [UIImage imageNamed:@"home_smallCart"];
        addCartBtn.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addCartAction:)];
        [addCartBtn addGestureRecognizer:tap];
        [self.contentView addSubview:addCartBtn];
        
        _tejiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(_priceL.right, _priceL.top, 40, _priceL.height)];
        _tejiaLabel.font = [UIFont systemFontOfSize:kFontSize_4];
        _tejiaLabel.textColor = kBlack_Color_3;
        
    }
}

-(void)setTejiaPrice:(float)tejiaPrice
{
    _tejiaPrice = tejiaPrice;
    if (_tejiaPrice > 0) {
        _tejiaLabel.text = [NSString stringWithFormat:@"¥%.1f",_tejiaPrice];
        [[YanMethodManager defaultManager] addMiddleLineOnString:_tejiaLabel];
        [self.contentView addSubview:_tejiaLabel];
    }
}



-(void)addCartAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"=== add into cart");
    if (self.addCartBlock) {
        self.addCartBlock(tap);
    }
}

-(void)setMarkStr:(NSString *)markStr
{
    _markStr = markStr;
    CGFloat markWidth = [[YanMethodManager defaultManager] LabelWidthByText:_markStr height:20 font:kFontSize_3]+10;
    UILabel *markLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.left, _titleL.bottom+10, markWidth, 20)];
    UIColor *color;
    if ([_markStr isEqualToString:@"满减"]) {
        color = kColorWithRGB(76, 209, 224);
    } else if ([_markStr isEqualToString:@"特价优惠"]) {
        color = kColorWithRGB(152, 208, 85);
    } else {
        color = kColorWithRGB(145, 167, 253);
    }
    markLabel.backgroundColor = color;
    markLabel.text = _markStr;
    markLabel.textColor = [UIColor whiteColor];
    markLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    markLabel.centerY = _listImgV.centerY;
    markLabel.textAlignment = NSTextAlignmentCenter;
    markLabel.layer.cornerRadius = 3;
    markLabel.clipsToBounds = YES;
    [self.contentView addSubview:markLabel];
}

-(void)setHasPurchased:(BOOL)hasPurchased
{
    _hasPurchased = hasPurchased;
//    if (_hasPurchased) {
//        [_cartBtn setTitle:@"再次购买" forState:UIControlStateNormal];
//    }
}

-(void)cartBtnAction:(UIButton *)button
{
    if (self.cartBlock) {
        self.cartBlock();
    }
}

-(void)setGoodsItem:(HomeGoodsItem *)goodsItem
{
    _goodsItem = goodsItem;
    [_listImgV sd_setImageWithURL:[NSURL URLWithString:_goodsItem.goods_pic] placeholderImage:kHolderImage];
    NSString *title = _goodsItem.goods_name ? _goodsItem.goods_name : _goodsItem.item_name;
    _titleL.text = title;
    float price = _goodsItem.tjprice > 0 ? _goodsItem.tjprice : _goodsItem.price;
    if (price <= 0) {
        price = goodsItem.goods_price;
    }
    _priceL.text = [NSString stringWithFormat:@"¥%.1f",price];
}
-(void)setHomegoodsitem:(HomeGoodsItem*)homegoodsitem{
    
    _homegoodsitem = homegoodsitem;
    [_listImgV sd_setImageWithURL:[NSURL URLWithString:_homegoodsitem.goods_pic] placeholderImage:kHolderImage];
    _titleL.text = _homegoodsitem.item_name;
    _priceL.text = [NSString stringWithFormat:@"￥%.1f",_homegoodsitem.price];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setSearchModel:(goodsClassify *)searchModel{
    _searchModel = searchModel;
    [_listImgV sd_setImageWithURL:[NSURL URLWithString:_searchModel.goods_pic] placeholderImage:kHolderImage];
    _titleL.text = _searchModel.goods_name;
    _priceL.text = [NSString stringWithFormat:@"￥%.2f",_searchModel.goods_price];
}
@end
