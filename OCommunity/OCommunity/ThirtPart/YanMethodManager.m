//
//  YanMethodManager.m
//  MethodManager
//
//  Created by zhangyan on 14-10-18.
//  Copyright (c) 2014年 zhangyan. All rights reserved.
//

#import "YanMethodManager.h"
#import <QuartzCore/QuartzCore.h>
#import "Toast+UIView.h"
#import "UIViewAdditions.h"

@implementation YanMethodManager

static YanMethodManager *manager = nil;
+(id)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YanMethodManager alloc] init];
    });
    return manager;
}

//获取日期格式
-(NSString *)getDateFromTime:(NSString *)time
{
    NSDate *timesp = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [format stringFromDate:timesp];
    return dateStr;
}

-(NSString *)getShortDateFromTime:(NSString *)time
{
    NSDate *timesp = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *dateStr = [format stringFromDate:timesp];
    return dateStr;
}

-(NSString *)yanTimeWithStr:(NSString *)time
{
    NSDate *timesp = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *dateStr = [format stringFromDate:timesp];
    return dateStr;

}
//获取文本的frame
-(CGFloat)titleLabelHeightByText:(NSString *)string width:(CGFloat)width fontSize:(CGFloat)fontSize
{
    CGSize size = CGSizeMake(width, 1000);
    NSDictionary *attributedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
    CGRect textRect = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributedDic context:nil];
    return textRect.size.width;
}

//验证手机号码正则法则
-(BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     *手机号码
     *移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     *联通：130,131,132,152,155,156,185,186
     *电信：133,1349,153,180,189
     */
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     *中国移动：China Mobile
     *134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    NSString*CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     *中国联通：China Unicom
     *130,131,132,152,155,156,185,186
     */
    NSString *CU = @"^1(3[0-9]|5[2567]|7[0-9]|8[563])\\d{8}$";
    /**
     *中国电信：China Telecom
     *133,1349,153,180,189
     */
    NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     *大陆地区固话及小灵通
     *区号：010,020,021,022,023,024,025,027,028,029
     *号码：七位或八位
     */
    //NSString*PHS=@"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if(([regextestmobile evaluateWithObject:mobileNum] == YES)
       || ([regextestcm evaluateWithObject:mobileNum] == YES)
       || ([regextestct evaluateWithObject:mobileNum] == YES)
       ||([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//给字符串添加中划线
-(void)addMiddleLineOnString:(UILabel *)label
{
    NSRange range = NSMakeRange(0, label.text.length);
    NSMutableAttributedString *attribu_str = [[NSMutableAttributedString alloc] initWithString:label.text];
    [attribu_str addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    label.attributedText = attribu_str;
    
}

  //改变指定文字的颜色
-(NSMutableAttributedString *)attributStringWithColor:(UIColor *)color text:(NSString *)text specialStr:(NSString *)speStr otherSpeStr:(NSString *)otherStr
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[text rangeOfString:text]];
    [str addAttribute:NSForegroundColorAttributeName value:color range:[text rangeOfString:speStr]];
    [str addAttribute:NSForegroundColorAttributeName value:color range:[text rangeOfString:otherStr]];
    return str;
}

-(NSMutableAttributedString *)attributStringWithColor:(UIColor *)color text:(NSString *)text specialStr:(NSString *)speStr
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[text rangeOfString:text]];
    [str addAttribute:NSForegroundColorAttributeName value:color range:[text rangeOfString:speStr]];
    return str;
}

//判断字符串是否为空
-(BOOL)isStringEmptyOrNilWithString:(NSString *)string
{
//    if (string == nil || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]] || string.length <= 0) {
//        return YES;
//    }
//    return NO;
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;

}

//判断字典是否为空
-(BOOL)isDictionaryEmptyWithDic:(NSDictionary *)dic
{
    if ([dic isKindOfClass:[NSNull class]] == YES || dic == nil) {
        return YES;
    }
    return NO;
}

