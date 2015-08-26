//
//  HomeTopAdView.h
//  OCommunity
//
//  Created by Runkun1 on 15/6/23.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopHomeModel;

typedef void(^TapAdBlock)(UITapGestureRecognizer *);

@interface HomeTopAdView : UIView

@property (nonatomic, copy) TapAdBlock tapAdBlock;

-(id)initWithFrame:(CGRect)frame showDuck:(TopHomeModel *)showDuck showCrayfish:(TopHomeModel *)showCrayfish;

@end
