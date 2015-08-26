//
//  FourthCategoryView.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/24.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapFourthBlock)(UITapGestureRecognizer *);

@interface FourthCategoryView : UIView

@property (nonatomic, copy) TapFourthBlock tapFourthBlock;
@property (nonatomic, strong) NSMutableArray *fourthItems;
@property (nonatomic, assign) NSInteger tempTag;

-(id)initWithFrame:(CGRect)frame tag:(NSInteger)tag;

@end
