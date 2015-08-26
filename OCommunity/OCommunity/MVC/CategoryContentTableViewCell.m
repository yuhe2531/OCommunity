//
//  CategoryContentTableViewCell.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "CategoryContentTableViewCell.h"

@interface CategoryContentTableViewCell ()

@property (nonatomic, strong) UIImageView *titleImgV;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *priceL;

@end

@implementation CategoryContentTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCategoryContentCellSubviews];
    }
    return self;
}

#define ktitleImgV_left 15
#define kTitleImgV_top 10
#define kTitleImgV_width 50
#define kTitleImgV_height 40

-(void)createCategoryContentCellSubviews
{
    _titleImgV = [[UIImageView alloc] initWithFrame:CGRectMake(ktitleImgV_left, kTitleImgV_top, kTitleImgV_width, kTitleImgV_height)];
    _titleImgV.backgroundColor = KRandomColor;
    _titleImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_titleImgV];
    
    CGFloat width = kScreen_width - 100;
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(_titleImgV.right+10, _titleImgV.top, width-_titleImgV.width-25, 20)];
    _titleL.font = [UIFont systemFontOfSize:kFontSize_2];
    _titleL.text = @"哇哈哈营养快线果汁饮料";
    [self.contentView addSubview:_titleL];

    _priceL = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.left, _titleL.bottom, _titleL.width-60, 20)];
    _priceL.text = @"¥45.00";
    _priceL.textColor = kRedColor;
    _priceL.font = [UIFont systemFontOfSize:kFontSize_3];
    [self.contentView addSubview:_priceL];
    
    UIImageView *cartImgV = [[UIImageView alloc] initWithFrame:CGRectMake(_priceL.right, _titleL.bottom, 25, 25)];
    cartImgV.image = kHolderImage;
    cartImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryCellCartBtnAction:)];
    [cartImgV addGestureRecognizer:tap];
    [self.contentView addSubview:cartImgV];
}

-(void)categoryCellCartBtnAction:(UITapGestureRecognizer *)tap
{
    if (self.categoryCartBlock) {
        self.categoryCartBlock(tap);
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
