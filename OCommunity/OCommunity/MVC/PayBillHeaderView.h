//
//  PayBillHeaderView.h
//  OCommunity
//
//  Created by Runkun1 on 15/5/22.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayBillHeaderView;

typedef void(^RemarkBlock)(PayBillHeaderView *, UIButton *);

@interface PayBillHeaderView : UIView

@property (nonatomic, strong) UILabel *superNameL;
@property (nonatomic, copy) RemarkBlock remarkBlock;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
