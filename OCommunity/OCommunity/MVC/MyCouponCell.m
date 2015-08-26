//
//  MyCouponCell.m
//  OCommunity
//
//  Created by runkun3 on 15/7/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MyCouponCell.h"
#define kViewWidth  _bigView.frame.size.width

@interface MyCouponCell ()

@property (nonatomic, strong) UILabel *storeNameL;

@end

@implementation MyCouponCell
{
    UIImage *image;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatCouponView];
    }
    return self;
}
-(void)creatCouponView{
    
    _moneyNum = [[UILabel alloc]initWithFrame:CGRectMake(20, 27, 75, kScreen_width/7)];
    _moneyNum.font = [UIFont boldSystemFontOfSize:25];
    _moneyNum.textColor = kColorWithRGB(243, 86, 90);
    _beginUse = [[UILabel alloc]initWithFrame:CGRectMake(_moneyNum.right+10, _moneyNum.top, kScreen_width/2, 16)];
    
    _beginUse.textColor = kColorWithRGB(100, 100, 100);
    _beginUse.font = [UIFont systemFontOfSize:14];
    
    _storeNameL = [[UILabel alloc] initWithFrame:CGRectMake(_beginUse.left, _beginUse.bottom+10, _beginUse.width, _beginUse.height)];
    _storeNameL.textColor = kColorWithRGB(100, 100, 100);
    _storeNameL.font = [UIFont systemFontOfSize:14];
    
    _useTime = [[UILabel alloc]initWithFrame:CGRectMake(_beginUse.left, _storeNameL.bottom+10, kScreen_width/2, 16)];
    _useTime.textColor = kColorWithRGB(100, 100, 100);
    _useTime.font =[UIFont systemFontOfSize:14];
    //cell上面的白色底图
    _bigView = [[UIView alloc]initWithFrame:CGRectMake(_moneyNum.left, 5, kScreen_width-_moneyNum.left*2, 120)];
    [_bigView setBackgroundColor:[UIColor whiteColor]];
    _bigView.layer.cornerRadius = 10;
    _bigView.backgroundColor=[UIColor whiteColor];
    //   波浪线
    _topImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,_bigView.width, 5)];
    _topImageV.image = [UIImage imageNamed:@"orderCell_topImage"];
    //已使用印章
    _useImage = [[ UIImageView alloc ]initWithFrame:CGRectMake( kScreen_width*7/12, _beginUse.top, (110-_beginUse.top)*167/145, 110-_beginUse.top)];
    [_bigView addSubview:_useImage];
    [_bigView addSubview:_topImageV];
    [_bigView addSubview:_moneyNum];
    [_bigView addSubview:_beginUse];
    [_bigView addSubview:_useTime];
    [_bigView addSubview:_storeNameL];
    [self.contentView addSubview:_bigView];
    self.backgroundColor = kBackgroundColor;
    
   
}
-(void)setCouponModel:(MyCouponModel *)couponModel{
    _couponModel = couponModel;
    _moneyNum.text = [NSString stringWithFormat:@"¥ %.1f",_couponModel.amount];
    _useTime.text = [NSString stringWithFormat:@"有效期至:%@",_couponModel.end_time];
    if (_couponModel.type==2) {
        if (_couponModel.xianzhi<=_couponModel.amount) {
            _beginUse.text = [NSString stringWithFormat:@"[商户券]%.1f元以上使用",_couponModel.amount];
            
        }else{
            _beginUse.text = [NSString stringWithFormat:@"[商户券]%.1f元起开始使用",_couponModel.xianzhi];
        }
        _storeNameL.text = [NSString stringWithFormat:@"仅限\"%@\"使用",_couponModel.store_name];
    }else{
        if (_couponModel.xianzhi<=_couponModel.amount) {
            _beginUse.text = [NSString stringWithFormat:@"[普通券]%.1f元以上使用",_couponModel.amount];
            
        }else{
            _beginUse.text = [NSString stringWithFormat:@"[普通券]%.1f元起开始使用",_couponModel.xianzhi];
            
        }
        _storeNameL.text = @"此优惠券在各商店通用";
    }

//    NSLog(@"^^^^%d",_couponModel.is_guoqi);
   
}
-(void)setUsed:(BOOL)used{
    
    if (used) {
        _useImage.hidden = NO;
        _useImage.image = [UIImage  imageNamed:@"used_circle"];
        _topImageV.image = [UIImage imageNamed:@"orderCell_topImage_gray"];
        _moneyNum.textColor = kBlack_Color_3;
        _beginUse.textColor = kBlack_Color_3;
        _useTime.textColor = kBlack_Color_3;
        _storeNameL.textColor = kBlack_Color_3;

    }else{
       
        _useImage.hidden = YES;
        _topImageV.image = [UIImage imageNamed:@"orderCell_topImage"];
        _moneyNum.textColor = kColorWithRGB(243, 86, 90);
        _beginUse.textColor = kColorWithRGB(100, 100, 100);
        _useTime.textColor = kColorWithRGB(100, 100, 100);
        _storeNameL.textColor = kColorWithRGB(100, 100, 100);

    }
}
-(void)setOverData:(BOOL)overData{
    if (overData) {
        _useImage.hidden = NO;
        _useImage.image = [UIImage imageNamed:@"myCoupon_overdata"];
        _topImageV.image = [UIImage imageNamed:@"orderCell_topImage_gray"];
        _moneyNum.textColor = kBlack_Color_3;
        _beginUse.textColor = kBlack_Color_3;
        _useTime.textColor = kBlack_Color_3;
        _storeNameL.textColor = kBlack_Color_3;
    }else{
        _useImage.hidden = YES;
        _topImageV.image = [UIImage imageNamed:@"orderCell_topImage"];
        _moneyNum.textColor = kColorWithRGB(243, 86, 90);
        _beginUse.textColor = kColorWithRGB(100, 100, 100);
        _useTime.textColor = kColorWithRGB(100, 100, 100);
        _storeNameL.textColor = kColorWithRGB(100, 100, 100);
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
