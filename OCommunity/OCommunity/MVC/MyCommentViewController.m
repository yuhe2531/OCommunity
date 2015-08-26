

//
//  MyCommentViewController.m
//  OCommunity
//
//  Created by runkun2 on 15/5/20.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "MyCommentViewController.h"
#define kGoodsimageView_width 120
#define kGoodsimageView_high 80
#define kSeparator_width 20
#define btnTag 550
#import "UIImageView+WebCache.h"
@interface MyCommentViewController ()<UIGestureRecognizerDelegate>

@end

@implementation MyCommentViewController{

    UILabel *storeName;
    UILabel *goodsName;
    UILabel *label;
    UIButton *evaluateButton;
    UIImageView *goodsimageView;
    UIView *secondView;
    UIScrollView *_scrollView;
    UITextView *_textView;
    UIButton *selectButton;
    UIButton *saveButton;
    
}
int satisfaction=0;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBarHidden = NO;
//    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"我的评价"];
//    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(haveBuy)];
    [self loadSubviews];

}
-(void)loadSubviews{
    _scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-64)];
//    _scrollView.bounces = NO;
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 130)];
    [firstView setBackgroundColor:[UIColor whiteColor]];
    goodsimageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, kGoodsimageView_width, kGoodsimageView_high)];
    goodsimageView.image = kHolderImage;
    storeName = [[UILabel alloc] initWithFrame:CGRectMake(goodsimageView.right + 10, goodsimageView.top, kScreen_width - goodsimageView.width-30, 25)];
    storeName.text = @"店名：零步社区";
    storeName.font = [UIFont boldSystemFontOfSize:kFontSize_1];
//    storeName.textColor =[UIColor bo]
    goodsName = [[UILabel alloc] initWithFrame:CGRectMake(storeName.left, storeName.bottom+10, storeName.width, 20)];
    goodsName.text = @"好吃点只是大麻花100克";
    goodsName.font = [UIFont systemFontOfSize:kFontSize_3];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, firstView.height-1, kScreen_width, 1)];
    [view setBackgroundColor:kDividColor];
    [firstView addSubview:view];
    [firstView addSubview:goodsimageView];
    [firstView addSubview:storeName];
    [firstView addSubview:goodsName];
    [_scrollView addSubview:firstView];
    secondView = [[UIView alloc] initWithFrame:CGRectMake(0, firstView.bottom, kScreen_width, 110)];
    [secondView setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *arrTitle = @[@"差",@"一般",@"满意",@"非常满意",@"无可挑剔"];
    for (int i = 0; i<arrTitle.count; i++) {
    CGFloat width =(kScreen_width- 6 * kSeparator_width)/5;
    UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake(width*i+20*(i+1),20,width,width)];
    [imageButton setImage:[UIImage imageNamed:@"evaluate_gray"] forState:UIControlStateNormal];
    [imageButton setImage:[UIImage imageNamed:@"evaluate_gold"] forState:UIControlStateSelected];
    [imageButton setImage:[UIImage imageNamed:@"evaluate_gold"] forState:UIControlStateHighlighted];
    [imageButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    imageButton.tag = btnTag +i;
    [secondView addSubview:imageButton];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*i+20*(i+1)-5,imageButton.bottom+7,width+10, 20)];
    titleLabel.text = arrTitle[i];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    [secondView addSubview:titleLabel];
    
    }
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, secondView.height-1, kScreen_width, 1)];
    [view2 setBackgroundColor:kDividColor];
    [secondView addSubview:view2];

    [_scrollView addSubview:secondView];

    UIView *thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, secondView.bottom, kScreen_width, 150)];
    [thirdView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *editorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 15, 30, 30)];
    [editorImageView setImage:[UIImage imageNamed:@"remark"]];
    [thirdView addSubview:editorImageView];
    [_scrollView addSubview:thirdView];
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(editorImageView.right+5, editorImageView.top, 1, 70)];
    [view3 setBackgroundColor:kDividColor];
    [thirdView addSubview:view3];
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(view3.right +5, 0, kScreen_width-81, 90)];
//    [textView setBackgroundColor:[UIColor redColor]];
    _textView.delegate = self;
    _textView.scrollEnabled = YES;
    _textView.font = [UIFont systemFontOfSize:kFontSize_3];
//    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    label = [[UILabel alloc] initWithFrame:CGRectMake(view3.right +5, 5, kScreen_width-81, 30)];
    label.text = @"商品怎么样，服务是否周到?";
    label.textColor = [UIColor lightGrayColor];
    [thirdView addSubview:_textView];

    [thirdView addSubview:label];
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _textView.bottom+10, kScreen_width, 20)];
    alertLabel.text = @"亲，您的评价对我们来说都是宝贵的建议噢~";
    alertLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    [thirdView addSubview:alertLabel];
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, thirdView.height-16, kScreen_width, 1)];
    [view4 setBackgroundColor:kDividColor];
    [thirdView addSubview:view4];
    UIView *fourthView = [[UIView alloc] initWithFrame:CGRectMake(0, thirdView.bottom+15, kScreen_width, 160)];
    [fourthView setBackgroundColor:[UIColor whiteColor]];
