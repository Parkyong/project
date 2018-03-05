//
//  WBNetworkCache.h
//  WBNetWork
//
//  Created by Haisheng Liang on 16/8/19.
//  Copyright © 2016年 Haisheng Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBNetworkCache : NSObject

/**
 *  缓存网络数据
 *
 *  @param responseCache 服务器返回的数据
 *  @param key           缓存数据对应的key值,推荐填入请求的URL
 */
+ (void)saveResponseCache:(id)responseCache forKey:(NSString *)key;

/**
 *  取出缓存的数据
 *
 *  @param key 根据存入时候填入的key值来取出对应的数据
 *
 *  @return 缓存的数据
 */
+ (id)getResponseCacheForKey:(NSString *)key;

/**
 *  获取缓存地址(待实现)
 *
 *  @return 缓存路径
 */
+ (NSString *)getCacheDiretoryPath;

/**
 *  已缓存文件大小
 *
 *  @return 缓存文件大小
 */
+ (unsigned long long)totalCacheSize;

/**
 *  清除全部缓存数据
 */
+ (void)clearTotalCache;

@end
