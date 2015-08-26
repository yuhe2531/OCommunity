//
//  ShipAddressTableViewCell.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/4.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "ShipAddressTableViewCell.h"
#import "NewAddressViewController.h"

@implementation ShipAddressTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier address:(NSString *)address
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createShipAddressSubviewsWithAddress:address];
    }
    return self;
}

#define kMargin_top 10
#define kMargin_left 15
#define kNameL_width 100
#define kNameL_height 25

#define kPhoneNumL_width 95

#define kMarkBtn_width 25
#define kMargin_right 10

-(void)createShipAddressSubviewsWithAddress:(NSString *)address
{
    _nameL = [[UILabel alloc] initWithFrame:CGRectMake(kMargin_left, kMargin_top, kNameL_width, kNameL_height)];
    _nameL.font = [UIFont systemFontOfSize:kFontSize_2];
    _nameL.text = @"欧阳雷雷";
    _nameL.textColor = kBlack_Color_2;
    [self.contentView addSubview:_nameL];
    
    _phoneNumL = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_width-2*kMargin_right-kMarkBtn_width-kPhoneNumL_width, _nameL.top, kPhoneNumL_width, _nameL.height)];
    _phoneNumL.font = [UIFont systemFontOfSize:kFontSize_2];
    _phoneNumL.text = @"15165334898";
    _phoneNumL.textAlignment = NSTextAlignmentRight;
    _phoneNumL.textColor = kBlack_Color_2;
    [self.contentView addSubview:_phoneNumL];
    
    CGFloat width = kScreen_width-2*kMargin_right-kMargin_left-kMarkBtn_width;
    CGFloat height = [[YanMethodManager defaultManager] titleLabelHeightByText:address width:width font:kFontSize_3];
    _addressL = [[UILabel alloc] initWithFrame:CGRectMake(kMargin_left, _nameL.bottom+5, width, height)];
    _addressL.numberOfLines = 0;
    _addressL.font = [UIFont systemFontOfSize:kFontSize_3];
    _addressL.text = address;
    _addressL.textColor = kBlack_Color_2;
    [self.contentView addSubview:_addressL];
    
    _markBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _markBtn.frame = CGRectMake(kScreen_width-kMargin_right-kMarkBtn_width, 0, kMarkBtn_width, kMarkBtn_width);
    _markBtn.bottom = _addressL.bottom;
    [_markBtn addTarget:self action:@selector(addressMarkBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_markBtn];

//   UIButton *markBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    markBtn.frame = CGRectMake(kScreen_width-kMargin_right-kMarkBtn_width*2, 0, 50, 40);
//    markBtn.bottom = _addressL.bottom -5;
////        markBtn.backgroundColor = KRandomColor;
////    markBtn.layer.borderColor = [UIColor blackColor].CGColor;
////    markBtn.layer.borderWidth = 1;
//    [markBtn addTarget:self action:@selector(addressMarkBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:markBtn];

    
}

-(void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    if (_isSelect) {
        [_markBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    } else {
        [_markBtn setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
    }
}

-(void)addressMarkBtnAction
{
    if (self.markBtnBlock) {
        self.markBtnBlock();
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


    // Configure the view for the selected state
}
-(void)setAddressModel:(goodsClassify *)addressModel{

    _addressModel = addressModel;
    CGFloat width = kScreen_width-2*kMargin_right-kMargin_left-kMarkBtn_width;
    _addressL.height = [[YanMethodManager defaultManager] titleLabelHeightByText:_addressModel.address width:width font:kFontSize_3]; 
    _markBtn.bottom = _addressL.bottom;
    _nameL.text = _addressModel.consigner;
    _phoneNumL.text =_addressModel.mobile;
    _addressL.text = _addressModel.address;
    if (_addressModel.isdefault == 1) {
        self.isSelect = YES;
    } else {
        self.isSelect = NO;
    }

}

@end
