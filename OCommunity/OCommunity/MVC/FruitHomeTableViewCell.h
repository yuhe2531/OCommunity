//
//  FruitHomeTableViewCell.h
//  OCommunity
//
//  Created by Runkun1 on 15/7/4.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeGoodsItem.h"
#import "SelectCountView.h"

typedef void(^FruitCellAction)(UITapGestureRecognizer *);

@interface FruitHomeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *titleImgV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) SelectCountView *selectCountView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) HomeGoodsItem *goodsItem;
@property (nonatomic, copy) FruitCellAction fruitActionBlock;

@end
