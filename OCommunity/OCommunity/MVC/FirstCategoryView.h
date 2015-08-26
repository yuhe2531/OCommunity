//
//  FirstCategoryView.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/24.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapFistActionBlock)(UITapGestureRecognizer *);

@interface FirstCategoryView : UIView

@property (nonatomic, copy) TapFistActionBlock tapFirstBlock;
@property (nonatomic, strong) NSMutableArray *firstItems;


@end
