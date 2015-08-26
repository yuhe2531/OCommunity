//
//  PayTableViewCell.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "PayTableViewCell.h"

@implementation PayTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createPayCellSubviews];
    }
    return self;
}

#define kTitleL_left 15
#define kTitleL_top 5
#define kTitleL_width 65
#define kTitleL_height 30

-(void)createPayCellSubviews
{
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(kTitleL_left, kTitleL_top, kTitleL_width, kTitleL_height)];
    _titleL.font = [UIFont systemFontOfSize:kFontSize_2];
    [self.contentView addSubview:_titleL];
    
    _payTF = [[UITextField alloc] initWithFrame:CGRectMake(_titleL.right+10, _titleL.top, kScreen_width-_titleL.width-50, _titleL.height)];
    _payTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _payTF.returnKeyType = UIReturnKeyDone;
    _payTF.font = [UIFont systemFontOfSize:kFontSize_3];
    [self.contentView addSubview:_payTF];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
