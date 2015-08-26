//
//  OrderTableViewCell.h
//  diangdan
//
//  Created by runkun3 on 15/7/21.
//  Copyright (c) 2015年 runkun3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "UIImageView+WebCache.h"
@interface OrderTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *imageV;
@property (nonatomic,strong)UILabel *storeName;
@property (nonatomic,strong)UILabel *storePrice;
@property (nonatomic,strong)UILabel *timeLabel;//支付时间
@property (nonatomic,strong)UILabel *finishLabel;//完成订单
@property (nonatomic,strong)UIImageView *lineImaV;
@property (nonatomic,strong)UIImageView *cellBottonV;
@property (nonatomic,copy) OrderModel *myOrders;
@end
