//
//  AppDelegate.m
//  Daiba
//
//  Created by YouMeng on 2017/7/26.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "AppDelegate.h"
#import "YMTabBarController.h"
#import "YMWelcomeController.h"
//友盟统计
#import "UMMobClick/MobClick.h"
#import "JPUSHService.h"
#import <AVFoundation/AVFoundation.h>
#import "YMMsgListController.h"

#import <MGBaseKit/MGBaseKit.h>
#import <MGLivenessDetection/MGLivenessDetection.h>
#import "UIDevice+IdentifierAddition.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置导航栏按钮的颜色
    [[UINavigationBar appearance]setTintColor:NavBarTintColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //监听网络情况
    if (![YMTool connectedToNetwork]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请连接网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    //联网授权
    NSString* uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    //查看目前SDK的授权状态
    NSLog(@"NetworkWithUUIDexpired at: %@", [LicenseManager takeLicenseFromNetworkWithUUID: uuid]);
     DDLog(@"uuid == %@",uuid);
    NSLog(@"LicenseManager == %@",[LicenseManager setLicense:uuid]);
    NSLog(@"expired at: %@", [LicenseManager checkCachedLicense]);
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    // 可以添加自定义categories
    // NSSet<UNNotificationCategory *> *categories for iOS10 or later
    // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //注册极光推送
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey
                          channel:kChannel
                 apsForProduction:kIsProduct
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            DDLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            DDLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    //实例主窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BOOL isOpen = [kUserDefaults boolForKey:kFirstOpen];
    //引导页 欢迎界面
    if (!isOpen) {
        //若已登陆
        YMTabBarController *homeVc = [[YMTabBarController alloc] init];
        self.window.rootViewController = homeVc;
       // self.window.rootViewController = [[YMWelcomeController alloc] init];
    }else{
        //若已登陆
        YMTabBarController *homeVc = [[YMTabBarController alloc] init];
        self.window.rootViewController = homeVc;
    }
    //每次打开设置未登陆
    [kUserDefaults setBool:NO forKey:kisLoginClick];
    // [JPUSHService resetBadge];//清空JPush服务器中存储的badge值
    
    //记录打开情况
    [kUserDefaults setBool:YES forKey:kFirstOpen];
    self.window.backgroundColor = WhiteColor;
    [self.window makeKeyAndVisible];
    
    //注册友盟统计
    UMConfigInstance.appKey    = kUMAppKey;
    UMConfigInstance.channelId = kChannel;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    //上报版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //设置 数据发送策略
    UMConfigInstance.ePolicy = BATCH;
    // 测试日志
    [MobClick setLogEnabled:YES];
    
    //重新记录进入的时间
    NSDate *nowDate = [NSDate date];
    [kUserDefaults setObject:nowDate forKey:kBeginTime];
    [kUserDefaults synchronize];
    
    DDLog(@"interval == %@ \n  uniqueDeviceIdentifier == %@ \n",[kUserDefaults valueForKey:kUseTime] ,[UIDevice currentDevice].uniqueDeviceIdentifier);
    
    //监听网络情况
    if (![YMTool connectedToNetwork]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请连接网络！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //上报使用时长信息
        if (![NSString isEmptyString:[kUserDefaults valueForKey:kUseTime]] ) {
            [self reportUserTimeInfo];
        }
    }

    return YES;
}
#pragma mark - application
- (void)applicationWillResignActive:(UIApplication *)application {
    DDLog(@"放弃激活");
    NSDate *endTime = [NSDate date];
    [kUserDefaults setObject:endTime forKey:kEndTime];
    [kUserDefaults synchronize];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //记录结束时间
    NSDate *endTime = [NSDate date];
    [kUserDefaults setObject:endTime forKey:kEndTime];
    [kUserDefaults synchronize];
    DDLog(@"已经进入后台endTime == %@",endTime);
    //添加此段代码后，程序进入后台10分钟内会响应 applicationWillTerminate 函数，可以在其中添加保存或者清理工作。
        [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^(){
            //程序在10分钟内未被系统关闭或者强制关闭，则程序会调用此代码块，可以在这里做一些保存或者清理工作
            NSLog(@"程序关闭");
             [self recordUseTimeLater];
         }];

}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    DDLog(@"willEnterForeground");
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    //记录时间
    [self recordUseTimeLater];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
      DDLog(@"后台进入前台激活");
}
- (void)applicationWillTerminate:(UIApplication *)application {
    DDLog(@"应用中断");
    [self saveLoacalUseTime];
}
//本地记录时间
-(void)saveLoacalUseTime{
    //记录结束时间
    NSDate *endTime  = [NSDate date];
    NSDate* beginTime  = [kUserDefaults valueForKey:kBeginTime];
    double interval  = [endTime timeIntervalSinceDate:beginTime];
    
    // 获取本地 记录文件
    NSString* userTime = [kUserDefaults valueForKey:kUseTime];
    NSMutableString * mutUseTime ;
    if (userTime) {
        mutUseTime = [[NSMutableString alloc]initWithString:userTime];
    }else{
        mutUseTime = [[NSMutableString alloc]init];
    }
    // 没有时间记录，记录当前用时     有时间记录，拼接在后面
    if ([NSString isEmptyString:mutUseTime]) {
        [kUserDefaults setObject:[NSString stringWithFormat:@"%.0f",interval] forKey:kUseTime];
        [kUserDefaults synchronize];
    }else{
        mutUseTime = [mutUseTime stringByAppendingString:[NSString stringWithFormat:@",%.0f",interval]].mutableCopy;
        [kUserDefaults setObject:mutUseTime forKey:kUseTime];
        [kUserDefaults synchronize];
    }

}

