//
//  TableHeadView.h
//  OCommunity
//
//  Created by runkun2 on 15/5/20.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableHeadView : UIButton
@property (nonatomic, strong) UIImageView *topImgV;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic,strong) UILabel *bottomLine;
@property(nonatomic,copy)NSString *title;
-(id)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName;
@end