//判断数组是否为空
-(BOOL)isArrayEmptyWithArray:(NSArray *)array
{
    if ([array isKindOfClass:[NSNull class]] == YES || array == nil ) {
        return YES;
    }
    if([array count]==0){
        return YES;
    }
    return NO;
}


//控件
+(UIView *)viewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    return view;
}

+(UIView *)viewWithFrame:(CGRect)frame color:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}


+(UITextField *)textFieldWithFrame:(CGRect)frame placeHolder:(NSString *)placeholder borderStyle:(UITextBorderStyle)style
{
    UITextField *textF = [[UITextField alloc] initWithFrame:frame];
    textF.placeholder = placeholder;
    textF.borderStyle = style;
    return textF;
}

+(UILabel *)labelWithFrame:(CGRect)frame fontSize:(NSInteger)size
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:size];
    return label;
}

+(UILabel *)LabelWithFrame:(CGRect)rect text:(NSString *)text fontSize:(NSInteger)size
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = text;
    label.font = [UIFont systemFontOfSize:size];
    return label;
}

//拨打电话
-(void)callPhoneActionWithNum:(NSString *)number viewController:(UIViewController *)controller
{
    //    NSString *tel = [NSString stringWithFormat:@"telPrompt:%@",number];
    //    NSURL *telUrl = [[NSURL alloc] initWithString:tel];
    //    [[UIApplication sharedApplication] openURL:telUrl];
    
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPhone"]) {
        if (number.length > 8) {
            UIWebView *callWebview = [[UIWebView alloc] init];
            NSURL *telUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",number]];
            [callWebview loadRequest:[NSURLRequest requestWithURL:telUrl]];
            [controller.view addSubview:callWebview];
        } else {
            [controller.view makeToast:@"未提供电话" duration:1.5 position:@"center"];
        }
        
    } else {
        [controller.view makeToast:@"此设备没有拨打电话的功能" duration:1.0 position:@"center"];
    }
}

//发送短信
-(void)sendMessageWithBody:(NSString *)body to:(NSString *)toNumber Controller:(UIViewController *)msgController
{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = [NSArray arrayWithObject:toNumber];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [msgController presentViewController:controller animated:YES completion:nil];
        
    } else {
        [msgController.navigationController.view makeToast:@"此设备没有发送短信的功能" duration:1.0 position:@"center"];
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSString *toastStr;//提示信息
    switch (result) {
        case MessageComposeResultFailed:
        { toastStr = @"发送失败";
            break;
        }
        case MessageComposeResultSent:{
            toastStr = @"发送成功";
            break;
        }
        case MessageComposeResultCancelled:{
            toastStr = @"发送已取消";
            break;
        }
            
        default:
            break;
    }
    if (toastStr) {
        [self.viewController.navigationController.view makeToast:toastStr duration:1.0 position:@"center"];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)titleLabelHeightByText:(NSString *)string width:(CGFloat)width font:(NSInteger)fontsize
{
    
    CGSize size = CGSizeMake(width, 1000);
    
    NSDictionary *attributedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontsize],NSFontAttributeName, nil];
    
    CGRect textRect = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributedDic context:nil];
    
    return textRect.size.height;
}

//根据文字获取label的宽度
-(CGFloat)LabelWidthByText:(NSString *)string height:(CGFloat)height font:(NSInteger)fontsize
{
    
    CGSize size = CGSizeMake(200, height);
    
    NSDictionary *attributedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontsize],NSFontAttributeName, nil];
    
    CGRect textRect = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributedDic context:nil];
    
    return textRect.size.width;
}

//使用粘贴板
-(void)pasteTestWithPasteboard:(NSString *)pasteStr
{
    UIPasteboard *generalPastboard = [UIPasteboard generalPasteboard];
    [generalPastboard setString:pasteStr];
}

