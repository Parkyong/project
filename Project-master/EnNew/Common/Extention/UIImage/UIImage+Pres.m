//
//  UIImage+Pres.m
//  mydrug
//
//  Created by ZhongxinMac on 14-7-24.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "UIImage+Pres.h"

@implementation UIImage (Pres)

+ (UIImage *)resizedImage:(NSString *)name leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale
{
    UIImage *image = [self imageNamed:name];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * leftScale topCapHeight:image.size.height * topScale];
}
+ (UIImage *)resizedImg:(UIImage *) img leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale
{
    return [img stretchableImageWithLeftCapWidth:img.size.width * leftScale topCapHeight:img.size.height * topScale];
}

/*
 * 将图片剪裁至512*512*4/8字节以内
 */
- (UIImage*)cropImage
{
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    if (w > 0.f && h > 0.f && MAX(w, h) > 512.f) {
        w = (w > h ? 512.f : (w * 512.f / h));
        h = (w > h ? (h * 512.f / w) : 512.f);
        w = floorf(w);
        h = floorf(h);
        
        CGSize smallSize = CGSizeMake(w, h);
        CGRect smallRect = CGRectMake(0.f, 0.f, w, h);
        UIGraphicsBeginImageContext(smallSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextConcatCTM(context, CGAffineTransformMake(1.f, 0.f, 0.f, -1.f, 0.f, smallSize.height));
        CGContextDrawImage(context, smallRect, self.CGImage);
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return newImage;
    }
    
    return self;
}

@end