-(void)reportUserTimeInfo{
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    //联网授权
    NSString* uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    //系统版本
    [param setObject:[UIDevice currentDevice].systemVersion forKey:@"ios_version"];
    [param setObject:uuid forKey:@"ios_uuid"];
    //包名
    [param setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:@"package_name"];
    // mac地址
    [param setObject:[UIDevice currentDevice].macaddress forKey:@"ios_mac"];
    //app 版本
    [param setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"app_version"];
    //手机品牌
    [param setObject:[YMTool deviceModel] forKey:@"mobile_brand"];
    // smi 卡信息
    [param setObject:[UIDevice getIMSI] forKey:@"sim_id"];
    [param setObject:@(self.window.bounds.size.width) forKey:@"screen_width"];
    [param setObject:@(self.window.bounds.size.height) forKey:@"screen_height"];
     DDLog(@"scWidth == %f,scHeight == %f",self.window.bounds.size.width * ([[UIScreen mainScreen] scale]),self.window.bounds.size.height * ([[UIScreen mainScreen] scale]));
    //分辨率
    [param setObject:@(self.window.bounds.size.width * self.window.bounds.size.height) forKey:@"screen_ratio"];
    //是否越狱
    [param setObject:@([UIDevice currentDevice].isJailBreak) forKey:@"is_root"];
    [param setObject:[kUserDefaults valueForKey:kUseTime] forKey:@"use_time"];
    
    DDLog(@"sim == %@  platform == %@  address == %@  address == %@",[UIDevice getIMSI],[UIDevice currentDevice].platform,[UIDevice currentDevice].macaddress,[UIDevice currentDevice].getMacAddress);
  
    [[HttpManger sharedInstance]callHTTPReqAPI:LogReportURL params:param view:nil loading:NO tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        [kUserDefaults setObject:@"" forKey:kUseTime];
        [kUserDefaults synchronize];
    }];
}
//记录时间
-(void)recordUseTimeLater{
    NSDate *nowTime  = [NSDate date];
    NSDate* endTime  = [kUserDefaults valueForKey:kEndTime];
    double interval  = [nowTime timeIntervalSinceDate:endTime];
    //当 后台时间 < 30 算同一次 ， > 30 s 重新记录一次
    if ( interval > 3 ) {
        [self saveLoacalUseTime];
    }else{
        [kUserDefaults setObject:nil forKey:kEndTime];
        [kUserDefaults synchronize];
    }
    
    DDLog(@"已经进入后台endTime == %@。 interval == %f kUseTime == %@  \n",endTime,interval,[kUserDefaults valueForKey:kUseTime]);
}

