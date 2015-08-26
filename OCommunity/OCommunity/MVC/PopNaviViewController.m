//
//  PopNaviViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/6/27.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "PopNaviViewController.h"

@interface PopNaviViewController ()

@end

@implementation PopNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    PopNaviViewController *popVC = [super initWithRootViewController:rootViewController];
    popVC.interactivePopGestureRecognizer.delegate = self;
    popVC.delegate = self;
    return popVC;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    // Enable the gesture again once the new controller is shown
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = YES;
}


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