//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 80, 20)];
//    label1.text = @"匿名评价";
//    selectButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_width-50, 10, 20, 20)];
//    [selectButton setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
//    [selectButton setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
//    [selectButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [selectButton setBackgroundColor:[UIColor grayColor]];
    saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20,fourthView.height/2, kScreen_width-40, 40)];
    [saveButton setBackgroundColor:kRedColor];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.layer.cornerRadius = 5;
    saveButton.clipsToBounds =  YES;
    [saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [fourthView addSubview:saveButton];
//    [fourthView addSubview:label1];
//    [fourthView addSubview:selectButton];
    [_scrollView addSubview:fourthView];
    CGFloat height = firstView.height +secondView.height +thirdView.height +fourthView.height +15
    ;
    if (height<kScreen_height-64) {
        fourthView.height = fourthView.height + kScreen_height-64 - height;
//        saveButton.top = fourthView.height/2;
        height = kScreen_height-64;
    }
    _scrollView.contentSize = CGSizeMake(kScreen_width, height);
    [self.view addSubview:_scrollView];
}
-(void)setDataModel:(HomeGoodsItem *)dataModel{
    
    _dataModel = dataModel;
}
-(void)setOrderDetail:(OrderDetailModel *)orderDetail{
    
    _orderDetail = orderDetail;

}
-(void)saveAction:(UIButton *)btn{
//保存评价
    UIButton *button1 = (UIButton *)[secondView viewWithTag:550];
    UIButton *button2 = (UIButton *)[secondView viewWithTag:551];
    UIButton *button3 = (UIButton *)[secondView viewWithTag:552];
    UIButton *button4 = (UIButton *)[secondView viewWithTag:553];
    UIButton *button5 = (UIButton *)[secondView viewWithTag:554];
    
    if (!button1.selected&&!button2.selected&&!button3.selected&&!button4.selected&&!button5.selected) {
        
        [self.view makeToast:@"您还未选择满意度~" duration:1 position:@"center"];
    }
    else
    {
        __weak MyCommentViewController *weakSelf = self;
        NetWorkRequest *request = [[NetWorkRequest alloc]init];
        NSString *para = [NSString stringWithFormat: @"order_sn=%@&comment=%@&flower_num=%d",_orderDetail.order_sn,_textView.text,satisfaction];
        
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api_order.php?commend=order_addcomment"] postData:para];
        request.successRequest = ^(NSDictionary *dataDic)
        {
            NSLog(@"1111%@",dataDic);
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];

            NSNumber *codeNum = [dataDic objectForKey:@"code"];
            if (codeNum.intValue == 200) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf.view makeToast:@"评论成功" duration:1 position:@"center"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                if (weakSelf.addMycommentSuccess) {
                    weakSelf.addMycommentSuccess();

                }
            });
            }else{
                [weakSelf.view makeToast:@"评论失败" duration:1 position:@"center"];

            }
        };
        request.failureRequest = ^(NSError *error){
        
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];

            [weakSelf.view makeToast:@"评论失败" duration:1 position:@"center"];
        };
        
    
    }
    


}
-(void)btnAction:(UIButton *)btn{

    for (int i =0; i<=btn.tag-btnTag; i++) {
        UIButton *btn = (UIButton *)[secondView viewWithTag:btnTag +i];
        btn.selected = YES;
    }
    for (int i =(int) btn.tag-btnTag +1; i<5; i++) {
        
        UIButton *btn = (UIButton *)[secondView viewWithTag:btnTag +i];
        btn.selected = NO;
    }
    satisfaction = (int)btn.tag - btnTag + 1;

}
-(void)selectBtn:(UIButton *)btn{

    btn.selected = !btn.selected;

}
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        label.text = @"商品怎么样，服务是否周到?";
    }else{
        label.text = @"";
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{

    label.text = @"";
    _scrollView.contentOffset=CGPointMake(0, _scrollView.contentSize.height-_scrollView.height);

}
- (void)textViewDidEndEditing:(UITextView *)textView;{

    if (textView.text.length == 0) {
        
        label.text = @"商品怎么样，服务是否周到?";
    }
}

-(void)haveBuy
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"我的评价"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(haveBuy)];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    storeName.text = [NSString stringWithFormat:@"店名:%@",_orderDetail.store_name];
    if (_orderDetail.order_sn.length>=24) {
        NSRange range = {7,11};
        NSString *order_sn = [_orderDetail.order_sn stringByReplacingCharactersInRange:range withString:@"*****"];
        goodsName.text = [NSString stringWithFormat:@"订单号:%@",order_sn];
    }else{
        
    goodsName.text = [NSString stringWithFormat:@"订单号:%@",_orderDetail.order_sn];
    }
    [goodsimageView sd_setImageWithURL:[NSURL URLWithString:_marketPicName] placeholderImage:kHolderImage];
//
}



@end
