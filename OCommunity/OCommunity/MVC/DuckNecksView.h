//
//  DuckNecksView.h
//  OCommunity
//
//  Created by Runkun1 on 15/6/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NeckView;

typedef void(^BuyNeckBlock)(UIButton *);

@interface DuckNecksView : UIView

@property (nonatomic, copy) BuyNeckBlock buyNeckBlock;

@end
