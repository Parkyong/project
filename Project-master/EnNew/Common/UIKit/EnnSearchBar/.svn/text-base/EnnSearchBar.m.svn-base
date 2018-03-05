//
//  EnnSearchBar.m
//  EnNew
//
//  Created by 莫名 on 16/11/8.
//  Copyright © 2016年 hy. All rights reserved.
//

#import "EnnSearchBar.h"

@interface EnnSearchBar()
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, copy) Void_Block block;
@end

@implementation EnnSearchBar
{
    BOOL _isConstraints;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 300*UI_SCALE_W, 30);
        [self addSubview:self.textField];
        [self addSubview:self.btn];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

-(void)setIsCanInput:(BOOL)isCanInput{
    _isCanInput = isCanInput;
    self.btn.hidden = isCanInput;
}

-(UIButton *)btn{
    if(!_btn) {
        _btn = [UIButton newAutoLayoutView];
        [_btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

-(void)updateConstraints{
    if(!_isConstraints){
        [_textField autoPinEdgesToSuperviewEdges];
        [_btn autoPinEdgesToSuperviewEdges];
    }
    [super updateConstraints];
    _isConstraints = YES;
}

- (void)btnClick {
    if(_block)
    {
        _block();
    }
}

- (void)searchClick:(Void_Block)click{
    if(click)
    {
        _block = click;
    }
}

-(UITextField *)textField {
    if(!_textField) {
        _textField = [UITextField newAutoLayoutView];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.font = [UIFont systemFontOfSize:12];
        _textField.backgroundColor = [UIColorFromHex(0xE7E7E7) colorWithAlphaComponent:0.8];
        UIView *leftSupView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 15)];
        leftView.center = leftSupView.center;
        leftView.image = [UIImage imageNamed:@"Nav_icon_Search_28px"];
        leftView.contentMode =UIViewContentModeScaleAspectFit;
        [leftSupView addSubview:leftView];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.leftView = leftSupView;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.layer.cornerRadius = 4.f;
        _textField.layer.masksToBounds = YES;
    }
    return _textField;
}

@end
