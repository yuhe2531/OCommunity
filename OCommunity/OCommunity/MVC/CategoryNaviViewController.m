//
//  CategoryNaviViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/6/27.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "CategoryNaviViewController.h"

@interface CategoryNaviViewController ()//<UIGestureRecognizerDelegate>

@end

@implementation CategoryNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.interactivePopGestureRecognizer.delegate = self;
    // Do any additional setup after loading the view.
}

//#pragma mark - Private Method
//
//- (BOOL)isRootViewController
//{
//    return (self == self.viewControllers.firstObject);
//}
//
//#pragma mark - UIGestureRecognizerDelegate
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if ([self isRootViewController]) {
//        return NO;
//    } else {
//        return YES;
//    }
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
