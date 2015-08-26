//
//  PaySuccessmemberMessageTableViewCell.m
//  OCommunity
//
//  Created by runkun2 on 15/7/11.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "PaySuccessmemberMessageTableViewCell.h"

@implementation PaySuccessmemberMessageTableViewCell{
    UILabel *nameLable;
    UILabel *numLabel;
    UILabel *addressLabel;
}

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    if (self) {
    
        [self createCellContentView];
    }
    
    
    return self;


}
-(void)createCellContentView{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 50, 30)];
    label.text = @"收货人:";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = kBlack_Color_2;
    nameLable = [[UILabel alloc] initWithFrame:CGRectMake(label.right+5, label.top, 150, 30)];
    nameLable.text = @"某某某";
    nameLable.font = [UIFont systemFontOfSize:14];

    nameLable.textColor = kBlack_Color_2;
    numLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_width - 150,label.top, 150,30)];
    numLabel.text = @"17686011782";
    numLabel.font = [UIFont systemFontOfSize:14];

    numLabel.textColor = kBlack_Color_2;
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, label.bottom+5, kScreen_width-40, 30)];
    addressLabel.textColor = kBlack_Color_2;
    addressLabel.text =@"";
    addressLabel.font = [UIFont systemFontOfSize:kFontSize_3];
//    CGFloat height = [[YanMethodManager defaultManager] titleLabelHeightByText:@"" width:kScreen_width-40 font:kFontSize_3];
    addressLabel.textColor = kBlack_Color_2;
    addressLabel.numberOfLines = 0;
//    addressLabel.height = height;
    [self.contentView addSubview: label];
    [self.contentView addSubview:nameLable];
    [self.contentView addSubview:addressLabel];
    [self.contentView addSubview:numLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setMemberName:(NSString *)memberName{
    _memberName = memberName;
    nameLable.text = _memberName;
    
}
-(void)setPhoneNum:(NSString *)phoneNum{
    _phoneNum = phoneNum;
    numLabel.text = _phoneNum;
}
-(void)setSendGoodsAddress:(NSString *)sendGoodsAddress{
    _sendGoodsAddress = sendGoodsAddress;
//    CGFloat height = [[YanMethodManager defaultManager] titleLabelHeightByText:_sendGoodsAddress width:kScreen_width-40 font:kFontSize_3];
    addressLabel.text = [@"收货地址:" stringByAppendingString:_sendGoodsAddress];
    
}

@end
