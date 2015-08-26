//
//  newAddressView.m
//  OCommunity
//
//  Created by runkun2 on 15/5/21.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "newAddressView.h"

@implementation newAddressView
-(id)initWithFrame:(CGRect)frame{

    if (self =[super initWithFrame:frame]) {
        self.layer.borderColor = kDividColor.CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
        
        [self loadSubViews];
    }

    return self;
}
-(void)loadSubViews{

    _addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 25, 25)];
//    _imageView.backgroundColor =[UIColor redColor];
    [self addSubview:_addImageView];
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(_addImageView.right+10,0 , self.width- _addImageView.width-30, self.height)];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.textColor = kBlack_Color_2;
    _textField.font =   [UIFont systemFontOfSize:kFontSize_2];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:_textField];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [_textField resignFirstResponder];

    return YES;
}
@end
