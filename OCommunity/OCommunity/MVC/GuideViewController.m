//
//  GuideViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/6/16.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "GuideViewController.h"
#import "SuperMarketListViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor = kRedColor;
    self.navigationController.navigationBarHidden = YES;
    [self addGuideSubviews];
    
    // Do any additional setup after loading the view.
}

#define kGuideCount 4

#define kGoBtn_height 40

-(void)addGuideSubviews
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(kScreen_width*kGuideCount, kScreen_height);
    [self.view addSubview:scrollView];
    NSArray *imageNames = @[@"guide1",@"guide2",@"guide3",@"guide4"];
    for (int i = 0; i < kGuideCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width*i, 0, kScreen_width, scrollView.height)];
        imageView.image = [UIImage imageNamed:imageNames[i]];
        [scrollView addSubview:imageView];
        if (i == kGuideCount-1) {
            imageView.userInteractionEnabled = YES;
            UIButton *goBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            goBtn.frame = CGRectMake(0, kScreen_height-50-kGoBtn_height, 120, kGoBtn_height);
            [goBtn setTitle:@"立即进入" forState:UIControlStateNormal];
            [goBtn setTitleColor:kRedColor forState:UIControlStateNormal];
            goBtn.centerX = imageView.width/2;
            goBtn.layer.borderColor = kDividColor.CGColor;
            goBtn.layer.borderWidth = 1;
            goBtn.layer.cornerRadius = 5;
            [goBtn addTarget:self action:@selector(goSuperHomeAction) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:goBtn];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

-(void)goSuperHomeAction
{
    SuperMarketListViewController *listVC = [[SuperMarketListViewController alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
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