//应用内打开指定的聊天页面
-(void)jumpQQWithqqStr:(NSString *)qq viewController:(UIViewController *)controller
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qq]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [controller.view addSubview:webView];
}

//跳转到微信
-(void)jumpWechat
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"wechat:"]];
}

//跳转到qq
-(void)jumpToQQ
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mqq:"]];
}
//获得时间
- (NSString *)getTime:(NSString *)dateStr{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateStr.integerValue];
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    NSString *time = [formmater stringFromDate:date];
    return time;
}

//一个时间距离现在的时间
- (NSString *)intervalSinceNow: (NSString *) theDate
{
    // NSArray *timeArray=[theDate componentsSeparatedByString:@"."];
    // theDate=[timeArray objectAtIndex:0];
    //
    //   NSDateFormatter *date=[[NSDateFormatter alloc] init];
    //    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSDate *d=[date dateFromString:theDate];
    //
    //    // NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSTimeInterval late = theDate.floatValue;
    
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha =now-late;
    //    if (now>late) {
    //        cha=now-late;
    //    }else{
    //        cha=late-now;
    //
    //    }
    
    //    if (cha/3600<1) {
    //        timeString = [NSString stringWithFormat:@"%f", cha/60];
    //        timeString = [timeString substringToIndex:timeString.length-7];
    //        timeString=[NSString stringWithFormat:@"剩余%@分", timeString];
    //
    //    }
    //    if (cha/3600>1&&cha/86400<1) {
    //        timeString = [NSString stringWithFormat:@"%f", cha/3600];
    //        timeString = [timeString substringToIndex:timeString.length-7];
    //        timeString=[NSString stringWithFormat:@"剩余%@小时", timeString];
    //    }
    if (cha/86400/3>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"剩余%@天", timeString];
        
    }else{
        cha = 86400*3-cha;
        int i,j,k,l;
        i = cha/86400;
        j = (cha-i*86400)/3600;
        k = (cha-i*86400- j*3600)/60;
        l = (cha-i*86400- j*3600-k*60);
        timeString = [NSString stringWithFormat:@"剩余%d天%d小时%d分%d秒",i,j,k,l ];
    }
    return timeString;
}

-(NSString *)urlEncodedString:(NSString *)sourceStr
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)sourceStr ,NULL ,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    return result;
}

-(UILabel *)navibarTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:kFontSize_1];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}

//返回上一个页面
-(void)popToViewControllerOnClicked:(UIViewController *)viewController selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 15, 20);
//    button.backgroundColor = KRandomColor;
    [button setBackgroundImage:[UIImage imageNamed:@"popArrow"] forState:UIControlStateNormal];
    [button addTarget:viewController action:selector forControlEvents:UIControlEventTouchUpInside];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

//登陆 密码修改tf
+(UITextField *)textFieldWithFrame:(CGRect)frame placeHolder:(NSString *)placeholder borderStyle:(UITextBorderStyle)style leftImagName:(NSString *)leftImageName
{
    UITextField *textF = [[UITextField alloc] initWithFrame:frame];
    [textF setReturnKeyType:UIReturnKeyDone];
    textF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textF.placeholder = placeholder;
    textF.borderStyle = style;
    [textF setFont:[UIFont systemFontOfSize:kFontSize_2]];
    [textF.layer setCornerRadius:5];
    [textF.layer setBorderWidth:0.5];
    [textF.layer setMasksToBounds:YES];
    [textF.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    if ([[YanMethodManager defaultManager] isStringEmptyOrNilWithString:leftImageName]==NO) {
        UIImageView *imagV = [YanMethodManager imageViewWithFrame:CGRectMake(0, 0, 30, 25) image:[UIImage imageNamed:leftImageName]];
        [textF setLeftView:imagV];
        [textF setLeftViewMode:UITextFieldViewModeAlways];
    }else{
        UIImageView *imagV = [YanMethodManager imageViewWithFrame:CGRectMake(0, 0, 10, 20) image:nil];
        [textF setLeftView:imagV];
        [textF setLeftViewMode:UITextFieldViewModeAlways];
        
    }
    return textF;
}

+(UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    //    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //    imageView.backgroundColor = Kbackground_color;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    return imageView;
}

+(UIButton *)buttonWithType:(UIButtonType)type frame:(CGRect)rect title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:type];
    button.frame = rect;
    [button.titleLabel setFont:[UIFont systemFontOfSize:kFontSize_3]];
    [button setTitle:title forState:UIControlStateNormal];
    //    [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
