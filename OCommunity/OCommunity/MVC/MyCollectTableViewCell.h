//
//  MyCollectTableViewCell.h
//  OCommunity
//
//  Created by runkun2 on 15/5/21.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goodsClassify.h"
typedef void(^GoodsListCartBlock)(void);

@interface MyCollectTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) GoodsListCartBlock cartBlock;
@property (nonatomic, strong) UIButton *cartBtn;
@property (nonatomic, assign) BOOL hasPurchased;
@property (nonatomic, copy) NSString *markStr;

@property (nonatomic, strong) UIImageView *listImgV;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *priceL;

@property(nonatomic,copy)goodsClassify *goodsCollection;
@end
