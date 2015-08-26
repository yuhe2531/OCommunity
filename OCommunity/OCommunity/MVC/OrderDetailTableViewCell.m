
//
//  OrderDetailTableViewCell.m
//  OCommunity
//
//  Created by runkun2 on 15/7/21.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "OrderDetailTableViewCell.h"
#define kTitleLabelWidth 70
#define kTitleLabelHeight 30
@implementation OrderDetailTableViewCell{
    UILabel *dateLabel;
    UILabel *moneyLabel;
    UILabel *sendGoodsLabel;
    UILabel *payMethod;
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
      NSArray *array = @[@"订单号:",@"下单时间:",@"支付方式:",@"联系人:",@"手机号码:",@"收货地址:"];
    for (int i =0; i<array.count; i++) {
        UILabel *titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(20, 15 +kTitleLabelHeight*i, kTitleLabelWidth, kTitleLabelHeight)];
        titleLabel.text = array[i];
        titleLabel.textColor = kColorWithRGB(67,67,67);;
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:titleLabel];
        
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setOrderDetailModel:(OrderDetailModel *)orderDetailModel{
    _orderDetailModel = orderDetailModel;
    if (_orderDetailModel.pay_type ==1) {
        _MethodOfPay = @"支付宝支付";
    }else if (_orderDetailModel.pay_type ==2){
    
    _MethodOfPay = @"微信支付";
    }
    NSString *string1 = [NSString stringWithFormat:@"%@",_orderDetailModel.order_sn];
    NSString *string2 = [NSString stringWithFormat:@"%@",_orderDetailModel.add_time];
    NSString *string3 = [NSString stringWithFormat:@"%@",_MethodOfPay];
    NSString *string4 = [NSString stringWithFormat:@"%@",_orderDetailModel.consigner];
    NSString *string5 = [NSString stringWithFormat:@"%@",_orderDetailModel.conmobile];
    NSString *string6 = [NSString stringWithFormat:@"%@",_orderDetailModel.member_address];
    NSArray *array = @[string1,string2,string3,string4,string5,string6];
    for (int i =0; i<array.count; i++) {
        UILabel *messageLabel =[[UILabel alloc] initWithFrame:CGRectMake(20+kTitleLabelWidth, 15 +kTitleLabelHeight*i, kScreen_width - 20 -kTitleLabelWidth, kTitleLabelHeight)];
        messageLabel.text = array[i];
        if (i==5) {
            messageLabel.numberOfLines = 0;
            //            messageLabel.height = kTitleLabelHeight * 2;
        }
        messageLabel.textColor = kColorWithRGB(104,104,104);;
        messageLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:messageLabel];
    }

}
@end
