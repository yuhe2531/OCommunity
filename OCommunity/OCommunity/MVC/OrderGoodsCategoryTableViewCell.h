//
//  OrderGoodsCategoryTableViewCell.h
//  OCommunity
//
//  Created by runkun2 on 15/7/21.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goods_ListModel.h"
@interface OrderGoodsCategoryTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *goodsName;
@property(nonatomic,strong)UILabel *numGoods;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,copy)Goods_ListModel *goodsListModel;
@end
