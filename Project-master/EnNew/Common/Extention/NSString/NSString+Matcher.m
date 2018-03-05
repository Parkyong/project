//
//  NSString+Matcher.m
//  EnNew
//
//  Created by lizhao on 16/6/6.
//  Copyright © 2016年 EnNew. All rights reserved.
//

#import "NSString+Matcher.h"

@implementation NSString (Matcher)

- (NSArray *)matchWithRegex:(NSString *)regex {
    NSTextCheckingResult *result = [self firstMatchedResultWithRegex:regex];
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:[result numberOfRanges]];
    for (NSInteger i = 0; i < [result numberOfRanges]; i++) {
        [mArray addObject:[self substringWithRange:[result rangeAtIndex:i]]];
    }
    return mArray;
}

- (NSString *)matchWithRegex:(NSString *)regex atIndex:(NSUInteger)index {
    NSTextCheckingResult *result = [self firstMatchedResultWithRegex:regex];
    return [self substringWithRange:[result rangeAtIndex:index]];
}

- (NSString *)firstMatchedGroupWithRegex:(NSString *)regex {
    NSTextCheckingResult *result = [self firstMatchedResultWithRegex:regex];
    return [self substringWithRange:[result rangeAtIndex:1]];
}

- (NSTextCheckingResult *)firstMatchedResultWithRegex:(NSString *)regex {
    NSRegularExpression *regexExpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSRange range = {0, self.length};
    return [regexExpression firstMatchInString:self options:NSMatchingReportProgress range:range];
}

@end