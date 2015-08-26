//
//  GoodsListTableViewCell.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/27.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeGoodsItem.h"
#import "goodsClassify.h"
#import "SelectCountView.h"

typedef void(^GoodsListCartBlock)(void);
typedef void(^AddCartBlock)(UITapGestureRecognizer *);
typedef void(^SelectCountBlock)(UIButton *);

@interface GoodsListTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isList;
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) GoodsListCartBlock cartBlock;
@property (nonatomic, strong) SelectCountView *selectCountV;
@property (nonatomic, assign) BOOL hasPurchased;
@property (nonatomic, copy) NSString *markStr;
@property (nonatomic, strong) HomeGoodsItem *goodsItem;
@property(nonatomic,copy)goodsClassify *searchModel;
@property (nonatomic, copy) AddCartBlock addCartBlock;
@property (nonatomic, strong)   HomeGoodsItem *homegoodsitem;
@property (nonatomic, assign) float tejiaPrice;
@property (nonatomic, copy) SelectCountBlock selectCountBlock;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier witnAddgoodsToCar:(BOOL)car;
@end