//
//  NSURLRequest+decide.h
//  WBNetworking
//
//  Created by Haisheng Liang on 16/8/19.
//  Copyright © 2016年 Haisheng Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  判断是不是一样的请求
 */
@interface NSURLRequest (decide)

- (BOOL)isTheSameRequest:(NSURLRequest *)request;

@end
