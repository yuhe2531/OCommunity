//
//  CartSectionView.h
//  OCommunity
//
//  Created by Runkun1 on 15/5/19.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBlock)(UIButton *);

@interface CartSectionView : UIView

@property (nonatomic, copy) SelectBlock selectBlock;
@property (nonatomic, assign) BOOL isSelected;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
