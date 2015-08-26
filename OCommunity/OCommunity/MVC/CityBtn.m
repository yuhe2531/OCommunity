//
//  CityBtn.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/23.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "CityBtn.h"

@implementation CityBtn

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCityBtnSubviews];
    }
    return self;
}

-(void)createCityBtnSubviews
{
    _city = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width-20, self.height)];
    _city.font = [UIFont systemFontOfSize:kFontSize_3];
    _city.textColor = [UIColor whiteColor];
    _city.textAlignment = NSTextAlignmentCenter;
    _city.text = @"正在定位";
    [self addSubview:_city];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_city.width+5, _city.top, 15, 15)];
    imageView.centerY = self.height/2;
    imageView.image = [UIImage imageNamed:@"arrow_down"];
    [self addSubview:imageView];
    
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cityBtn.frame = self.bounds;
    [cityBtn addTarget:self action:@selector(cityBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cityBtn];
}

-(void)cityBtnAction
{
    if (self.cityBlock) {
        self.cityBlock();
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
