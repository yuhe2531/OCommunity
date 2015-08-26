//
//  SuperMarketListTableViewCell.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/23.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#define kMargin_top 10
#define kMargin_left 15
#define kMargin_right 10

#import "SuperMarketListTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface SuperMarketListTableViewCell ()

@property (nonatomic, strong) UIImageView *listImgV;
@property (nonatomic, strong) UILabel *distance;
@property (nonatomic,strong) UILabel *address;

@end

@implementation SuperMarketListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSupermarketCellSubviews];
    }
    return self;
}

#define kImage_width 70
#define kImage_height 70

-(void)createSupermarketCellSubviews
{
//    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
//    _listImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin_left, kMargin_top, kImage_width, kImage_height)];
//    _listImgV.image = [UIImage imageNamed:@"holder.png"];
//    [self.contentView addSubview:_listImgV];
    
    _marketName = [[UILabel alloc] initWithFrame:CGRectMake(kMargin_right, kMargin_top, kScreen_width-120-30, 25)];
    _marketName.text = @"零步社区";
    _marketName.textColor = kBlack_Color_2;
    _marketName.font = [UIFont systemFontOfSize:kFontSize_2];
    [self.contentView addSubview:_marketName];
    
    _distance = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_width-80-40, _marketName.top, 80, _marketName.height)];
    _distance.text = @"0.5km";
    _distance.textColor = kBlack_Color_3;
    _distance.font = [UIFont systemFontOfSize:kFontSize_4];
    _distance.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_distance];
    
    _address = [[UILabel alloc] initWithFrame:CGRectMake(_marketName.left, _distance.bottom+5, kScreen_width-70, 20)];
    _address.text = @"地址:华能路与化纤厂路交叉口";
    _address.textColor = kBlack_Color_2;

    _address.font = [UIFont systemFontOfSize:kFontSize_3];
    [self.contentView addSubview:_address];
}

-(void)setMarket:(Market *)market
{
    _market = market;
    [_listImgV sd_setImageWithURL:[NSURL URLWithString:_market.pic] placeholderImage:kHolderImage];
    _marketName.text = _market.store_name;
    _distance.text = [NSString stringWithFormat:@"%.2fkm",_market.dis.floatValue];
    _address.text = _market.address;
}

-(void)clickMarketCellBtn
{
    if (self.cellBlock) {
        self.cellBlock();
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setSearchStoreModel:(goodsClassify *)searchStoreModel{
    _searchStoreModel = searchStoreModel;
    
    _marketName.text = _searchStoreModel.store_name;
    if (!_marketCollectionList) {
        _distance.text = [NSString stringWithFormat:@"%.1fkm",_searchStoreModel.store_dis];
    }else{
            _distance.text = nil;
    }
    _address.text = _searchStoreModel.store_address;


}
-(void)setSearchMarket:(goodsClassify *)searchMarket{
   
    _searchMarket = searchMarket;
    
    _marketName.text = _searchMarket.store_name;
    _distance.text = [NSString stringWithFormat:@"%.1fkm",_searchMarket.dis];
    _address.text = _searchMarket.address;

}
-(void)setMarketModel:(Market *)marketModel{

    _marketModel = marketModel;
    
    _marketName.text = _marketModel.store_name;
    _distance.text = nil;
    _address.text = _marketModel.address;
    
}
@end
