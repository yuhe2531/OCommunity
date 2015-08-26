//
//  PayBillTableViewCell.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectCountView;
#import "CartGoodsItem.h"

typedef void(^SelectCountViewBlock)(UIButton *);

@interface PayBillTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *titleImgV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) SelectCountView *selectCountV;
@property (nonatomic, copy) SelectCountViewBlock selectCountBlock;
@property (nonatomic, strong) CartGoodsItem *goodsItem;

@end
