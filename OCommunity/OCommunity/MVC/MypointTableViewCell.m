//
//  MypointTableViewCell.m
//  OCommunity
//
//  Created by runkun2 on 15/5/19.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MypointTableViewCell.h"

@implementation MypointTableViewCell{
    UILabel *label;
    UILabel *numLabel1;
    UILabel *dateLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}
-(void)createSubviews{

    label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
    label.font = [UIFont systemFontOfSize:kFontSize_2];
    label.textColor = kBlack_Color_2;
    [self.contentView addSubview:label];
    numLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_width - 60, 10, 60, 20)];
    numLabel1.text = @"0";
//    numLabel1.textColor = kBlack_Color_2;
    numLabel1.font = [UIFont systemFontOfSize:kFontSize_2];
    [numLabel1 setTextColor:[UIColor redColor]];
    [numLabel1 setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:numLabel1];
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_width - 105, numLabel1.bottom +5, 100, 20)];
    dateLabel.font = [UIFont systemFontOfSize:kFontSize_4];
    dateLabel.text = @"2015-05-11";
    dateLabel.textColor = kBlack_Color_3;
    [dateLabel setTextAlignment:NSTextAlignmentCenter];

    [self.contentView addSubview:dateLabel];
}
-(void)setLabelText:(NSString *)labelText{

    _labelText = labelText;
    label.text = _labelText;

}
-(void)setMypointModel:(goodsClassify *)MypointModel{

    _MypointModel = MypointModel;
    label.text = _MypointModel.store_name;
    numLabel1.text = _MypointModel.totalScore;
    dateLabel.text = _MypointModel.add_time;
}
-(void)setTotalPoint:(NSString *)totalPoint{
    _totalPoint = totalPoint;
}


@end
