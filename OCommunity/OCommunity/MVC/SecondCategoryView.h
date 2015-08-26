//
//  SecondCategoryView.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/24.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapSecondBlock)(UITapGestureRecognizer *);

@interface SecondCategoryView : UIView

@property (nonatomic, copy) TapSecondBlock tapBlock;
@property (nonatomic, strong) NSMutableArray *secondItems;


@end
