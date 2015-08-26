//
//  DuckNeckViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/6/29.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "DuckNeckViewController.h"
#import "PayRightNowViewController.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"

@interface DuckNeckViewController ()<UIGestureRecognizerDelegate>

{
    UIView *pickerSuperview;
}

@property (nonatomic, assign) NSInteger buyTag;
@property (nonatomic, strong) NSArray *pickerItems;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *tast;
@property (nonatomic, copy) NSString *style;

@end
                                                                                                                                                                                                                                                                                                                                                                                                 
@implementation DuckNeckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *tasts = @[@"微辣",@"中辣",@"麻辣"];
    NSArray *styles = @[@"大份(¥29.5/450克)",@"小份(¥15.0/230克)"];
    _price = @"29.5";
    _tast = tasts[0];
    _style = styles[0];
    _buyTag = 730;
    _pickerItems = @[tasts,styles];
    
    [self addDuckNeckVCSubviews];
    // Do any additional setup after loading the view.
}

-(void)addDuckNeckVCSubviews
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height-49)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = kBackgroundColor;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    UIImageView *top1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_width*(_height/_width))];
    [top1 sd_setImageWithURL:[NSURL URLWithString:_imageName] placeholderImage:kHolderImage];
    [scrollView addSubview:top1];
    
//    UIImageView *top2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, top1.bottom, kScreen_width, kScreen_width*(287/375.0))];
//    top2.image = [UIImage imageNamed:@"necktop2"];
//    [scrollView addSubview:top2];
    
//    DuckNecksView *duckNeckView = [[DuckNecksView alloc] initWithFrame:CGRectMake(0, top1.bottom, kScreen_width, 170)];
//    __weak DuckNeckViewController *weakSelf = self;
//    duckNeckView.buyNeckBlock = ^(UIButton *button){
//        [weakSelf buyNeckAction:button];
//    };
//    [scrollView addSubview:duckNeckView];
    
    NSArray *heights = @[[NSNumber numberWithFloat:0.0],
                         [NSNumber numberWithFloat:kScreen_width*1100.0/1125.0],
                         [NSNumber numberWithFloat:kScreen_width*(1100.0/1125.0 + 853/1125.0)],
                         [NSNumber numberWithFloat:kScreen_width*(1100.0/1125.0 + 853/1125.0 + 1025/1123.0)],
                         [NSNumber numberWithFloat:kScreen_width*(1100.0/1125.0 + 853/1125.0 + 1025/1123.0 + 1050/1124.0)],
                         [NSNumber numberWithFloat:kScreen_width*(1100.0/1125.0 + 853/1125.0 + 1025/1123.0 + 1050/1124.0 + 903/1125.0)]];
    NSArray *evHeihgt = @[[NSNumber numberWithFloat:kScreen_width*1100/1125.0],
                          [NSNumber numberWithFloat:kScreen_width*853/1125.0],
                          [NSNumber numberWithFloat:kScreen_width*1025/1123.0],
                          [NSNumber numberWithFloat:kScreen_width*1050/1124.0],
                          [NSNumber numberWithFloat:kScreen_width*903/1125.0],
                          [NSNumber numberWithFloat:kScreen_width*1128/1125.0]];
    NSArray *images = @[@"neck1.jpg",@"neck2.jpg",@"neck3.jpg",@"neck4.jpg",@"neck5.jpg",@"neck6.jpg"];
    CGFloat detailHeight = 0;
    for (int i = 0; i < heights.count; i++) {
        NSNumber * topHeight = heights[i];
        NSNumber *heihgt = evHeihgt[i];
        detailHeight += heihgt.floatValue;
        UIImageView *detailImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, top1.height+topHeight.floatValue, kScreen_width, heihgt.floatValue)];
        detailImageV.image = [UIImage imageNamed:images[i]];
        [scrollView addSubview:detailImageV];
    }
    
    scrollView.contentSize = CGSizeMake(kScreen_width, top1.height+detailHeight);
    
    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    popBtn.frame = CGRectMake(15, 30, 29, 29);
    [popBtn setBackgroundImage:[UIImage imageNamed:@"func_pop_arrow"] forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(duckNeckPop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, scrollView.bottom, kScreen_width, 49)];
    bottomView.backgroundColor = kColorWithRGB(255, 87, 87);
    [self.view addSubview:bottomView];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    buyBtn.frame = CGRectMake(kScreen_width-20-80, 0, 80, 30);
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.centerY = bottomView.height/2;
    buyBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    buyBtn.layer.borderWidth = 1;
    buyBtn.layer.cornerRadius = 5;
    [buyBtn addTarget:self action:@selector(buyNeckAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:buyBtn];
}

