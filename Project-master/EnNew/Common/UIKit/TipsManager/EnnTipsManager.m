//
//  EnnTipsManager.m
//  EnNew
//
//  Created by 莫名 on 16/11/8.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "EnnTipsManager.h"

#define kAnimateDelay 1.75

@implementation EnnTipsManager

+ (void)load{
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
}

+ (EnnProgressHUD*)hud{
    //UIView *view = [PushManager currentViewController].view;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    EnnProgressHUD *hud;
    hud = (EnnProgressHUD*)[EnnProgressHUD HUDForView:keyWindow];
    if (!hud) {
        hud = (EnnProgressHUD*)[EnnProgressHUD showHUDAddedTo:keyWindow animated:YES];
    }else{
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES];
    }
    hud.userInteractionEnabled = YES;
    hud.backgroundView.userInteractionEnabled = YES;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:.7f];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.margin = 20.f;
    return hud;
}

+ (void)showTipsMessage:(NSString*)message{
    [EnnTipsManager showTipsMessage:message completion:nil];
}

+ (void)showTipsMessage:(NSString*)message completion:(void(^)())completion{
    [EnnTipsManager showTipsMessage:message stayTime:0 completion:completion];
}

+ (void)showTipsMessage:(NSString *)message stayTime:(NSTimeInterval)stay completion:(void(^)())completion{
    dispatch_async(dispatch_get_main_queue(), ^{
        EnnProgressHUD *hud = [EnnTipsManager hud];
        hud.mode = MBProgressHUDModeText;
        hud.canTouch = YES;
        hud.label.text = nil;
        hud.detailsLabel.text = message;
        hud.detailsLabel.font = FONT_14;
        hud.detailsLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        if (completion) {
            hud.completionBlock = completion;
        }
        hud.margin = 10.f;
        hud.minShowTime = stay;
        [hud hideAnimated:YES afterDelay:kAnimateDelay];
    });
}

+ (void)showLoadingMessage:(NSString*)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        EnnProgressHUD *hud = [EnnTipsManager hud];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.canTouch = NO;
        hud.label.text = message;
        hud.label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        [hud hideAnimated:YES afterDelay:10.f];
    });
}

+ (void)showInfoMessage:(NSString*)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        EnnProgressHUD *hud = [EnnTipsManager hud];
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = message;
        hud.label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        hud.customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    });
}

+ (void)showErrorMessage:(NSString*)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        EnnProgressHUD *hud = [EnnTipsManager hud];
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = message;
        hud.label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        hud.customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    });
}

+ (void)hideMessage{
    dispatch_async(dispatch_get_main_queue(), ^{
        //UIView *view = [PushManager currentViewController].view;
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [EnnProgressHUD hideHUDForView:keyWindow animated:NO];
    });
}

@end

@implementation EnnProgressHUD

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return !self.canTouch;
}

@end
