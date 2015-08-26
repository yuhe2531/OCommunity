//
//  MyColllectionTableViewCell.h
//  OCommunity
//
//  Created by Runkun1 on 15/5/13.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeGoodsItem.h"

typedef void(^ListCartBlock)(UIButton *);

@interface MyColllectionTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) ListCartBlock cartBlock;
@property (nonatomic, strong) UIButton *cartBtn;

@property (nonatomic, strong)   HomeGoodsItem *homegoodsitem;
@property (nonatomic, assign) BOOL hasPurchased;


@end
