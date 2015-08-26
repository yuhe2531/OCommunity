//
//  GoodsSecondClassifyTableViewCell.m
//  OCommunity
//
//  Created by runkun2 on 15/7/2.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "GoodsSecondClassifyTableViewCell.h"

@implementation GoodsSecondClassifyTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, self.contentView.height)];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.textColor = [UIColor darkGrayColor];
        _titleLable.text = @"dadjagdjadaj";

        _titleLable.font = [UIFont systemFontOfSize:kFontSize_3];
        _titleLable.numberOfLines = 0;
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2,self.contentView.height)];
        [_selectView setBackgroundColor:kRedColor];
        [self.contentView addSubview:_titleLable];
        [self.contentView addSubview:_selectView];
    }

    return self;

}
-(void)setTitleString:(NSString *)titleString{
    
    _titleString = titleString;
    _titleLable.text = _titleString;

}
-(void)setIsSelected:(BOOL)isSelected{

    if (isSelected) {
        
        _selectView.hidden =NO;
        _titleLable.textColor = kRedColor;
    }else{
    
        _selectView.hidden =YES;
        _titleLable.textColor = [UIColor darkGrayColor];

    }


}
@end
