//
//  FirstImageView.h
//  OCommunity
//
//  Created by Runkun1 on 15/5/14.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstImageView : UIView

//@property (nonatomic, strong) UIImageView *cartImageV;
@property (nonatomic, strong) UIImageView *titleImageV;

-(id)initWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl title:(NSString *)title presentPrice:(NSString *)presentPrice originPrice:(NSString *)originPrice;

@end