#pragma mark - 注册极光推送 上报 deviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
//实现注册APNs失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    DDLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
#pragma mark -  点开会响应这个
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    //设置badge值，本地仍须调用UIApplication:setApplicationIconBadgeNumber函数
    [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//小红点清0操作
    
    DDLog(@"notification == %@",userInfo);
    if ([userInfo[@"redirectUrl"] isEqualToString:@"message"]) {
        DDLog(@"系统消息列表");
        //在登陆情况下跳转消息中心，未登陆情况下跳转主页
        if ([[YMUserManager shareInstance] isValidLogin]) {
            [self pushToMsgListController];
        }else{
        }
    }
    if ([userInfo[@"redirectUrl"] isEqualToString:@"redpaper"]) {
        DDLog(@"红包列表");
        //在登陆情况下跳转消息中心，未登陆情况下跳转主页
        if ([[YMUserManager shareInstance] isValidLogin]) {
            [self pushToRedListController];
        }else{
            
        }
    }
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
/*
 * @brief handle UserNotifications.framework [willPresentNotification:withCompletionHandler:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param notification 前台得到的的通知对象
 * @param completionHandler 该callback中的options 请使用UNNotificationPresentationOptions
 */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler{
    //设置badge值，本地仍须调用UIApplication:setApplicationIconBadgeNumber函数
    [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//小红点清0操作
    
    //ios10 收到消息通知
    NSDictionary * userInfo = notification.request.content.userInfo;
    DDLog(@"ios 10 收到推送 %@",userInfo);
    if ([userInfo[@"redirectUrl"] isEqualToString:@"message"]) {
        DDLog(@"系统消息列表");
    }
    if ([userInfo[@"redirectUrl"] isEqualToString:@"redpaper"]) {
        DDLog(@"红包列表");
    }
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    //本地通知
    else{
        
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);// 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    
    //如果应用在前台，在这里执行
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新消息" message:notification.request.content.userInfo[@"aps"][@"alert"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [alertView show];
    //播放语音
    // [self readMsgWithMessage:userInfo[@"aps"][@"alert"]];
}

//如果 App状态为正在前台或者点击通知栏的通知消息，那么此函数将被调用，并且可通过AppDelegate的applicationState是否为UIApplicationStateActive判断程序是否在前台运行
//基于iOS 7 及以上的系统版本，如果是使用 iOS 7 的 Remote Notification 特性那么处理函数需要使用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
    [JPUSHService resetBadge];
    [application setApplicationIconBadgeNumber:0];//小红点清0操作
    DDLog(@"ios7 收到消息推送 == %@",userInfo);
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    //判断程序是否在前台运行
    if (application.applicationState == UIApplicationStateActive) {
        //如果应用在前台，在这里执行
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新消息" message:content delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil,nil];
        [alertView show];
        
        [JPUSHService handleRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
        return;
    }
    DDLog(@"收到推送 userInfo == %@",userInfo);
    // iOS 7 Support Required,处理收到的APNS信息
    //如果应用在后台，在这里执行
    //ios10 收到消息通知
    if ([userInfo[@"redirectUrl"] isEqualToString:@"message"]) {
        DDLog(@"系统消息列表");
        [self pushToMsgListController];
    }
    if ([userInfo[@"redirectUrl"] isEqualToString:@"redpaper"]) {
        DDLog(@"红包列表");
        [self pushToRedListController];
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    //播放语音
    // [self readMsgWithMessage:userInfo[@"aps"][@"alert"]];
    
}
#pragma mark - 收到消息跳转
-(void)pushToMsgListController{
    YMMsgListController* mvc = [[YMMsgListController alloc]init];
    mvc.title       = @"消息中心";
    YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:mvc];
    //window找到根控制器
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController)
    {
        topRootViewController = topRootViewController.presentedViewController;
    }
    DDLog(@"topRootViewController == %@",topRootViewController);
    if (![topRootViewController isKindOfClass:[YMNavigationController class]]) {
        mvc.isMsgPushed = YES;
        [topRootViewController presentViewController:nav animated:YES completion:nil];
    }else{
        [topRootViewController.navigationController pushViewController:nav animated:YES];
    }
}

-(void)pushToRedListController{

}
#pragma mark - 收到消息播放语音
-(void)readMsgWithMessage:(NSString* )msg{
    //语音播报文件
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:msg];
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置语言
    utterance.voice = voice;
    //    NSLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
    utterance.volume= 1;  //设置音量（0.0~1.0）默认为1.0
    utterance.rate= AVSpeechUtteranceDefaultSpeechRate;  //设置语速
    utterance.pitchMultiplier= 1;  //设置语调
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
    [synth speakUtterance:utterance];
    
}


@end
