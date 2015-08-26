//
//  NeckView.h
//  OCommunity
//
//  Created by Runkun1 on 15/6/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeckView : UIView

@property (nonatomic, strong) UIButton *buyBtn;

-(id)initWithFrame:(CGRect)frame tastStyle:(NSString *)tast price:(float)price imageName:(NSString *)image;

@end
