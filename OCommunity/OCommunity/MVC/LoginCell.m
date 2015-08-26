//
//  LoginCell.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/14.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "LoginCell.h"

@implementation LoginCell

-(id)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = kDividColor.CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 5;
        [self createLoginCellSubviewsWithImage:image title:title];
    }
    return self;
}

#define kLoginImgv_top 5
#define kLoginImgv_left 15
#define kLoginImgv_width 25
#define kLoginImgv_height 25

#define kTitleL_left 5
#define kTitleL_width 60

-(void)createLoginCellSubviewsWithImage:(UIImage *)image title:(NSString *)title
{
    UIImageView *titleImgv = [[UIImageView alloc] initWithFrame:CGRectMake(kLoginImgv_left, kLoginImgv_top, kLoginImgv_width, kLoginImgv_height)];
    titleImgv.image = image;
    [self addSubview:titleImgv];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(titleImgv.right+kTitleL_left, titleImgv.top, kTitleL_width, titleImgv.height)];
    titleL.font = [UIFont systemFontOfSize:kFontSize_3];
    titleL.text = title;
    titleL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleL];
    
    _contentTF = [[UITextField alloc] initWithFrame:CGRectMake(titleL.right+kTitleL_left, titleL.top, self.width-titleImgv.width-titleL.width-kLoginImgv_left-2*kTitleL_left-15, titleL.height)];
    _contentTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _contentTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _contentTF.placeholder = [NSString stringWithFormat:@"请输入%@",title];
    _contentTF.font = [UIFont systemFontOfSize:kFontSize_3];
    _contentTF.delegate = self;
    
    [self addSubview:_contentTF];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
