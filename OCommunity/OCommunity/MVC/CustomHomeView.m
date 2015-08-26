//
//  CustomHomeView.m
//  OCommunity
//
//  Created by Runkun1 on 15/7/4.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "CustomHomeView.h"

@implementation CustomHomeView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [self addSubview:_tableView];
        
        [self tableHeaderAndFooterWithTableview:_tableView];
    }
    return self;
}

-(void)tableHeaderAndFooterWithTableview:(UITableView *)tableView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
//    headerView.backgroundColor = [UIColor blueColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 20)];
    label.text = @"超值购";
    label.textColor = kRed_PriceColor;
    label.font = [UIFont systemFontOfSize:kFontSize_2];
    label.centerY = headerView.height/2;
    [headerView addSubview:label];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    moreBtn.frame = CGRectMake(self.width-10-80, label.top, 80, 20);
    [moreBtn setTitle:@"显示更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:kRed_PriceColor forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_3];
    [moreBtn addTarget:self action:@selector(clickMoreBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:moreBtn];
    
    [YanMethodManager lineViewWithFrame:CGRectMake(0, headerView.height, kScreen_width, 0.5) superView:headerView];
    
    tableView.tableHeaderView = headerView;
    
    UILabel *footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
    footerView.text = @"超值商品实时更新中.....";
    footerView.textColor = kColorWithRGB(241, 153, 0);
    footerView.font = [UIFont systemFontOfSize:kFontSize_3];
    footerView.textAlignment = NSTextAlignmentCenter;
    tableView.tableFooterView = footerView;
}

-(void)clickMoreBtnAction
{
    if (self.moreBtnBlock) {
        self.moreBtnBlock();
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
