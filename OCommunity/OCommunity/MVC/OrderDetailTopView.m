//
//  OrderDetailTopView.m
//  OCommunity
//
//  Created by runkun2 on 15/7/21.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "OrderDetailTopView.h"

@implementation OrderDetailTopView

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
    
        [self createOrderDetailTopSubViews];
        
    }
    return self;
}
-(void)createOrderDetailTopSubViews{
    self.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreen_width,20)];
    view.backgroundColor =kColorWithRGB(246, 246, 246);
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, view.bottom + 20, 20, 20)];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.right + 5, _imageView.top, kScreen_width - 40, 20)];
    _label.text = @"益万家超市";
    _label.textColor = kColorWithRGB(67,67,67);
    _label.font = [UIFont systemFontOfSize:kFontSize_2];
    [self addSubview:view];
    [self addSubview:_imageView];
    [self addSubview:_label];
    UIView *view1 = [YanMethodManager lineViewWithFrame:CGRectMake(0, 20, kScreen_width, 1) superView:self];
    view1.backgroundColor = kColorWithRGB(223, 223, 223);
     UIView *view2 = [YanMethodManager lineViewWithFrame:CGRectMake(0, 79, kScreen_width, 1) superView:self];
    view2.backgroundColor = kColorWithRGB(223, 223, 223);
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -1, kScreen_width, 1)];
    _lineView.backgroundColor = kColorWithRGB(223, 223, 223);
    [self addSubview:_lineView];


}

@end
