//
//  ImageLabelView.h
//  OCommunity
//
//  Created by Runkun1 on 15/5/16.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageLabelView : UIView

typedef void(^ImageLabelBlock)();

@property (nonatomic, copy) ImageLabelBlock imageLabelBlcok;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image;

@end
