//
//  NSArray+SafeEX.h
//  XinzhiNet
//
//  Created by yangyi on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SafeEX)

- (id)safeObjectAtIndex:(NSUInteger)index;

- (void)safeAddObject:(id)anObject;

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index;

@end
