//
//  BaseViewController.h
//  EJZG
//
//  Created by zhngyy on 16/8/3.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//是否hidden 返回按钮
@property (nonatomic,assign)BOOL isHiddenBackBtn;

//导航栏透明
@property (nonatomic,assign) CGFloat currentOpacity;
//导航栏隐藏
@property (nonatomic,assign) BOOL isHiddenNav;

//searchBar
@property (nonatomic,strong) EnnSearchBar *searchBar;

//是否显示SearchBar默认不显示
@property (nonatomic,assign) BOOL isShowSearchBar;

//更多按钮
@property (nonatomic,strong) UIButton *moreBtn;

/**
 *  通过文字和文字颜色来添加左侧按钮
 *
 *  @param title  按钮名称
 *  @param color  文字颜色
 *  @param action 事件
 */
- (void)addLeftBtnWithTitle:(NSString*)title
                      color:(UIColor*)color
                     action:(SEL)action;

/**
 *  通过图片来创建左侧侧按钮
 *
 *  @param image  图片
 *  @param action 事件
 */
- (void)addLeftBtnWithImage:(UIImage*)image action:(SEL)action;

/**
 *  通过文字和文字颜色来添加右侧按钮
 *
 *  @param title  按钮名称
 *  @param color  文字颜色
 *  @param action 事件
 */
- (void)addRightBtnWithTitle:(NSString*)title color:(UIColor*)color action:(SEL)action;

/**
 *  通过图片来创建右侧侧按钮
 *
 *  @param image  图片
 *  @param action 事件
 */
- (void)addRightBtnWithImage:(UIImage*)image action:(SEL)action;

/**
 *  设置导航条背景透明度
 *
 *  @param alpha 透明度
 */
-(void)setNavBackgroudAlpha:(CGFloat )alpha;

// 导航控制器返回事件
- (void)navBackAction;

//无数据的时候弹出空页面
- (void)reloadNoDataWithView:(UIView *)onView;

@end
