//
//  CommunityTabBarViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/24.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "CommunityTabBarViewController.h"
#import "MineViewController.h"
#import "NoLoginViewController.h"
#import "CartViewController.h"
#import "LoginViewController.h"

@interface CommunityTabBarViewController ()

@end

@implementation CommunityTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.tabBar.tintColor = kRedColor;
    
    // Do any additional setup after loading the view.
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
////    NSString *passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
//    UINavigationController *navi = (UINavigationController *)viewController;
//    if ([navi.topViewController isKindOfClass:[MineViewController class]] || [navi.topViewController isKindOfClass:[CartViewController class]]) {
//        if (userName == NULL) {
//            LoginViewController *loginVC = [[LoginViewController alloc] init];
//            loginVC.isPresent = YES;
//            loginVC.dismissBlock = ^{
//                self.selectedIndex = 0;
//            };
//            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
//            [self presentViewController:navi animated:YES completion:nil];
//        }
//        
//    }
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
