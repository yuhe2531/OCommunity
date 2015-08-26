//
//  HomeTopView.h
//  BrokerSJHL
//
//  Created by zhangyan on 14/12/18.
//  Copyright (c) 2014年 zhangyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonClickedBlock)(UIButton *button);
typedef void(^TapTopImageBlock)(UIImageView *imageV);

@interface HomeTopView : UIView<UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *topImagesArray;
@property (nonatomic,strong) UIScrollView *topScrollView;
@property (nonatomic,strong) UIPageControl *topPageControl;
@property (nonatomic,copy) ButtonClickedBlock topButtonBlock;
@property (nonatomic,copy) TapTopImageBlock tapTopImageBlock;
@property (nonatomic,strong) NSTimer *timer;

@end
