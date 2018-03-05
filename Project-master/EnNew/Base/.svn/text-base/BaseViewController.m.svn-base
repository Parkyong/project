//
//  BaseViewController.m
//  EJZG
//
//  Created by zhngyy on 16/8/3.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@end

@implementation BaseViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT_17,NSForegroundColorAttributeName:NavgationBarTitleColor}];
    if(self.navigationController.viewControllers.count>1){
        [self addLeftBtnWithImage:[UIImage imageNamed:@"Nav_icon_back_40px"] action:@selector(navBackAction)];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}


- (void)setIsShowSearchBar:(BOOL)isShowSearchBar {
    _isShowSearchBar = isShowSearchBar;
    if(isShowSearchBar == YES){
        self.navigationItem.titleView = self.searchBar;
    }
    else{
        self.navigationItem.titleView = nil;
    }
}

- (EnnSearchBar *)searchBar{
    if(!_searchBar) {
        _searchBar = [[EnnSearchBar alloc]init];
        [_searchBar searchClick:^{
            NSLog(@"点击搜索。。。");
        }];
    }
    return _searchBar;
}

- (void)setIsHiddenNav:(BOOL)isHiddenNav{
    _isHiddenNav = isHiddenNav;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeBottom|UIRectEdgeTop;
    }
    if(_isHiddenNav) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(_isHiddenNav){
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    
}

- (void)setIsHiddenBackBtn:(BOOL)isHiddenBackBtn{
    if(isHiddenBackBtn){
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = nil;
    }
    else{
        if(self.navigationController.viewControllers.count>1){
            [self addLeftBtnWithImage:[UIImage imageNamed:@"Nav_icon_back_40px"] action:@selector(navBackAction)];
        }
    }
}

- (void)addLeftBtnWithTitle:(NSString*)title  color:(UIColor*)color action:(SEL)action{
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
    if (color) {
        [settingBarButton setTintColor:color];
    }
    self.navigationItem.leftBarButtonItem = settingBarButton;
}

- (void)addLeftBtnWithImage:(UIImage*)image action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(0, 0, 19, 20);
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget: self action:action forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)addRightBtnWithTitle:(NSString*)title  color:(UIColor*)color action:(SEL)action{
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
    if (color) {
        [settingBarButton setTintColor:color];
    }
    [settingBarButton setTitleTextAttributes:@{NSFontAttributeName:FONT_15} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems = @[settingBarButton];
}

- (void)addRightBtnWithImage:(UIImage*)image action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(0, 0, 19, 20);
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget: self action:action forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)setNavBackgroudAlpha:(CGFloat )alpha{
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:alpha];
}

- (void)navBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadNoDataWithView:(UIView *)onView{
    [ErrorViewManager showOnView:onView type:ErrorWithHaveNoData block:nil];
}

@end
