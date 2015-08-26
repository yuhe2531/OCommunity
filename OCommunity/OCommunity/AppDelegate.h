//
//  AppDelegate.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/23.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "payRequsestHandler.h"
#import "BKDefine.h"
#import "WXApi.h"
#import "Reachability.h"
#import <BaiduMapAPI/BMapKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate, UIAlertViewDelegate,BMKGeneralDelegate>

{
    Reachability *hostReach;
}

@property (strong, nonatomic) UIWindow *window;
//@property (nonatomic,copy) NSString *localCity;
//@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

@end

