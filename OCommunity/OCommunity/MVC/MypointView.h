//
//  MypointView.h
//  OCommunity
//
//  Created by runkun2 on 15/5/19.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MypointView : UIView
-(id)initWithFrame:(CGRect)frame withImageName:(NSString *)name;
@property(nonatomic,copy)NSString *title;
@end