-(void)duckNeckPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

//购买不同口味的鸭脖
-(void)buyNeckAction:(UIButton *)button
{
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    if (member_id == NULL) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginVC];
        __weak DuckNeckViewController *weakSelf = self;
        loginVC.loginSuccessBlock = ^{
            [weakSelf buyActionWithBtn:button];
        };
        [self.navigationController presentViewController:navi animated:YES completion:nil];
    } else {
        [self buyActionWithBtn:button];
    }
}

#define kPicker_height 200

#define kDoneBtn_width 80
#define kDoneBtn_height 40

-(void)buyActionWithBtn:(UIButton *)button
{
    if (pickerSuperview == nil) {
        pickerSuperview = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_height, kScreen_width, kPicker_height)];
        [self.view addSubview:pickerSuperview];
        
        UIPickerView * pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kPicker_height)];
        pickerView.backgroundColor = [UIColor whiteColor];
        pickerView.userInteractionEnabled = YES;
        pickerView.dataSource = self;
        pickerView.delegate = self;
        [pickerSuperview addSubview:pickerView];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        doneBtn.frame = CGRectMake(pickerView.width-kDoneBtn_width, 0, kDoneBtn_width, kDoneBtn_height);
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [doneBtn setTitleColor:kRedColor forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [pickerSuperview addSubview:doneBtn];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        pickerSuperview.frame = CGRectMake(0, kScreen_height-kPicker_height+20, kScreen_width, kPicker_height);
    }];
    
}

-(void)doneBtnAction:(UIButton *)button
{
    [UIView animateWithDuration:0.5 animations:^{
        pickerSuperview.frame = CGRectMake(0, kScreen_height, kScreen_width, kPicker_height);
    }];
    PayRightNowViewController *payVC = [[PayRightNowViewController alloc] init];
    payVC.isHotGoods = YES;
    payVC.price = _price;
    payVC.store_id = 56;
    payVC.count = @"1";
    payVC.market_name = @"特色专卖店";
    payVC.standardSendFee = 29.5;
    payVC.goods_name = [[@"鸭脖" stringByAppendingString:_tast] stringByAppendingString:_style];
    payVC.carriageFee = 3.0;
    switch (_buyTag) {
        case 730:{//微辣
            payVC.goods_id = 1;
        }
            break;
        case 731:{//中辣
            payVC.goods_id = 2;
        }
            break;
        case 732:{//麻辣
            payVC.goods_id = 3;
        }
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:payVC animated:YES];

}

#pragma UIPickerViewDelegate

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *array = _pickerItems[component];
    return array.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSArray *array = _pickerItems[component];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_width/2, 25)];
    label.text = array[row];
    label.textColor = kRedColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:kFontSize_2];
    return label;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 25;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *tasts = _pickerItems[0];
    NSArray *styles = _pickerItems[1];
    if (component == 1) {
        _style = styles[row];
        if (row == 0) {
            _price = @"29.5";
        }
        if (row == 1) {
            _price = @"15.0";
        }
    } else {
        _tast = tasts[row];
        switch (row) {
            case 0:{
                _buyTag = 730;
            }
                break;
            case 1:{
                _buyTag = 731;
            }
                break;
            case 2:{
                _buyTag = 732;
            }
                break;
                
            default:
                break;
        }
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (pickerSuperview) {
        [UIView animateWithDuration:0.5 animations:^{
            pickerSuperview.frame = CGRectMake(0, kScreen_height, kScreen_width, kPicker_height);
        }];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
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
    [TalkingData trackPageEnd:@"鸭脖页面"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [TalkingData trackPageBegin:@"鸭脖页面"];
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
