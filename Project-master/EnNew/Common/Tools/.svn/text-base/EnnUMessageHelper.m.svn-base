//
//  EnnUMessageHelper.m
//  EnNew
//
//  Created by 莫名 on 17/2/28.
//  Copyright © 2017年 hy. All rights reserved.
//

#import "EnnUMessageHelper.h"

@interface EnnUMessageHelper ()
@property (nonatomic, strong) NSDictionary *userInfo;
@end

@implementation EnnUMessageHelper

+ (instancetype)sharedInstance {
    
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - 初始化友盟推送
+ (void)startWithLaunchOptions:(NSDictionary *)launchOptions {
    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:UMESSAGE_APPKEY launchOptions:launchOptions];
    //注册通知
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = [EnnUMessageHelper sharedInstance];
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    
    //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1_identifier";
    action1.title=@"打开应用";
    action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    action2.identifier = @"action2_identifier";
    action2.title=@"忽略";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action2.destructive = YES;
    UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
    actionCategory1.identifier = @"category1";//这组动作的唯一标示
    [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
    
    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
        [center setNotificationCategories:categories_ios10];
    }else
    {
        [UMessage registerForRemoteNotifications:categories];
    }
    
    //如果对角标，文字和声音的取舍，请用下面的方法
    //UIRemoteNotificationType types7 = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
    //UIUserNotificationType types8 = UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge;
    //[UMessage registerForRemoteNotifications:categories withTypesForIos7:types7 withTypesForIos8:types8];
    
    //for log
    [UMessage setLogEnabled:YES];
}

#pragma mark - 注册推送
+ (void)registerForRemoteNotifications {
    [UMessage registerForRemoteNotifications];
}

#pragma mark - 关闭推送
+ (void)unregisterForRemoteNotifications {
    [UMessage unregisterForRemoteNotifications];
}

+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMessage didReceiveRemoteNotification:userInfo];
}

+ (void)setAutoAlert:(BOOL)value {
    [UMessage setAutoAlert:value];
}

+ (void)showCustomAlertViewWithUserInfo:(NSDictionary *)userInfo {
    [EnnUMessageHelper sharedInstance].userInfo = userInfo;
    
    // 应用当前处于前台时，需要手动处理
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UMessage setAutoAlert:NO];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送消息"
                                                                message:@"userinfo中要显示的值（待修改）"
                                                               delegate:[EnnUMessageHelper sharedInstance]
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定",  nil];
            [alertView show];
        });
    }
    return;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // 如果不调用此方法，统计数据会拿不到，但是如果调用此方法，会再弹一次友盟定制的alertview显示推送消息
        // 所以这里根据需要来处理是否屏掉此功能
        [UMessage sendClickReportForRemoteNotification:[EnnUMessageHelper sharedInstance].userInfo];
    }
    return;
}

@end
