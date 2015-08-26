//
//  ThirdCategoryView.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/24.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapThirdBlock)(UITapGestureRecognizer *);

@interface ThirdCategoryView : UIView

@property (nonatomic, copy) TapThirdBlock tapThirdBlock;
@property (nonatomic, strong) NSMutableArray *thirdItems;

-(id)initWithFrame:(CGRect)frame;

@end
