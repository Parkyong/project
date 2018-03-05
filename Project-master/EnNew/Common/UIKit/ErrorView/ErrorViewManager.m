//
//  ErrorViewManager.m
//  EJZG
//
//  Created by zhngyy on 16/9/5.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#import "ErrorViewManager.h"
static NSString *netWorkErrorStr = @"网络请求失败";
static NSString *netWorkErrorSubStr = @"请检查您的网络\n重新加载吧";
static NSString *haveNoDataErrorStr = @"没有更多数据了";
static NSString *haveNoDataErrorSubStr = @"欢迎到此一游\n数据跑月球上了";
static NSString *serviceErrorStr = @"服务器异常";
static NSString *serviceErrorSubStr = @"服务器开小差了\n耐心等待一会儿";
static ErrorViewManager *errorView = nil;
@interface ErrorViewManager()
@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *titleLable;

@property (nonatomic,strong)UILabel *subTitlelable;

@property (nonatomic,strong)UIButton *actionBtn;
@property (nonatomic,copy)Void_Block btnBlock;
@end

@implementation ErrorViewManager{
    BOOL _isContraints;
    UIView *_currentView;
    NSLayoutConstraint *_btnH;
}

-(void)updateConstraints{
    if(!_isContraints){
        //副标题居中，所有的约束都跟着这个走
        [self.titleLable autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:10];
        [self.titleLable autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [@[self.imageView,self.titleLable,self.subTitlelable,self.actionBtn] autoAlignViewsToAxis:ALAxisVertical];
        //重新加载btn
        [self.actionBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.subTitlelable withOffset:5];
//        [self.actionBtn autoSetDimensionsToSize:CGSizeMake(80, 30)];
        [self.actionBtn autoSetDimension:ALDimensionWidth toSize:80];
       _btnH = [self.actionBtn autoSetDimension:ALDimensionHeight toSize:30];
        //标题
        [self.titleLable autoSetDimension:ALDimensionHeight toSize:20];
        [self.subTitlelable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLable withOffset:5];
        //imageView
        [self.imageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.titleLable withOffset:-5];
    }
    _isContraints = YES;
    [super updateConstraints];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = BACKGROUD_COLOR;
        [self addSubview:self.imageView];
        [self addSubview:self.titleLable];
        [self addSubview:self.subTitlelable];
        [self addSubview:self.actionBtn];
    }
    return self;
}
//+(ErrorViewManager *)shareErrorViewManager{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        errorView = [[ErrorViewManager alloc]init];
//    });
//    return errorView;
//}

+ (void)showOnView:(UIView *)view
              type:(ErrorViewType)type
             block:(Void_Block)block{
    ErrorViewManager *manager;
    if([view.subviews containsObject:[view viewWithTag:9999]]){
        manager = [view viewWithTag:9999];
    }
    else{
        manager = [[ErrorViewManager alloc]init];
        manager.tag = 9999;
        [view addSubview:manager];
    }
    [manager errorType:type];
    [manager changeSuperViewStateWithType:type];
    [manager autoPinEdgesToSuperviewEdges];
    [manager autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:view];
    [manager autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:view];
    if(block){
        manager.btnBlock = block;
    }
}

- (void)errorType:(ErrorViewType)type{
    switch (type) {
        case ErrorWithDisconnectNetWork:{
            self.imageView.image = [UIImage imageNamed:@"icon-Failre180"];
            self.titleLable.text = netWorkErrorStr;
            self.subTitlelable.text = netWorkErrorSubStr;
            self.actionBtn.hidden = NO;
            _btnH.constant = 30;
        }
            break;
        case ErrorWithHaveNoData:{
            self.imageView.image = [UIImage imageNamed:@"icon-Failure180"];
            self.titleLable.text = haveNoDataErrorStr;
            self.subTitlelable.text = haveNoDataErrorSubStr;
            self.actionBtn.hidden = YES;
            _btnH.constant = 0;
        }
            break;
        case ErrorWithServerAbnormal:{
            self.imageView.image = [UIImage imageNamed:@"icon-Failure180"];
            self.titleLable.text = serviceErrorStr;
            self.subTitlelable.text = serviceErrorSubStr;
            self.actionBtn.hidden = NO;
            _btnH.constant = 30;
        }
            break;
        default:
            break;
    }
}

- (void)changeSuperViewStateWithType:(ErrorViewType)type{
    if(type == ErrorWithHaveNoData){
        if([self.superview isKindOfClass:[UIScrollView class]]){
            UIScrollView *scrollView = (UIScrollView *)self.superview;
            scrollView.scrollEnabled = YES;
        }
    }
    else{
        if([self.superview isKindOfClass:[UIScrollView class]]){
            UIScrollView *scrollView = (UIScrollView *)self.superview;
            scrollView.scrollEnabled = NO;
        }
    }
}

+ (void)disMiss:(UIView *)view{
    if([view isKindOfClass:[UIScrollView class]]){
        UIScrollView *scrollView = (UIScrollView *)view;
        scrollView.scrollEnabled = YES;
    }
    [[view viewWithTag:9999] removeFromSuperview];
}

-(UIImageView *)imageView{
    if(!_imageView){
        _imageView = [UIImageView newAutoLayoutView];
    }
    return _imageView;
}

-(UILabel *)titleLable{
    if(!_titleLable){
        _titleLable = [UILabel newAutoLayoutView];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.textColor = SUBTITLE_COLOR;
        _titleLable.font = FONT_15;
    }
    return _titleLable;
}

-(UILabel *)subTitlelable{
    if(!_subTitlelable){
        _subTitlelable = [UILabel newAutoLayoutView];
        _subTitlelable.textAlignment = NSTextAlignmentCenter;
        _subTitlelable.textColor = DETAIL_COLOR;
        _subTitlelable.font = FONT_13;
        _subTitlelable.numberOfLines = 2;
    }
    return _subTitlelable;
}

-(UIButton *)actionBtn{
    if(!_actionBtn){
        _actionBtn = [UIButton newAutoLayoutView];
        [_actionBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [_actionBtn setTitleColor:SUBTITLE_COLOR forState:UIControlStateNormal];
        _actionBtn.titleLabel.font = FONT_14;
        [_actionBtn addTarget:self action:@selector(refreshLoadData:) forControlEvents:UIControlEventTouchUpInside];
        [_actionBtn setTitle:@"正在加载..." forState:UIControlStateDisabled];
        [_actionBtn setBackgroundImage:[ToolsManager createImageWithColor:WHITE_COLOR] forState:UIControlStateNormal];
        [_actionBtn setBackgroundImage:[ToolsManager createImageWithColor:BACKGROUD_COLOR] forState:UIControlStateHighlighted];
        _actionBtn.layer.masksToBounds = YES;
        _actionBtn.layer.borderWidth = kOnePixel;
        _actionBtn.layer.cornerRadius = 2;
        _actionBtn.layer.borderColor = SUBTITLE_COLOR.CGColor;
    }
    return _actionBtn;
}

- (void)refreshLoadData:(UIButton *)sender{
    if(_btnBlock){
        _btnBlock();
    }
}
@end
