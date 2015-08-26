
//
//  MypointView.m
//  OCommunity
//
//  Created by runkun2 on 15/5/19.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MypointView.h"

@implementation MypointView{

    UILabel *label;

}

-(id)initWithFrame:(CGRect)frame withImageName:(NSString *)name{

    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_width-100)/2, 0, 100, 100)];
        [imageView setImage:[UIImage imageNamed:name]];
        label =[[UILabel alloc] initWithFrame:CGRectMake(0,imageView.bottom +20,kScreen_width, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor darkGrayColor];
        [self addSubview:imageView];
        [self addSubview:label];
    }

    return self;

}
-(void)setTitle:(NSString *)title{

    _title = title;
    label.text = _title;

}
@end
