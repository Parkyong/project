//
//  NSDictionary+SafeEX.h
//  XinzhiNet
//
//  Created by yangyi on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SafeEX)

- (id)safeValueForKey:(NSString *)key;

- (id)safeObjectForKey:(NSString *)key;

- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey;

- (void)safeSetValue:(id)value forKey:(NSString *)key;

/**
 *  替换字典的null
 *
 */
- (NSDictionary *)replaceNullkey;
@end
