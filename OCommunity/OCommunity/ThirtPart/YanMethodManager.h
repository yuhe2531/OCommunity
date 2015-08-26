//
//  YanMethodManager.h
//  MethodManager
//
//  Created by zhangyan on 14-10-18.
//  Copyright (c) 2014年 zhangyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"

typedef void(^TimerActionBlock)(NSTimer *timer);
typedef void(^backTo)(void);
typedef void(^ShareSuccessBlock)(void);

@interface YanMethodManager : NSObject<MFMessageComposeViewControllerDelegate>

@property (nonatomic,strong) UIViewController *viewController;
@property (nonatomic,copy) TimerActionBlock timerBlock;
@property (nonatomic,copy) backTo back;
@property (nonatomic,copy) ShareSuccessBlock shareSuccess;

//@property (nonatomic,strong) UIView *hudView;
//单例
+(id)defaultManager;

//获取日期格式
-(NSString *)getDateFromTime:(NSString *)time;
//获取文本的frame，（label自适应高度）
-(CGFloat)titleLabelHeightByText:(NSString *)string width:(CGFloat)width fontSize:(CGFloat)fontSize;
//验证手机号码正则法则
-(BOOL)validateMobile:(NSString *)mobileNum;
//给字符串添加中划线
-(void)addMiddleLineOnString:(UILabel *)label;
//改变置顶文字的颜色
-(NSMutableAttributedString *)attributStringWithColor:(UIColor *)color text:(NSString *)text specialStr:(NSString *)speStr otherSpeStr:(NSString *)otherStr;
-(NSMutableAttributedString *)attributStringWithColor:(UIColor *)color text:(NSString *)text specialStr:(NSString *)speStr;
//判断字符串是否为空
-(BOOL)isStringEmptyOrNilWithString:(NSString *)string;
//判断字典是否为空
-(BOOL)isDictionaryEmptyWithDic:(NSDictionary *)dic;
//判断数组是否为空
-(BOOL)isArrayEmptyWithArray:(NSArray *)array;
-(void)callPhoneActionWithNum:(NSString *)number viewController:(UIViewController *)controller;
-(void)sendMessageWithBody:(NSString *)body to:(NSString *)toNumber Controller:(UIViewController *)msgController;
//获取text的高度
-(CGFloat)titleLabelHeightByText:(NSString *)string width:(CGFloat)width font:(NSInteger)fontsize;

//根据文字获取label的宽度
-(CGFloat)LabelWidthByText:(NSString *)string height:(CGFloat)height font:(NSInteger)fontsize;
-(NSString *)getShortDateFromTime:(NSString *)time;
//使用粘贴板
-(void)pasteTestWithPasteboard:(NSString *)pasteStr;

//应用内打开指定的聊天页面
-(void)jumpQQWithqqStr:(NSString *)qq viewController:(UIViewController *)controller;

//跳转到微信
-(void)jumpWechat;

//跳转到qq
-(void)jumpToQQ;
//获得可读时间
- (NSString *)getTime:(NSString *)dateStr;
//一个时间距离现在的时间
- (NSString *)intervalSinceNow: (NSString *) theDate;
-(NSString *)urlEncodedString:(NSString *)sourceStr;
-(NSString *)yanTimeWithStr:(NSString *)time;
-(UILabel *)navibarTitle:(NSString *)title;

//返回上一个页面
-(void)popToViewControllerOnClicked:(UIViewController *)viewController selector:(SEL)selector;

+(UITextField *)textFieldWithFrame:(CGRect)frame placeHolder:(NSString *)placeholder borderStyle:(UITextBorderStyle)style leftImagName:(NSString *)leftImageName;
+(UIButton *)buttonWithType:(UIButtonType)type frame:(CGRect)rect title:(NSString *)title;
+(UIButton *)buttonWithFrame:(CGRect)rect title:(NSString *)title;
+(UIButton *)buttonWithFrame:(CGRect)rect imageName:(NSString *)imageName;

/**
 *  图片之间的分割线
 *
 *  @param frame     frame
 *  @param superView imageView
 *
 *  @return lineView
 */
+(UIView *)lineViewWithFrame:(CGRect)frame superView:(UIView *)superView;

//系统加载效果
+(void)showIndicatorOnView:(UIView *)view;
+(void)hideIndicatorFromView:(UIView *)view;

+(void)emptyDataInView:(UIView *)view title:(NSString *)title;
+(void)removeEmptyViewOnView:(UIView *)view;
+(void)noTejiaGoodsInview:(UIView *)view title:(NSString *)title;

@end
