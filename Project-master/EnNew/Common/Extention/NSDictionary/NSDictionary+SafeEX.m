//
//  NSDictionary+SafeEX.m
//  XinzhiNet
//
//  Created by yangyi on 16/1/6.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "NSDictionary+SafeEX.h"

@implementation NSDictionary (SafeEX)

- (id)safeValueForKey:(NSString *)key{
    return [self objectForKeyCheck:key];
}

- (id)safeObjectForKey:(NSString *)key{
    return [self objectForKeyCheck:key];
}

- (id)objectForKeyCheck:(id)aKey
{
    if (aKey == nil) {
        return nil;
    }
    
    id value = [self objectForKey:aKey];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if ([self isKindOfClass:[NSMutableDictionary class]] && nil != aKey && nil != anObject) {
        [(NSMutableDictionary *)self setObject:anObject forKey:aKey];
    }
}

- (void)safeSetValue:(id)value forKey:(NSString *)key
{
    if (key && [key isKindOfClass:[NSString class]]) {
        [self setValue:value forKey:key];
    }
}

/**
 *  删除空字符串
 *
 */
- (NSDictionary *)replaceNullkey
{
    
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in self.allKeys) {
        
        if ([[self objectForKey:keyStr] isEqual:[NSNull null]]) {
            
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
            
            [mutableDic setObject:[self objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}
@end
