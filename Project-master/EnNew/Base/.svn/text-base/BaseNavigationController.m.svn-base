//
//  BaseNavigationController.m
//  EJZG
//
//  Created by zhngyy on 16/8/3.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}


- (void)removeNavigationBarUnderLineWithView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UIImageView class]] && subview.frame.size.height <= 1.0f) {
            [subview removeFromSuperview];
            return;
        }
        [self removeNavigationBarUnderLineWithView:subview];
    }
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)]&&animated == YES )
//    {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
//    [super pushViewController:viewController animated:animated];
//}
//
//- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
//{
//    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )
//    {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
//    
//    return  [super popToRootViewControllerAnimated:animated];
//    
//}
//
//- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] )
//    {
//        self.interactivePopGestureRecognizer.enabled = NO; }
//    return [super popToViewController:viewController animated:animated];
//}

@end
