//
//  OrderTableViewCell.m
//  diangdan
//
//  Created by runkun3 on 15/7/21.
//  Copyright (c) 2015年 runkun3. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

#define kBlack_Color_4 [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0]

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatOrderSubviews];
    }
    return self;
}

-(void)creatOrderSubviews{
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 20)];
    _timeLabel.text = @"2015-7-21";
    _timeLabel.textColor = kColorWithRGB(137, 137, 137);
    [self.contentView addSubview:_timeLabel];
    
    _finishLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_width-_timeLabel.left-60, 5, 60, 20)];
    _finishLabel.text = @"订单完成";
    _finishLabel.textColor = kColorWithRGB(51, 51, 51);
    _finishLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    [self.contentView addSubview:_finishLabel];
    
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10,_timeLabel.top+50, 100, 100)];
    [_imageV setImage:[UIImage imageNamed:@"holder_red"]];
    [self.contentView addSubview:_imageV];
    
    _storeName = [[UILabel alloc]initWithFrame:CGRectMake(_imageV.right+5,_imageV.top+10,kScreen_width-_imageV.width-15, 20)];
    _storeName.text = @"零步社区超市";
    _storeName.textColor = kColorWithRGB(67, 67, 67);
    _storeName.font = [UIFont systemFontOfSize:kFontSize_2];
    [self.contentView addSubview:_storeName];
    
    _lineImaV = [[UIImageView alloc]initWithFrame:CGRectMake(0, _finishLabel.top+27, kScreen_width, 1)];
    _lineImaV.backgroundColor = kColorWithRGB(218, 218, 218);
    [self.contentView addSubview:_lineImaV];
    _cellBottonV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 170, kScreen_width, _finishLabel.top+10)];
    _cellBottonV.backgroundColor =kBlack_Color_4;
    [self.contentView addSubview:_cellBottonV];
    _storePrice = [[UILabel alloc]initWithFrame:CGRectMake(_imageV.right+5,_storeName.top+40,kScreen_width-_imageV.width-15, 20)];
    _storePrice.textColor = kColorWithRGB(137, 137, 137);
    _storePrice.text = @"￥888";
    _storePrice.font = [UIFont systemFontOfSize:kFontSize_3];
    [self.contentView addSubview:_storePrice];
    
}
-(void)setMyOrders:(OrderModel *)myOrders{
    _myOrders = myOrders;
    _finishLabel.text = @"订单完成";
    _storeName.text = _myOrders.store_name;
    _storePrice.text = [NSString stringWithFormat:@"¥ %.2f",_myOrders.zongjia+_myOrders.fare-_myOrders.hongbao-_myOrders.couponamount];
    _timeLabel.text = _myOrders.add_time;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:_myOrders.store_pic] placeholderImage:kHolderImage];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
