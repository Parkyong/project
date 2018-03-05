//
//  NSURLRequest+decide.h
//  WBNetworking
//
//  Created by Haisheng Liang on 16/8/19.
//  Copyright © 2016年 Haisheng Liang. All rights reserved.
//

#import "NSURLRequest+decide.h"

@implementation NSURLRequest (decide)

- (BOOL)isTheSameRequest:(NSURLRequest *)request {
    if ([self.HTTPMethod isEqualToString:request.HTTPMethod]) {
        if ([self.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
            if ([self.HTTPMethod isEqualToString:@"GET"]||[self.HTTPBody isEqualToData:request.HTTPBody]) {
                return YES;
            }
        }
    }
    return NO;
}

@end
