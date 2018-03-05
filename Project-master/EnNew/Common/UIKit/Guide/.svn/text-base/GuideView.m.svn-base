//
//  GuideView.m
//  GuideViewController
//
//  Created by 莫名 on 17/3/3.
//  Copyright © 2017年 hy. All rights reserved.
//

#import "GuideView.h"

#define HY_SCREEN_W     [UIScreen mainScreen].bounds.size.width
#define HY_SCREEN_H     [UIScreen mainScreen].bounds.size.height
#define HY_SCREEN_SCALE [UIScreen mainScreen].scale

/* 设置参数 */
#define HY_GUIDE_IMAGE_NAME             @"userGuide"    // 引导图格式 例：<name>00 <name>01
#define HY_ENTER_BTN_IMAGE_NAME         @"btn_guide"    // 进入按钮图片名称
#define HY_GUIDE_PAGE_COUNT             4               // 引导页页数
#define HY_ENTER_BTN_MARGIN_BOTTOM      80.f            // 进入按钮距底部间距
#define HY_PAGE_COUNTROL_MARGIN_BOTTOM  20.f            // 分页计数器距底部间距

@interface GuideView()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}
@end

@implementation GuideView

+ (instancetype)shareGuideView {
    
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)showGuideView {
    
    if ([self checkIsNewVersion]) {
        self.isNewVersion = YES;
        [self initializer];
    }
}

- (instancetype)init {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

- (void)initializer {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.contentSize = CGSizeMake(HY_SCREEN_W * HY_GUIDE_PAGE_COUNT, HY_SCREEN_H);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    for (int i = 0; i < HY_GUIDE_PAGE_COUNT; i++) {
        
        NSString *imageName = [NSString stringWithFormat:@"%@%02d", HY_GUIDE_IMAGE_NAME,i];
        UIImage *image = [UIImage imageNamed:imageName];
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 0, HY_SCREEN_W * HY_SCREEN_SCALE, HY_SCREEN_H * HY_SCREEN_SCALE));
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:imageRef]];
        imageView.frame = CGRectMake(i * HY_SCREEN_W, 0, HY_SCREEN_W, HY_SCREEN_H);
        [_scrollView addSubview:imageView];
        
        if (i == HY_GUIDE_PAGE_COUNT - 1) {
        
            imageView.userInteractionEnabled = YES;
            UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *enterImage = [UIImage imageNamed:HY_ENTER_BTN_IMAGE_NAME];
            [enterBtn setBackgroundImage:enterImage forState:UIControlStateNormal];
            CGFloat btnW = enterImage.size.width;
            CGFloat btnH = enterImage.size.height;
            CGFloat btnX = (HY_SCREEN_W - btnW) * 0.5;
            CGFloat btnY = HY_SCREEN_H - btnH - HY_ENTER_BTN_MARGIN_BOTTOM;
            enterBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            [enterBtn addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:enterBtn];
        }
    }
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, HY_SCREEN_H - HY_PAGE_COUNTROL_MARGIN_BOTTOM - 20, HY_SCREEN_W, 20)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.numberOfPages = HY_GUIDE_PAGE_COUNT;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor blueColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    [self addSubview:_pageControl];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)enterAction {
    
    [self hidden];
}

- (void)hidden {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)checkIsNewVersion {
    
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setObject:[self getCurrentVersion] forKey:@"CFBundleShortVersionString"];
    
    return ![lastVersion isEqualToString:[self getCurrentVersion]];
}

- (NSString *)getCurrentVersion {
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString * appVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger currentPage = (scrollView.contentOffset.x + HY_SCREEN_W * 0.5) / HY_SCREEN_W;
    _pageControl.currentPage = currentPage;
}

@end
