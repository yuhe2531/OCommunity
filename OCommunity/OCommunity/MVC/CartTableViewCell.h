//
//  CartTableViewCell.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/28.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartGoodsItem.h"
@class SelectCountView;

typedef void(^SelectCountVBlock)(UIButton *);
typedef void(^SelectGoodsBlock)(void);

@interface CartTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) UIButton *markBtn;
@property (nonatomic, strong) UIImageView *titleImgV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) SelectCountView *selectCountV;
@property (nonatomic, copy) SelectCountVBlock selectCountViewBlock;
@property (nonatomic, copy) SelectGoodsBlock selectGoodsBlock;
@property (nonatomic, strong) CartGoodsItem *cartItem;

@end
