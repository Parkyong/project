//
//  WBNetworkCache.m
//  WBNetWork
//
//  Created by Haisheng Liang on 16/8/19.
//  Copyright © 2016年 Haisheng Liang. All rights reserved.
//

#import "WBNetworkCache.h"
#import <YYCache.h>

static NSString *const NetworkResponseCache = @"NetworkResponseCache";
static YYCache *_dataCache;

@implementation WBNetworkCache

+ (void)initialize
{
    _dataCache = [YYCache cacheWithName:NetworkResponseCache];
}

+ (void)saveResponseCache:(id)responseCache forKey:(NSString *)key
{
    //异步缓存,不会阻塞主线程
    [_dataCache setObject:responseCache forKey:key withBlock:nil];
}

+ (id)getResponseCacheForKey:(NSString *)key
{
    return [_dataCache objectForKey:key];
}

+ (NSString *)getCacheDiretoryPath{
    return nil;
}

+ (unsigned long long)totalCacheSize{
    return [_dataCache.diskCache totalCost];
}

+ (void)clearTotalCache{
    [_dataCache removeAllObjects];
}

@end
