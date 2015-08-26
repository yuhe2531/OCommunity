//
//  PaySuccessgoodsMessageTableViewCell.m
//  OCommunity
//
//  Created by runkun2 on 15/7/11.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "PaySuccessgoodsMessageTableViewCell.h"
#define kTitleLabelWidth 70
#define kTitleLabelHeight 25

@implementation PaySuccessgoodsMessageTableViewCell{
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
//    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kScreen_width, 30)];
//    dateLabel.text = @"下单时间: 2015-07-11 10:49:37";
//    dateLabel.textColor = kBlack_Color_2;
//    UILabel *shouldPayLable = [[UILabel alloc] initWithFrame:CGRectMake(20,dateLabel.bottom+5,80, 30)];
//    shouldPayLable.text = @"应付金额:";
//    shouldPayLable.textColor = kBlack_Color_2;
//    moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(shouldPayLable.right+5, dateLabel.bottom +5, kScreen_width, 30)];
//    moneyLabel.text = @"￥36.9";
//    moneyLabel.textColor = kBlack_Color_2;
//    moneyLabel.textColor = kRed_PriceColor;
//    sendGoodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,shouldPayLable.bottom+5,kScreen_width, 30)];
//    sendGoodsLabel.text = @"送货时间:  一个小时送达";
//    sendGoodsLabel.textColor = kBlack_Color_2;
//    payMethod = [[UILabel alloc] initWithFrame:CGRectMake(20, sendGoodsLabel.bottom +5, kScreen_width, 30)];
//    payMethod.text =@"支付方式: 货到付款";
//    payMethod.textColor = kBlack_Color_2;
//    [self.contentView addSubview: dateLabel];
//    [self.contentView addSubview:shouldPayLable];
//    [self.contentView addSubview:moneyLabel];
//    [self.contentView addSubview:sendGoodsLabel];
//    [self.contentView addSubview:payMethod];
    NSArray *array = @[@"下单时间:",@"实付金额:",@"运       费:",@"支付方式:"];
    for (int i =0; i<array.count; i++) {
        
        UILabel *titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(20, 15 +kTitleLabelHeight*i, kTitleLabelWidth, kTitleLabelHeight)];
        titleLabel.text = array[i];
        titleLabel.textColor = kBlack_Color_2;
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:titleLabel];
        
    }
}

-(void)setPayMethodString:(NSString *)payMethodString{
    _payMethodString = payMethodString;
    NSString *string1 = [NSString stringWithFormat:@"%@",_receiveOrderTime];
    NSString *string2 = [NSString stringWithFormat:@"￥%@",_moneyToPay];
    NSString *string3 = [NSString stringWithFormat:@"￥%@",_transportePay];
    NSString *string4 = [NSString stringWithFormat:@"%@",_payMethodString];
    NSArray *array = @[string1,string2,string3,string4];
    for (int i =0; i<array.count; i++) {
    UILabel *messageLabel =[[UILabel alloc] initWithFrame:CGRectMake(20+kTitleLabelWidth, 15 +kTitleLabelHeight*i, kScreen_width - 20 -kTitleLabelWidth, kTitleLabelHeight)];
    messageLabel.text = array[i];
    messageLabel.textColor = kBlack_Color_2;
    messageLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:messageLabel];
    }



}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
