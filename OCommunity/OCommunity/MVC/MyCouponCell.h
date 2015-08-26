//
//  MyCouponCell.h
//  OCommunity
//
//  Created by runkun3 on 15/7/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCouponModel.h"
@interface MyCouponCell : UITableViewCell
@property (nonatomic,strong)UIImageView *topImageV;
@property (nonatomic,strong)UILabel     *moneyNum; //面值
@property (nonatomic,strong)UILabel     *useTime;  //有效期
@property (nonatomic,strong)UILabel     *beginUse; //起可以使用
@property (nonatomic,strong)UIView      *bigView;  //底图
@property (nonatomic,strong)UIImageView *useImage;
@property (nonatomic,assign)BOOL      used;
@property (nonatomic,assign)BOOL      overData;
@property (nonatomic,copy)MyCouponModel *couponModel;
@end
