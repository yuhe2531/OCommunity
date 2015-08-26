//
//  HomeTopAdView.m
//  OCommunity
//
//  Created by Runkun1 on 15/6/23.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "HomeTopAdView.h"
#import "TopHomeModel.h"
#import "UIImageView+WebCache.h"

@implementation HomeTopAdView

-(id)initWithFrame:(CGRect)frame showDuck:(TopHomeModel *)showDuck showCrayfish:(TopHomeModel *)showCrayfish
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBackgroundColor;
        [self createTopAdSubviewsWithShowDuck:showDuck showCrayfish:showCrayfish];
    }
    return self;
}

-(void)createTopAdSubviewsWithShowDuck:(TopHomeModel *)showDuck showCrayfish:(TopHomeModel *)showCrayfish
{
//    NSArray *imageNames = @[@"duck_neck",@"ad_crawfish"];
    CGFloat height = kScreen_width*107/375.0;
    
    if (showDuck.is_use == 1 && showCrayfish.is_use == 1) {
        for (int i = 0; i < 2; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (height + 10)*i, kScreen_width, height)];
//            imageView.image = [UIImage imageNamed:imageNames[i]];
            if (i == 0) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:showDuck.default_content] placeholderImage:kHolderImage];
            } else {
                [imageView sd_setImageWithURL:[NSURL URLWithString:showCrayfish.default_content] placeholderImage:kHolderImage];
            }
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.tag = 390 + i;
            [self addSubview:imageView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHomeAdAction:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tap];
        }
        return;
    }
    if ((showDuck.is_use != 1 || showCrayfish.is_use != 1) && (showCrayfish.is_use == 1 || showDuck.is_use == 1)) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height + 10, kScreen_width, height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (showDuck.is_use == 1) {
            imageView.tag = 390;
            [imageView sd_setImageWithURL:[NSURL URLWithString:showDuck.default_content] placeholderImage:kHolderImage];
        }
        if (showCrayfish.is_use == 1) {
            imageView.tag = 391;
            [imageView sd_setImageWithURL:[NSURL URLWithString:showCrayfish.default_content] placeholderImage:kHolderImage];
        }
        [self addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHomeAdAction:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
    }
    
    
}

-(void)tapHomeAdAction:(UITapGestureRecognizer *)tap
{
    if (self.tapAdBlock) {
        self.tapAdBlock(tap);
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
