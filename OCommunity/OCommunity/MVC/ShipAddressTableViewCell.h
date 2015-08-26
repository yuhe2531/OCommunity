//
//  ShipAddressTableViewCell.h
//  OCommunity
//
//  Created by Runkun1 on 15/5/4.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goodsClassify.h"
typedef void(^MarkBtnBlock)(void);

@interface ShipAddressTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *phoneNumL;
@property (nonatomic, strong) UILabel *addressL;
@property (nonatomic, strong) UIButton *markBtn;
@property (nonatomic, copy) MarkBtnBlock markBtnBlock;
@property (nonatomic, assign) BOOL isSelect;
@property(nonatomic,copy)goodsClassify *addressModel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier address:(NSString *)address;

@end