//登录 设置按钮
+(UIButton *)buttonWithFrame:(CGRect)rect title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = rect;
    [button setTitle:title forState:UIControlStateNormal];
    [button.layer setCornerRadius:5];
    [button.layer setMasksToBounds:YES];
    [button setBackgroundColor:kRedColor];
    [button.titleLabel setFont:[UIFont systemFontOfSize:kFontSize_1]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}

+(UIButton *)buttonWithFrame:(CGRect)rect imageName:(NSString *)imageName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    
    return button;
}

+(UIView *)lineViewWithFrame:(CGRect)frame superView:(UIView *)superView
{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = kDividColor;
    [superView addSubview:line];
    return line;
}

+(void)showHudInView:(UIView *)view
{
    UIView *bgView = [[UIView alloc] initWithFrame:view.bounds];
    bgView.backgroundColor = kBackgroundColor;
    [view addSubview:bgView];
    bgView.tag = 1001;
    [MBProgressHUD showHUDAddedTo:bgView animated:YES];
}

+(void)hideHudInView:(UIView *)view
{
    UIView *bgView = [view viewWithTag:1001];
    [MBProgressHUD hideHUDForView:bgView animated:YES];
    [bgView removeFromSuperview];
    bgView = nil;
}

+(void)showIndicatorOnView:(UIView *)view
{
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.frame = CGRectMake(0, 0, 50, 50);
    activity.center = CGPointMake(view.width/2, view.height/2);
    activity.hidesWhenStopped = YES;
    activity.tag = 2222;
    [activity startAnimating];
    [view addSubview:activity];
}

+(void)hideIndicatorFromView:(UIView *)view
{
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[view viewWithTag:2222];
    [activity stopAnimating];
    [activity removeFromSuperview];
}

#define kEmptyImgV_width 60

+(void)emptyDataInView:(UIView *)view title:(NSString *)title
{
    UIView *emptyView = [[UIView alloc] initWithFrame:view.bounds];
    emptyView.tag = 2500;
    emptyView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kEmptyImgV_width, kEmptyImgV_width)];
    imageView.image = [UIImage imageNamed:@"noData"];
    imageView.center = CGPointMake(emptyView.width/2, emptyView.height/3);
    [emptyView addSubview:imageView];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom+10, emptyView.width, 40)];
    titleL.text = title;
    titleL.textColor =kBlack_Color_2;
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = [UIFont systemFontOfSize:kFontSize_2];
    [emptyView addSubview:titleL];
    
    [view addSubview:emptyView];
    
}

+(void)removeEmptyViewOnView:(UIView *)view
{
    for (UIView *subView in view.subviews) {
        if (subView.tag == 2500) {
            [subView removeFromSuperview];
        }
    }
}

+(void)noTejiaGoodsInview:(UIView *)view title:(NSString *)title
{
    UIView *emptyView = [[UIView alloc] initWithFrame:view.bounds];
    emptyView.tag = 2500;
    emptyView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    imageView.image = [UIImage imageNamed:@"deer"];
    imageView.center = CGPointMake(emptyView.width/2, emptyView.height/2);
    [emptyView addSubview:imageView];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom+10, emptyView.width, 40)];
    titleL.text = title;
    titleL.textColor =kBlack_Color_2;
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = [UIFont systemFontOfSize:kFontSize_2];
    [emptyView addSubview:titleL];
    
    [view addSubview:emptyView];
}


@end
