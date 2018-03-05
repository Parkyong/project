//
//  EnnUMessageHelper.h
//  EnNew
//
//  Created by 莫名 on 17/2/28.
//  Copyright © 2017年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMessage.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

@interface EnnUMessageHelper : NSObject <UNUserNotificationCenterDelegate>

/**
 初始化友盟推送
 */
+ (void)startWithLaunchOptions:(NSDictionary *)launchOptions;

/**
 注册推送
 */
+ (void)registerForRemoteNotifications;

/**
 关闭推送
 */
+ (void)unregisterForRemoteNotifications;

/**
 应用处于运行时（前台、后台）的消息处理
 */
+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

/**
 是否开启友盟推送弹出框

 */
+ (void)setAutoAlert:(BOOL)value;

/**
 显示自定义弹出框
 */
+ (void)showCustomAlertViewWithUserInfo:(NSDictionary *)userInfo;

@end
