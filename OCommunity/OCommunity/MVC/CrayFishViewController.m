//
//  CrayFishViewController.m
//  OCommunity
//
//  Created by runkun2 on 15/6/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "CrayFishViewController.h"
#import "PayRightNowViewController.h"
#import "LoginViewController.h"
#define payBottomViewHeight 50
#define kImageWidth 1125
#define kDuration 0.3
#import "UIImageView+WebCache.h"
@interface CrayFishViewController ()<UIGestureRecognizerDelegate>
{

    UIImageView *topImageView;
    NSArray *_tasteArray;
    NSArray *_sizePart;
    UIPickerView *_chooseTastePickerView;
    UIButton *ensureButton;
}
@property(nonatomic,assign) BOOL marketIsLogin;
@property(nonatomic,assign) CGFloat top;

@end

@implementation CrayFishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createCrayFishSubviews];
}

-(void)createCrayFishSubviews{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height-payBottomViewHeight)];
    scrollView.backgroundColor = kBackgroundColor;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    if (_width!=0) {
        topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, (kScreen_width *_height)/_width)];
        [topImageView sd_setImageWithURL:[NSURL URLWithString:_urlImageString] placeholderImage:kHolderImage];
        [scrollView addSubview:topImageView];

    }
       NSArray *sizeHeightArray = @[@602,@1041,@1892,@1044,@846,@868];
    for (int i =0; i<sizeHeightArray.count; i++) {
        NSNumber *imageHeight = sizeHeightArray[i];
        if (i>0) {
            NSNumber *topHeight = sizeHeightArray[i-1];
            _top += (kScreen_width *topHeight.intValue)/kImageWidth;

        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topImageView.height + _top, kScreen_width, (kScreen_width *imageHeight.intValue)/kImageWidth)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"crayFish%d.jpg",i+1]];

        [scrollView addSubview:imageView];
        
    }
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (kScreen_width *1134)/750 * 4, kScreen_width, (kScreen_width *560)/750)];
//    imageView.image = [UIImage imageNamed:@"crayFish5"];
//    [scrollView addSubview:imageView];
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    popBtn.frame = CGRectMake(15, 30, 29, 29);
    [popBtn setBackgroundImage:[UIImage imageNamed:@"func_pop_arrow"] forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(crayFishPop) forControlEvents:UIControlEventTouchUpInside];
    scrollView.contentSize = CGSizeMake(kScreen_width, topImageView.height + _top +(kScreen_width *868)/kImageWidth);
    
    [self.view addSubview:popBtn];
    UIView *payBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_height - payBottomViewHeight, kScreen_width, payBottomViewHeight)];
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(kScreen_width - 120, 10, 90, 30);
    [payButton setTitle:@"立即购买" forState:UIControlStateNormal];
    payButton.titleLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    payButton.layer.cornerRadius = 5;
    payButton.layer.borderWidth = 1;
    payButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [payButton addTarget:self action:@selector(payRight) forControlEvents:UIControlEventTouchUpInside];
    [payBottomView addSubview:payButton];
    [payBottomView setBackgroundColor:kColorWithRGB(255, 87, 87)];
    [self.view addSubview:payBottomView];
    _chooseTastePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreen_height, kScreen_width, 150)];
    _chooseTastePickerView.backgroundColor = [UIColor whiteColor];
//    _chooseTastePickerView.hidden = YES;
    _chooseTastePickerView.delegate = self;
    _chooseTastePickerView.dataSource = self;
    _chooseTastePickerView.showsSelectionIndicator = YES;
    _chooseTastePickerView.userInteractionEnabled = YES;
    _tasteArray = @[@"微辣",@"中辣",@"麻辣"];
    _sizePart = @[@"大份(￥140/1500克)",@"中份(￥72/750克)",@"小份(￥49/500克)"];
    [self.view addSubview:_chooseTastePickerView];
    ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ensureButton.frame = CGRectMake(kScreen_width-80, kScreen_height, 80, 30);
    [ensureButton setTitle:@"完成" forState:UIControlStateNormal];
    [ensureButton setTitleColor:kRedColor forState:UIControlStateNormal];
    ensureButton.titleLabel.font = [UIFont boldSystemFontOfSize:kFontSize_2];
