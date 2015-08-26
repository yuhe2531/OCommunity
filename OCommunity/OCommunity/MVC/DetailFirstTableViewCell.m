//
//  DetailFirstTableViewCell.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/27.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "DetailFirstTableViewCell.h"
#import "SelectCountView.h"

@implementation DetailFirstTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createDetailFirstCellSubviews];
    }
    return self;
}

#define kSelectCountView_left 15
#define kSelectCountView_top 10
#define kSelectCountView_width 95
#define kSelectCountView_height 20

#define kCartBtn_width 100

-(void)createDetailFirstCellSubviews
{
    _selectView = [[SelectCountView alloc] initWithFrame:CGRectMake(kSelectCountView_left, kSelectCountView_top, kSelectCountView_width, kSelectCountView_height)];
    _selectView.minusBtn.tag = 550;
    _selectView.plusBtn.tag = 551;
    [_selectView.minusBtn addTarget:self action:@selector(selectCellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_selectView.plusBtn addTarget:self action:@selector(selectCellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectView];
    
    UIButton *cartButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cartButton.frame = CGRectMake(kScreen_width-kSelectCountView_left-kCartBtn_width, 0, kCartBtn_width, 30);
    cartButton.centerY = _selectView.centerY;
    [cartButton setTitle:@"放入购物车" forState:UIControlStateNormal];
    [cartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cartButton.backgroundColor = KRandomColor;
    cartButton.tag = 552;
    cartButton.layer.cornerRadius = 5;
    [cartButton addTarget:self action:@selector(selectCellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cartButton];
}

-(void)selectCellBtnClicked:(UIButton *)button
{
    if (self.selectBlock) {
        self.selectBlock(button);
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
