//
//  AppDelegate.m
//  EnNew
//
//  Created by 莫名 on 16/11/8.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "AppDelegate.h"
#import "EnnTabBarControllerConfig.h"
#import "EnnPlusButtonSubclass.h"
#import "XHLaunchAd.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "EnnUMessageHelper.h"
#import "GuideView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 如不用中间加号按钮  则去掉下面这句
//    [EnnPlusButtonSubclass registerPlusButton];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    EnnTabBarControllerConfig *tabBarControllerConfig = [[EnnTabBarControllerConfig alloc] init];
    [self.window setRootViewController:tabBarControllerConfig.tabBarController];
    [self.window makeKeyAndVisible];
    
    // 显示引导页
    [[GuideView shareGuideView] showGuideView];
    
    if (![GuideView shareGuideView].isNewVersion) { // 新版本 显示引导页 不显示启动广告
        // 显示启动广告
        [self showAdsUI];
    }
    
    // 设置高德地图appkey
//    [AMapServices sharedServices].apiKey = MAMAP_SERVICE_APIKEY;
    // 初始化友盟推送
    [EnnUMessageHelper startWithLaunchOptions:launchOptions];
    
    return YES;
}

// iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    //关闭友盟自带的弹出框
    [EnnUMessageHelper setAutoAlert:NO];
    [EnnUMessageHelper didReceiveRemoteNotification:userInfo];
    
    //显示自定的的弹出框
    [EnnUMessageHelper showCustomAlertViewWithUserInfo:userInfo];
}

//iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [EnnUMessageHelper setAutoAlert:NO];
        //必须加这句代码
        [EnnUMessageHelper didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [EnnUMessageHelper didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)showAdsUI{
    //1.初始化启动页广告
    XHLaunchAd *launchAd = [[XHLaunchAd alloc] initWithFrame:CGRectMake(0, 0, _window.frame.size.width,  _window.frame.size.height) andDuration:5];
    
    //2.设置启动页广告图片的url(必须)
    NSString *imgUrlString = @"http://img.taopic.com/uploads/allimg/120906/219077-120Z616330677.jpg";
    
    [launchAd imgUrlString:imgUrlString completed:^(UIImage *image, NSURL *url) {
        //异步加载图片完成回调(若需根据图片实际尺寸,刷新广告frame,可在这里操作)
        //launchAd.adFrame = ...;
    }];
    
    //是否影藏'倒计时/跳过'按钮[默认显示](可选)
    launchAd.hideSkip = NO;
    
    //广告点击事件(可选)
    launchAd.clickBlock = ^(){
        
    };
    
    //3.添加至根控制器视图上
    [self.window.rootViewController.view addSubview:launchAd];
}

@end
