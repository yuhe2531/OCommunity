//
//  WarnView.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/16.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "WarnView.h"

@implementation WarnView

-(id)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorWithRGB(253, 239, 176);
        UIImageView *warnImgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 15, 15)];
        warnImgV.image = image;
        warnImgV.centerY = self.height/2;
        [self addSubview:warnImgV];
        
        UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(warnImgV.right+10, 0, kScreen_width-50-warnImgV.width, 20)];
        warnLabel.centerY = warnImgV.centerY;
        warnLabel.text = title;
        warnLabel.font = [UIFont systemFontOfSize:kFontSize_3];
        [self addSubview:warnLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
