//
//  ContentCollectionViewCell.h
//  OCommunity
//
//  Created by Runkun1 on 15/5/15.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectCountView.h"
#import "HomeGoodsItem.h"
#import "goodsClassify.h"
typedef void(^TapCartBlock)(UITapGestureRecognizer *);

@interface ContentCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) SelectCountView *selectCountView;
@property (nonatomic, copy) TapCartBlock tapCartBlock;
@property (nonatomic, strong) UIImageView *topImageView;

@property (nonatomic, strong) HomeGoodsItem *item;

-(id)initWithFrame:(CGRect)frame item:(HomeGoodsItem *)item;
@property (nonatomic,strong)goodsClassify *goodsModel;
@end
