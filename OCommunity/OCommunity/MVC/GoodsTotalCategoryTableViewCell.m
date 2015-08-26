//
//  GoodsTotalCategoryTableViewCell.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/15.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "GoodsTotalCategoryTableViewCell.h"

@interface GoodsTotalCategoryTableViewCell ()

{
    UILabel *bottomLine;
}


@end

@implementation GoodsTotalCategoryTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _topImgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
        _topImgV.image = kHolderImage;
        [self.contentView addSubview:_topImgV];
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(5, _topImgV.bottom+5, 80, 20)];
        _titleL.text = @"包装食品";
        _titleL.font = [UIFont systemFontOfSize:kFontSize_2];
        _titleL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleL];
        _topImgV.centerX = _titleL.centerX;
        
        bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.left, _titleL.bottom+5, _titleL.width, 2)];
        bottomLine.backgroundColor = kDividColor;
        [self.contentView addSubview:bottomLine];
    }
    return self;
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (_isSelected) {
        _titleL.textColor = kRedColor;
        bottomLine.backgroundColor = kRedColor;
    } else {
        _titleL.textColor = [UIColor blackColor];
        bottomLine.backgroundColor = kDividColor;
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
