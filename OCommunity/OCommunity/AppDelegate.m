//
//  AppDelegate.m
//  OCommunity
//
//  Created by Runkun1 on 15/4/23.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "AppDelegate.h"
#import <AddressBook/AddressBook.h>
#import "SuperMarketListViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "BPush.h"
@interface AppDelegate ()

{
    BMKMapManager *_mapManager;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    NSString *isFirseUse = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    if (isFirseUse == NULL) {
        SuperMarketListViewController *marketVC = [[SuperMarketListViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:marketVC];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
    
    //*********/注册远程通知
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
    
    [BPush registerChannel:launchOptions apiKey:@"TustlB4aGFZbGA9VqiOENtym" pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
    
    //用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"=== 从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
    
    //角标清零
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    //talkingData 应用数据分析工具
    [TalkingData sessionStarted:@"9F7BA6CA45FC34E3042361D94B507C93" withChannelId:@"iOS"];
    
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"nGIyBOsAXNNGl17OItZekG3O" generalDelegate:self];
    if (!ret) {
        [self.window makeToast:@"定位失败请手动选择超市" duration:1.0 position:@"center"];
    }
    
    //监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    hostReach = [Reachability reachabilityWithHostName:@"61.135.169.121"];
    [hostReach startNotifier];
    
    [WXApi registerApp:APP_ID withDescription:@"Iso2o"];
    
    return YES;
}

-(void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    switch (status) {
        case NotReachable:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络中断" message:@"断网了,请检查网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
            break;
        case ReachableViaWiFi:
        case ReachableViaWWAN:{
            [self.window makeToast:@"当前使用无线网络" duration:1.0 position:@"center"];
        }
            break;
        case kReachableVia2G:{
            [self.window makeToast:@"当前使用2G网络,注意流量哦!" duration:1.0 position:@"center"];
        }
            break;
        case kReachableVia3G:{
            [self.window makeToast:@"当前使用3G网络,注意流量哦!" duration:1.0 position:@"center"];
        }
            break;
        case kReachableVia4G:{
            [self.window makeToast:@"当前使用4G网络,注意流量哦!" duration:1.0 position:@"center"];
        }
            break;
            
        default:
            break;
    }
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册远程通知失败 error = %@",[error description]);
}

//成功获取token
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@" ------- 获取到 pushToken = %@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    
}

//收到远程通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"============= remote noti = %@",userInfo);

    completionHandler(UIBackgroundFetchResultNewData);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [BPush handleNotification:userInfo];
}


-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"==== url = %@",url);
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"===== paymentresult = %@",resultDic);
        }];
        return YES;
    }
    if ([url.host isEqualToString:@"platformpi"]) {
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"======= auth result = %@",resultDic);
        }];
        return YES;
    }
    
    return [WXApi handleOpenURL:url delegate:self];
}

-(void)onResp:(BaseResp *)resp
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"wxPay_noti" object:nil userInfo:@{@"resp":resp}];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"===== paymentresult = %@",resultDic);
        }];
        return YES;
    }
    if ([url.host isEqualToString:@"platformpi"]) {
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"======= auth result = %@",resultDic);
        }];
        
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [BMKMapView didForeGround];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
