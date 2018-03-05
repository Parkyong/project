//
//  BaseWebViewController.m
//  EJZG
//
//  Created by zhngyy on 16/8/3.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#import "BaseWebViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#define ProgressH 2
@interface BaseWebViewController()<NJKWebViewProgressDelegate,UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@end
@implementation BaseWebViewController
{
    NJKWebViewProgress *_webLoadProgress; //加载的进度
    NJKWebViewProgressView *_progressView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    //初始化进度
    _webLoadProgress = [[NJKWebViewProgress alloc]init];
    self.webView.delegate = _webLoadProgress;
    _webLoadProgress.webViewProxyDelegate = self;
    _webLoadProgress.progressDelegate = self;
    //初始化进度View
    _progressView = [[NJKWebViewProgressView alloc]initWithFrame:CGRectMake(0,
                                                                            self.navigationController.navigationBar.bounds.size.height-ProgressH,
                                                                            self.navigationController.navigationBar.bounds.size.width,
                                                                            ProgressH)];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    if(self.progressBarBackgroundColor)
    {
        _progressView.progressBarView.backgroundColor = self.progressBarBackgroundColor;
    }
    else
    {
        _progressView.progressBarView.backgroundColor = [UIColor redColor];
    }
    if(self.urlString)
    {
        [self loadRequest];
    }
    if(self.htmlString)
    {
        [self loadHtmlString];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)navBackAction{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [super navBackAction];
    }
}

- (void)close{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 加载URL
- (void)loadRequest
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlString]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:30
                                    ];
    [self.webView loadRequest:request];
}

#pragma mark - 加载HTMLstring
- (void)loadHtmlString
{
    [self.webView loadHTMLString:self.htmlString baseURL:nil];
}

#pragma mark -NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress
        updateProgress:(float)progress
{
    //可以在这里面进行赋值title
//    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"%lf",progress);
    [_progressView setProgress:progress animated:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(0, 0, 19, 20);
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [button setBackgroundImage:[UIImage imageNamed:@"Nav_icon_back_40px"] forState:UIControlStateNormal];
    [button addTarget: self action:@selector(navBackAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.titleLabel.font = FONT_13;
    closeButton.frame = CGRectMake(0, 0, 40, 20);
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [closeButton addTarget: self action:@selector(close) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem *goBackButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc]initWithCustomView:closeButton];
    
    if ([webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[goBackButtonItem,closeButtonItem];
    }else{
         self.navigationItem.leftBarButtonItem = goBackButtonItem;
    }
}

-(UIWebView *)webView
{
    if(!_webView)
    {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.delegate = self;
    }
    return _webView;
}

@end
