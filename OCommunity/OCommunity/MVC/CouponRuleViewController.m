//
//  CouponRuleViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/8/25.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "CouponRuleViewController.h"
#import "RuleView.h"

@interface CouponRuleViewController ()

@property (nonatomic, strong) NSArray *rules;

@end

@implementation CouponRuleViewController

#define kView_height 300

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"优惠券规则"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(popInCouponC)];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 64+10, kScreen_width-30, kView_height)];
    view.backgroundColor = [UIColor whiteColor];
    _rules = @[@"每台设备只能领取一次新用户优惠券",
               @"每个账户只能领取一次新用户优惠券",
               @"每个用户每天最多使用一张优惠券",
               @"优惠券过期后无法使用",
               @"满减优惠券达到指定金额才可以使用"];
    for (int i = 0; i < _rules.count; i++) {
        RuleView *ruleView = [[RuleView alloc] initWithFrame:CGRectMake(10, 20 + (10+40)*i, view.width-20, 40) title:_rules[i]];
        [view addSubview:ruleView];
    }
    [self.view addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.left, view.bottom, view.width, 40)];
    imageView.image = [UIImage imageNamed:@"flower_line"];
    [self.view addSubview:imageView];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

-(void)popInCouponC
{
    [self.navigationController popViewControllerAnimated:YES];
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
