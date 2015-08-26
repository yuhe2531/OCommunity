//
//  MineCommenTableViewCell.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/27.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MineCommenTableViewCell.h"

@implementation MineCommenTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createMineCellSubviews];
    }
    return self;
}

#define kMarkImgv_left 15
#define kMarkImgv_top 10
#define kMarkImgv_width 25

-(void)createMineCellSubviews
{
    self.markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMarkImgv_left, kMarkImgv_top, kMarkImgv_width, kMarkImgv_width)];
    self.markImageView.image = kHolderImage;
    [self.contentView addSubview:_markImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarkImgv_left+_markImageView.right, _markImageView.top, 150, _markImageView.height)];
    _titleLabel.textColor = kBlack_Color_2;
    _titleLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    [self.contentView addSubview:_titleLabel];
}

- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
