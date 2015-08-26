//
//  HomeTopView.m
//  BrokerSJHL
//
//  Created by zhangyan on 14/12/18.
//  Copyright (c) 2014年 zhangyan. All rights reserved.
//

#define kBtnM_top 15
#define kBtn_width 45
#define kBtn_btn_margin 35

#define kTopPageControl_width 100
#define kTopPageControl_height 20

#define kLabel_height 15
#define kLabel_fontSize 15
#define kLabel_width 80

#import "HomeTopView.h"
#import "UIImageView+WebCache.h"
#import "TopHomeModel.h"
@interface HomeTopView ()

@property (nonatomic,strong) NSMutableArray *showImageArray;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSMutableArray *allImageViewArray;//存放所有图片的数组

@end

@implementation HomeTopView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createTopSubViews];
        self.allImageViewArray = [NSMutableArray array];
        self.showImageArray = [NSMutableArray array];
    }
    return self;
}

-(void)createTopSubViews
{
    self.currentPage = 0;
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _topScrollView.delegate = self;
    _topScrollView.pagingEnabled = YES;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    [_topScrollView setBackgroundColor:[UIColor whiteColor]];
    _topScrollView.contentSize = CGSizeMake(self.width*3, _topScrollView.height);
    [self addSubview:_topScrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_topScrollView.bounds];
//    imageView.backgroundColor = KRandomColor;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = kHolderImage;
    [_topScrollView addSubview:imageView];
    
    self.topPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.width-kTopPageControl_width, _topScrollView.height-kTopPageControl_height, kTopPageControl_width, kTopPageControl_height)];
    _topPageControl.currentPageIndicatorTintColor = kRedColor;
    _topPageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [_topPageControl addTarget:self action:@selector(topPageControlAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_topPageControl];
    
}

-(void)setTopImagesArray:(NSMutableArray *)topImagesArray
{
    _topImagesArray = topImagesArray;
    
    if (_topImagesArray.count == 2) {
        _topPageControl.numberOfPages = _topImagesArray.count;
        _topPageControl.currentPage = 0;
    }
    
    if (_topImagesArray.count > 1) {
        //        [_topScrollView removeAllSubviews];
        for (int i = 0; i < _topImagesArray.count; i++) {
            TopHomeModel *model = [_topImagesArray objectAtIndex:i];
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(_topScrollView.width, 0, _topScrollView.width, _topScrollView.height)];
            [imgV sd_setImageWithURL:[NSURL URLWithString:model.default_content] placeholderImage:kHolderImage];
//            imgV.userInteractionEnabled = YES;
//            imgV.tag = 150+i;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopImageAction:)];
//            [imgV addGestureRecognizer:tap];
            
            [self.allImageViewArray addObject:imgV];
        }
        _topPageControl.numberOfPages = _topImagesArray.count;
        _topPageControl.currentPage = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.5 target:self selector:@selector(timerRepeatAction:) userInfo:nil repeats:YES];
    } else {
        _topScrollView.contentSize = CGSizeMake(_topScrollView.width*_topImagesArray.count, _topScrollView.height);
        
        for (int i = 0; i < _topImagesArray.count; i++) {
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.width*i, 0, _topScrollView.width, _topScrollView.height)];
//            imgV.backgroundColor = KRandomColor;
            imgV.contentMode = UIViewContentModeScaleAspectFit;
            imgV.userInteractionEnabled = YES;
            imgV.tag = 150+i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopImageAction:)];
            [imgV addGestureRecognizer:tap];
            [_topScrollView addSubview:imgV];
        }
    }
}

-(void)topPageControlAction:(UIPageControl *)pageControl
{
    _currentPage = pageControl.currentPage;
    [self currentPageChangedHandle];
}

-(void)buttonClickedAction:(UIButton *)button
{
    if (self.topButtonBlock) {
        self.topButtonBlock(button);
    }
}

-(void)tapTopImageAction:(UITapGestureRecognizer *)tap
{
    UIImageView *imageV = (UIImageView *)tap.view;
    if (self.tapTopImageBlock) {
        self.tapTopImageBlock(imageV);
    }
}

#pragma UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_topImagesArray.count > 1) {
        if (scrollView.contentOffset.x == 0) {
            if (_currentPage < 1) {
                _currentPage = _topImagesArray.count - 1;
            }  else {
                --_currentPage;
            }
        } else if (scrollView.contentOffset.x == 2*_topScrollView.width){
            if (_currentPage > _topImagesArray.count-2) {
                _currentPage = 0;
            } else {
                ++_currentPage;
            }
        }
        _topScrollView.contentOffset = CGPointMake(self.width, 0);
        _topPageControl.currentPage = _currentPage;
        [self currentPageChangedHandle];
    }
    
    _topPageControl.currentPage = _currentPage;
}

-(void)timerRepeatAction:(NSTimer *)timer
{
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint offset = _topScrollView.contentOffset;
        offset.x = offset.x + _topScrollView.width;
        _topScrollView.contentOffset = offset;
    }];
    
    _currentPage++;
    if (_currentPage == _topImagesArray.count) {
        _currentPage = 0;
    }
    _topPageControl.currentPage = _currentPage;
    
    [self performSelector:@selector(currentPageChangedHandle) withObject:nil afterDelay:0.5];
    
}

-(void)currentPageChangedHandle
{
    [_showImageArray removeAllObjects];
    if (_allImageViewArray.count > 2) {
        if (_currentPage == 0) {
            [_showImageArray addObject:_allImageViewArray.lastObject];
            [_showImageArray addObject:_allImageViewArray[_currentPage]];
            [_showImageArray addObject:_allImageViewArray[_currentPage+1]];
        } else if (_currentPage == _topImagesArray.count-1) {
            [_showImageArray addObject:_allImageViewArray[_currentPage-1]];
            [_showImageArray addObject:_allImageViewArray[_currentPage]];
            [_showImageArray addObject:_allImageViewArray[0]];
        } else {
            [_showImageArray addObject:_allImageViewArray[_currentPage-1]];
            [_showImageArray addObject:_allImageViewArray[_currentPage]];
            [_showImageArray addObject:_allImageViewArray[_currentPage+1]];
        }
        
    } else if (_allImageViewArray.count == 2) {
        if (_currentPage == 0) {
            [_showImageArray addObject:_allImageViewArray.lastObject];
            [_showImageArray addObject:_allImageViewArray[_currentPage]];
            [_showImageArray addObject:_allImageViewArray.lastObject];
        } else {
            [_showImageArray addObject:_allImageViewArray.firstObject];
            [_showImageArray addObject:_allImageViewArray[_currentPage]];
            [_showImageArray addObject:_allImageViewArray.firstObject];
        }
    }
    [_topScrollView removeAllSubviews];
    for (int j = 0; j < 3; j++) {
        UIImageView *showImage = (UIImageView *)_showImageArray[j];
        showImage.frame = CGRectMake(_topScrollView.width*j, 0, _topScrollView.width, _topScrollView.height);
        [_topScrollView addSubview:showImage];
    }
    
    if (_topScrollView.contentOffset.x >= 2*self.width) {
        CGPoint offset = _topScrollView.contentOffset;
        offset.x = self.width;
        _topScrollView.contentOffset = offset;
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
