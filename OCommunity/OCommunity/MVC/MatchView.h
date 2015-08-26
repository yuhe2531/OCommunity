//
//  MatchView.h
//  OCommunity
//
//  Created by Runkun1 on 15/5/16.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MatchTapBlock)(UITapGestureRecognizer *);

@interface MatchView : UIView

@property (nonatomic, copy) MatchTapBlock matchTapBlock;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title matchGoods:(NSMutableArray *)goodsArray;

@end
