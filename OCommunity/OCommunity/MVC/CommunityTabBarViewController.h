//
//  CommunityTabBarViewController.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/24.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Market.h"

@interface CommunityTabBarViewController : UITabBarController<UITabBarControllerDelegate>

@property (nonatomic, strong) NSDictionary *marketDic;

@end
