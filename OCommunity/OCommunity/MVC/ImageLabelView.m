//
//  ImageLabelView.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/16.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "ImageLabelView.h"

@implementation ImageLabelView

-(id)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.height-10, self.height-10)];
        imageV.image = image;
        [self addSubview:imageV];
        imageV.centerY = self.height/2;
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(imageV.right+10, imageV.top, self.width-imageV.width-10, self.height)];
        titleL.text = title;
        titleL.textColor = kBlack_Color_2;
        titleL.font = [UIFont systemFontOfSize:kFontSize_2];
        [self addSubview:titleL];
        titleL.centerY = self.height/2;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = self.bounds;
        [button addTarget:self action:@selector(imageLabelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

-(void)imageLabelBtnAction
{
    if (self.imageLabelBlcok) {
        self.imageLabelBlcok();
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
