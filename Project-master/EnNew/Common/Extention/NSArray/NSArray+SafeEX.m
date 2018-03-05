//
//  NSArray+SafeEX.m
//  XinzhiNet
//
//  Created by yangyi on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "NSArray+SafeEX.h"

@implementation NSArray (SafeEX)

- (void)safeAddObject:(id)anObject
{
    if ([self isKindOfClass:[NSMutableArray class]] && nil != anObject) {
        [(NSMutableArray *)self addObject:anObject];
    }
}

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if ([self isKindOfClass:[NSMutableArray class]] && index < self.count && nil != anObject) {
        [(NSMutableArray *)self insertObject:anObject atIndex:index];
    }
}

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (self && self.count > 0 && index < self.count) {
        id obj = [self objectAtIndex:index];
        if ([obj isKindOfClass:[NSNull class]]) {
            obj = nil;
        }
        return obj;
    }
    return nil;
}
@end
