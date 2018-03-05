//
//  XHLaunchAd.m

//  Copyright (c) 2016 XHLaunchAd (https://github.com/CoderZhuXH/XHLaunchAd)

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "XHLaunchAd.h"
#import <MediaPlayer/MediaPlayer.h>
#define DefaultDuration 3;//默认停留时间

@interface XHLaunchAd()

@property(nonatomic,strong)UIImageView *launchImgView;
@property(nonatomic,strong)UIImageView *adImgView;
@property(nonatomic,strong)UIButton *skipButton;
@property(nonatomic,strong)MPMoviePlayerController *moviePlayer;
@property(nonatomic,assign)NSInteger duration;
//@property(nonatomic,copy) dispatch_source_t timer;
@property(nonatomic,strong)NSTimer *timer;

@end
@implementation XHLaunchAd

- (void)dealloc {

}

/**
 *  初始化启动页广告
 *
 *  @param frame    广告frame
 *  @param duration 广告停留时间
 *
 *  @return 启动页广告
 */
- (instancetype)initWithFrame:(CGRect)frame andDuration:(NSInteger)duration
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _adFrame = frame;
        _duration = duration;
        self.frame = [UIScreen mainScreen].bounds;
        [self addSubview:self.launchImgView];
        [self addSubview:self.adImgView];
//        [self setUpVideo];
        [self addSubview:self.skipButton];
        [self animateStart];
        [self animateEnd];
    }
    return self;
}

#pragma mark - getters

-(UIImageView *)launchImgView
{
    if(_launchImgView==nil)
    {
        _launchImgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _launchImgView.image = [self launchImage];
    }
    return _launchImgView;
}

-(UIImageView *)adImgView
{
    if(_adImgView==nil)
    {
        _adImgView = [[UIImageView alloc] initWithFrame:_adFrame];
        _adImgView.userInteractionEnabled = YES;
        _adImgView.alpha = 0.2;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_adImgView addGestureRecognizer:tap];
    }
    return _adImgView;
}

-(UIButton *)skipButton {
    if(_skipButton == nil)
    {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-70,30, 60, 30);
        _skipButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _skipButton.layer.cornerRadius = 15;
        _skipButton.layer.masksToBounds = YES;
        NSInteger duration =DefaultDuration;
        if(_duration) duration = _duration;
        [_skipButton setTitle:[NSString stringWithFormat:@"%zd 跳过",duration] forState:UIControlStateNormal];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
        [_skipButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
        [self.timer fire];
    }
    return _skipButton;
}

-(void)skipAction{
    if (self.finishBlock) {
        _finishBlock();
    }
    [self remove];
}

-(void)animateStart {
    CGFloat duration = DefaultDuration;
    if(_duration) duration = _duration;
    duration= duration/4.0;
    if(duration>1.0) duration=1.0;
    [UIView animateWithDuration:duration animations:^{
        
        self.adImgView.alpha = 1;
        
    } completion:^(BOOL finished) {
    }];
}

- (NSTimer *)timer {
    if (!_duration) { _duration = DefaultDuration }
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)timerAction:(id)obj {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_skipButton setTitle:[NSString stringWithFormat:@"%zd 跳过",_duration--] forState:UIControlStateNormal];
    });
}

//-(void)dispath_tiemr {
//    NSTimeInterval period = 1.0;//每秒执行
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
//    
//    __block NSInteger duration = DefaultDuration;
//    if(_duration) duration = _duration;
//    
//    dispatch_source_set_event_handler(_timer, ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//             duration--;
//            [_skipButton setTitle:[NSString stringWithFormat:@"%ld 跳过",duration] forState:UIControlStateNormal];
//        });
//    });
//    dispatch_resume(_timer);
//}

-(void)animateEnd{
    
    CGFloat duration = DefaultDuration;
    if(_duration) duration = _duration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self remove];
    });
}

-(void)remove{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [UIView animateWithDuration:0.8 animations:^{
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.transform=CGAffineTransformMakeScale(1.5, 1.5);
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    if(self.clickBlock)
    {
        self.clickBlock();
    }
}
-(UIImage *)launchImage
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";//横屏 @"Landscape"
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImageName = dict[@"UILaunchImageName"];
            UIImage *image = [UIImage imageNamed:launchImageName];
            return image;
        }
    }
    NSLog(@"请添加启动图片");
    return nil;
}

- (void)setUpVideo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"welcome_video" ofType:@"mp4"];
    NSURL *contentUrl = [NSURL fileURLWithPath:filePath];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:contentUrl];
    [self addSubview:self.moviePlayer.view];
    self.moviePlayer.repeatMode = MPMovieRepeatModeOne;
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    self.moviePlayer.view.frame = _adFrame;
    self.moviePlayer.view.alpha = 0;
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    [UIView animateWithDuration:3.0 animations:^{
        self.moviePlayer.view.alpha = 1;
        [self.moviePlayer prepareToPlay];
        [self.moviePlayer play];
    }];
}

-(void)setAdFrame:(CGRect)adFrame
{
    _adFrame = adFrame;
    _adImgView.frame = adFrame;
}
-(void)setHideSkip:(BOOL)hideSkip
{
    _hideSkip = hideSkip;
    _skipButton.hidden = hideSkip;
}
-(void)imgUrlString:(NSString *)imgUrlString completed:(XHWebImageCompletionBlock)completedBlock
{
     [_adImgView xh_setImageWithURL:[NSURL URLWithString:imgUrlString] placeholderImage:nil options:XHWebImageRefreshCached completed:completedBlock];
}

+(void)clearDiskCache
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *path = [XHWebImageDownloader xh_cacheImagePath];
        [fileManager removeItemAtPath:path error:nil];
        [XHWebImageDownloader xh_checkDirectory:[XHWebImageDownloader xh_cacheImagePath]];
    });
}

+ (unsigned long long)imagesCacheSize {
    NSString *directoryPath = [XHWebImageDownloader xh_cacheImagePath];
    BOOL isDir = NO;
    unsigned long long total = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
            
            if (error == nil) {
                for (NSString *subpath in array) {
                    NSString *path = [directoryPath stringByAppendingPathComponent:subpath];
                    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                                          error:&error];
                    if (!error) {
                        total += [dict[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    
    return total;
}

@end