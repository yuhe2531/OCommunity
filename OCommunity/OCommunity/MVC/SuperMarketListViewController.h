//
//  SuperMarketListViewController.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/23.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI/BMapKit.h>

@interface SuperMarketListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,BMKLocationServiceDelegate>

@end
