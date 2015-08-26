//
//  CityBtn.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/23.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CityBtnBlock)(void);

@interface CityBtn : UIView

@property (nonatomic, strong) UILabel *city;
@property (nonatomic, copy) CityBtnBlock cityBlock;

@end
