//
//  CartSectionView.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/19.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "CartSectionView.h"

@interface CartSectionView ()

@property (nonatomic, strong) UIButton *selectBtn;

@end

@implementation CartSectionView

#define kSelectBtn_width 25

-(id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        _isSelected = YES;
        self.backgroundColor = kColorWithRGB(239, 239, 244);
        _selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        _selectBtn.frame = CGRectMake(15, 0, kSelectBtn_width, kSelectBtn_width);
        _selectBtn.layer.cornerRadius = kSelectBtn_width/2;
        _selectBtn.clipsToBounds = YES;
        _selectBtn.centerY = self.height/2;
        [_selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectBtn];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(_selectBtn.right+20, 0, self.width-20-_selectBtn.width, self.height)];
        titleL.centerY = _selectBtn.centerY;
        titleL.text = title;
        titleL.font = [UIFont systemFontOfSize:kFontSize_2];
        [self addSubview:titleL];
    }
    return self;
}

-(void)selectBtnAction:(UIButton *)button
{
    _isSelected = !_isSelected;
    if (self.selectBlock) {
        self.selectBlock(button);
    }
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (_isSelected) {
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    } else {
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
