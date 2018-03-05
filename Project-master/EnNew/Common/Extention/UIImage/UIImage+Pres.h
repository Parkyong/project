//
//  UIImage+Pres.h
//  mydrug
//
//  Created by ZhongxinMac on 14-7-24.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Pres)

/**
 *   返回能够自由拉伸不变形的图片
 *
 *  @param name      文件名
 *  @param leftScale 左边需要保护的比例（0~1）
 */
+ (UIImage *)resizedImage:(NSString *)name leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale;
+ (UIImage *)resizedImg:(UIImage *) img leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale;

/*
 * 将图片剪裁至512*512*4/8字节以内
 */
- (UIImage*)cropImage;

@end
