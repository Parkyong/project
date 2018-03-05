//
//  EnnTipsManager.h
//  EnNew
//
//  Created by 莫名 on 16/11/8.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface EnnTipsManager : NSObject

+ (void)showTipsMessage:(NSString*)message;

+ (void)showTipsMessage:(NSString*)message completion:(void(^)())completion;

+ (void)showTipsMessage:(NSString *)message stayTime:(NSTimeInterval)stay completion:(void(^)())completion;

+ (void)showLoadingMessage:(NSString*)message;

+ (void)showInfoMessage:(NSString*)message;

+ (void)showErrorMessage:(NSString*)message;

+ (void)hideMessage;

@end

@interface EnnProgressHUD : MBProgressHUD

@property (nonatomic, assign) BOOL canTouch;

@end