//    ensureButton.hidden = YES;
    ensureButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [ensureButton addTarget:self action:@selector(ensurePayRight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ensureButton];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _tasteArray.count;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component ==0) {
        
        return kScreen_width/2 -30;
    }else{
    
        return kScreen_width/2 +30;
    }

}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
         UILabel *pickViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, view.width, view.height)];
        
        pickViewLabel.textAlignment = NSTextAlignmentCenter;
        pickViewLabel.font = [UIFont systemFontOfSize:kFontSize_2];         //用label来设置字体大小
        pickViewLabel.textColor = kBlack_Color_2;
        pickViewLabel.backgroundColor = [UIColor clearColor];
    if (component==0) {
        pickViewLabel.text = [_tasteArray objectAtIndex:row];
    }else{
    
        pickViewLabel.text = [_sizePart objectAtIndex:row];


    }

    return pickViewLabel;

}
// 每一行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component ==0) {
        NSString *tasteString = _tasteArray[row];
        return tasteString;
    }else{
        NSString *partString = _sizePart[row];
        return partString;
    
    }
}

-(void)payRight{
    
    
    [UIView animateWithDuration:kDuration animations:^{
        _chooseTastePickerView.top = kScreen_height-150;
        ensureButton.top = kScreen_height-150;
    }];


}
-(void)ensurePayRight{
    [UIView animateWithDuration:kDuration animations:^{
        _chooseTastePickerView.top = kScreen_height;
        ensureButton.top = kScreen_height;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __weak CrayFishViewController *weakSelf = self;
        [self isLoginHandle:^{
            [weakSelf loginPayRightNow];
        } hasLogin:^{
            [weakSelf loginPayRightNow];
        }];

    });
   }
-(void)loginPayRightNow{
    
    NSInteger selectedTasteRow = [_chooseTastePickerView selectedRowInComponent:0];
    NSString *tasteSelected = [_tasteArray objectAtIndex:selectedTasteRow];
    NSInteger selectedPartRow = [_chooseTastePickerView selectedRowInComponent:1];
    NSString *partSelected = [_sizePart objectAtIndex:selectedPartRow];
    NSLog(@"=====口味：%@ ++++++++选择份的种类：%@",tasteSelected,partSelected);
    PayRightNowViewController *payVC = [[PayRightNowViewController alloc] init];
    payVC.isHotGoods = YES;
    switch (selectedPartRow) {
        case 0:
            //大份
            payVC.price = @"140";
            break;
        case 1:
            //中份
            payVC.price = @"72";
            break;
        case 2:
            //小份
            payVC.price = @"49";
            break;
        default:
            break;
    }
    payVC.store_id = 56;
    payVC.count = @"1";
    payVC.market_name = @"特色专卖店";
    payVC.standardSendFee = 72.0;
    payVC.carriageFee = 3.0;
    if (selectedTasteRow==0) {
    //微辣
    payVC.goods_id = 4;
    }else if (selectedTasteRow==1){
    //中辣
    payVC.goods_id = 5;
    }else if (selectedTasteRow==2){
    //麻辣
    payVC.goods_id = 6;
    }
    payVC.goods_name = [NSString stringWithFormat:@"%@小龙虾%@",tasteSelected,partSelected];
    [self.navigationController pushViewController:payVC animated:YES];
}
-(void)isLoginHandle:(void(^)(void))loginSuccess hasLogin:(void(^)(void))hasLoginHandle
{
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    if (member_id == NULL) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.isPresent = YES;
        loginVC.loginSuccessBlock = ^{
            loginSuccess();
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.tabBarController presentViewController:nav animated:YES completion:nil];
    } else {
        hasLoginHandle();
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [UIView animateWithDuration:kDuration animations:^{
        _chooseTastePickerView.top = kScreen_height;
        ensureButton.top = kScreen_height;
    }];


}
-(void)crayFishPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [TalkingData trackPageEnd:@"小龙虾页面"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [TalkingData trackPageBegin:@"小龙虾页面"];
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
