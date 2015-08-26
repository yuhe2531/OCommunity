//
//  VertifyCodeCell.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/14.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "VertifyCodeCell.h"
#import "NetWorkRequest.h"
@implementation VertifyCodeCell

-(id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = kDividColor.CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 5;
        [self createCodeSubviewsWithTitle:title];
    }
    return self;
}

#define kTitleLabel_left 30
#define kTitleLabel_top 5
#define kTitleLabel_width 75
#define kTitleLabel_height 25

#define kCodeTF_left 5

#define kCodeBtn_width 100

-(void)createCodeSubviewsWithTitle:(NSString *)title
{
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTitleLabel_left, kTitleLabel_top, kTitleLabel_width, kTitleLabel_height)];
//    titleLabel.text = title;
//    titleLabel.font = [UIFont systemFontOfSize:kFontSize_3];
////    titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:titleLabel];
    
    _codeTF = [[UITextField alloc] initWithFrame:CGRectMake(kTitleLabel_left, kTitleLabel_top, self.width-2*kTitleLabel_left-kCodeBtn_width, kTitleLabel_height)];
//    NSRange range = {0,title.length-1};
//    NSString *placeTitle = [title substringWithRange:range];
    _codeTF.placeholder = [NSString stringWithFormat:@"%@",title];
    _codeTF.font = [UIFont systemFontOfSize:kFontSize_3];
    _codeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeTF.delegate = self;
    [self addSubview:_codeTF];
    
    _codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_codeTF.right+kCodeTF_left, _codeTF.top, kCodeBtn_width, _codeTF.height)];
    _codeLabel.text = @"获取验证码";
    _codeLabel.textAlignment = NSTextAlignmentCenter;
    _codeLabel.textColor = [UIColor whiteColor];
    _codeLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    _codeLabel.layer.cornerRadius = 5;
    _codeLabel.clipsToBounds = YES;
    _codeLabel.userInteractionEnabled = YES;
    _codeLabel.backgroundColor = kRedColor;
    [self addSubview:_codeLabel];
    
    _codeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _codeBtn.frame = _codeLabel.bounds;
    [_codeBtn addTarget:self action:@selector(codeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_codeLabel addSubview:_codeBtn];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)codeBtnAction
{
    if (self.codeBtnBlock) {
        self.codeBtnBlock();
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
