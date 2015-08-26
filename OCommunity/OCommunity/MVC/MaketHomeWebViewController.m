//
//  MaketHomeWebViewController.m
//  OCommunity
//
//  Created by runkun2 on 15/5/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MaketHomeWebViewController.h"

@interface MaketHomeWebViewController ()

@end

@implementation MaketHomeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"每日推荐"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(shipAddressPop)];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-64)];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    if (_webString) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_webString];
        [webView loadRequest:request];
    }
    [self.view addSubview:webView];
}
-(void)shipAddressPop{

    [self.navigationController popViewControllerAnimated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//开始加载网页
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

//结束加载网页
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
