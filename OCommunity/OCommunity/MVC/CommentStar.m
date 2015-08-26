//
//  CommentStar.m
//  OCommunity
//
//  Created by runkun2 on 15/6/16.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "CommentStar.h"

@implementation CommentStar{


    UIView *yellowView; //黄色星星


}
//当创建当前类的对象时,使用alloc方式会调用此方法
- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self _creatSubviews];
    }
    
    return self;
    
    
}

- (void)_creatSubviews{

    UIImage *grayImage = [UIImage imageNamed:@"evaluate_gray"];
    UIImage *yellowImage = [UIImage imageNamed:@"evaluate_gold"];
    
    //灰色星星视图
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, grayImage.size.width * 5, grayImage.size.height)];
    grayView.backgroundColor = [UIColor colorWithPatternImage:grayImage];
    [self addSubview:grayView];
    
    //黄色星星视图
    yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, grayImage.size.width * 5, grayImage.size.height)];
    yellowView.backgroundColor = [UIColor colorWithPatternImage:yellowImage];
    [self addSubview:yellowView];
    

    self.width = self.height * 5;
    
    //通过外部传入的高度设置星星缩放的比例
    float scale = self.frame.size.height / yellowImage.size.height;
    grayView.transform = CGAffineTransformMakeScale(scale, scale);
    yellowView.transform = CGAffineTransformMakeScale(scale, scale);
 
    grayView.origin = CGPointZero;
    yellowView.origin = CGPointZero;
    
    
    
    
}

//通过外部传入的分数,设置黄色星星的大小
- (void)setRating:(CGFloat)rating{
    
    _rating = rating;
    
    float width =  _rating / 5 * self.frame.size.width;

    yellowView.width = width;
    
    
}

@end
