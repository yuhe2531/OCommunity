//
//  SuperMarketListTableViewCell.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/23.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Market.h"
#import "goodsClassify.h"
typedef void(^MarketCellBtnBlock)(void);

@interface SuperMarketListTableViewCell : UITableViewCell

@property (nonatomic,copy) MarketCellBtnBlock cellBlock;
@property (nonatomic, strong) UILabel *marketName;
@property (nonatomic, strong) Market *market;
@property (nonatomic, strong) goodsClassify *searchMarket;
@property(nonatomic,copy)goodsClassify *searchStoreModel;
@property (nonatomic, assign) BOOL marketCollectionList;
@property (nonatomic, strong) Market *marketModel;

@end
