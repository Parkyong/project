//
//  ErrorViewManager.h
//  EJZG
//
//  Created by zhngyy on 16/9/5.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ErrorViewType){
    //无网络
    ErrorWithDisconnectNetWork,
    //没有数据
    ErrorWithHaveNoData,
    //服务器异常
    ErrorWithServerAbnormal,
};

@interface ErrorViewManager : UIView




//+(ErrorViewManager *)shareErrorViewManager;


+ (void)showOnView:(UIView *)view
              type:(ErrorViewType)type
             block:(Void_Block)block;
+ (void)disMiss:(UIView *)view;
@end
