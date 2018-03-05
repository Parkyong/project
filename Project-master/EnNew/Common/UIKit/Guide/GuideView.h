//
//  GuideView.h
//  GuideViewController
//
//  Created by 莫名 on 17/3/3.
//  Copyright © 2017年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideView : UIView

@property (nonatomic, assign) BOOL isNewVersion;

+ (instancetype)shareGuideView;
- (void)showGuideView;

@end
