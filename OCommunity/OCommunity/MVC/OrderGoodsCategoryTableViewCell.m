//
//  OrderGoodsCategoryTableViewCell.m
//  OCommunity
//
//  Created by runkun2 on 15/7/21.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "OrderGoodsCategoryTableViewCell.h"

@implementation OrderGoodsCategoryTableViewCell{

//    UILabel *goodsName;
//    UILabel *numGoods;
//    UILabel *priceLabel;
//
}

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createGoodsCategoryCell];
    }
    return self;
}
-(void)createGoodsCategoryCell{
   
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30, 17, 4, 4)];
    view.layer.cornerRadius = view.width/2;
    view.backgroundColor = kRedColor;
    _goodsName =[[UILabel alloc] initWithFrame:CGRectMake(view.right +10, 10, 140, 15)];
    _goodsName.text = @"馒头";
    _goodsName.textColor = kColorWithRGB(67,67,67);
    _goodsName.font = [UIFont systemFontOfSize:kFontSize_3];
    _numGoods = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_width - 120, 10, 60, 15)];
    _numGoods.text = @"x1";
    _numGoods.textColor = kColorWithRGB(137,137,137);
    _numGoods.font = [UIFont systemFontOfSize:kFontSize_3];
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_width -65, 11, 65, 15)];
    _priceLabel.text = @"￥1.2";
    _priceLabel.textColor = kColorWithRGB(137,137,137);
    _priceLabel.font = [UIFont systemFontOfSize:14];
    UIView *seperateView = [YanMethodManager lineViewWithFrame:CGRectMake(0, 34, kScreen_width, 1) superView:self.contentView];
    seperateView.backgroundColor = kColorWithRGB(223,223,223);
    [self.contentView addSubview:view];
    [self.contentView addSubview:_goodsName];
    [self.contentView addSubview:_numGoods];
    [self.contentView addSubview:_priceLabel];

}
-(void)setGoodsListModel:(Goods_ListModel *)goodsListModel{

    _goodsListModel = goodsListModel;
    _goodsName.text = _goodsListModel.item_name;
    _numGoods.text = [NSString stringWithFormat:@"x%.1f",_goodsListModel.number];
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_goodsListModel.price];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
