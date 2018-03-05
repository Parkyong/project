//
//  WBNetworking+cache.m
//  WBNetworking
//
//  Created by 蔡欣东 on 2016/7/25.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "WBNetworking+cache.h"
#import "WBNetworkCache.h"
#import <CommonCrypto/CommonDigest.h>

#define WB_NSUSERDEFAULT_GETTER(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define WB_NSUSERDEFAULT_SETTER(value, key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];[[NSUserDefaults standardUserDefaults] synchronize]

@implementation WBNetworking (cache)

#pragma mark - cache
+ (void)cacheResponseObject:(id)responseObject
                 requestUrl:(NSString *)requestUrl
                     params:(NSDictionary *)params {
    assert(responseObject);
    
    assert(requestUrl);
    
    if (!params) params = @{};
    NSString *originString = [NSString stringWithFormat:@"%@+%@",requestUrl,params];
    NSString *hash = [self md5:originString];
    
    NSData *data = nil;
    NSError *error = nil;
    if ([responseObject isKindOfClass:[NSData class]]) {
        data = responseObject;
    }else if ([responseObject isKindOfClass:[NSDictionary class]]){
        data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
    }
    
    if (error == nil) {
        //缓存到内存中
        [WBNetworkCache saveResponseCache:responseObject forKey:hash];
    }
}

+ (id)getCacheResponseObjectWithRequestUrl:(NSString *)requestUrl
                                    params:(NSDictionary *)params {
    assert(requestUrl);
    
    id cacheData = nil;
    
    if (!params) params = @{};
    NSString *originString = [NSString stringWithFormat:@"%@+%@",requestUrl,params];
    NSString *hash = [self md5:originString];
    
    cacheData = [WBNetworkCache getResponseCacheForKey:hash];
    return cacheData;
}

+ (NSString*)getCacheDiretoryPath{
    return [WBNetworkCache getCacheDiretoryPath];
}

+ (unsigned long long)totalCacheSize {
    return [WBNetworkCache totalCacheSize];
}

+ (void)clearTotalCache {
    [WBNetworkCache clearTotalCache];
}

#pragma mark - download
+ (void)storeDownloadData:(NSData *)data
               requestUrl:(NSString *)requestUrl {
    
    assert(data);
    assert(requestUrl);
    
    NSString *fileName = nil;
    NSString *type = nil;
    NSArray *strArray = nil;
    
    strArray = [requestUrl componentsSeparatedByString:@"."];
    if (strArray.count > 0) {
        type = strArray[strArray.count - 1];
    }
    
    if (type) {
        fileName = [NSString stringWithFormat:@"%@.%@",[self md5:requestUrl],type];
    }else {
        fileName = [NSString stringWithFormat:@"%@",[self md5:requestUrl]];
    }
    
//    NSString *directoryPath = nil;
//    directoryPath = WB_NSUSERDEFAULT_GETTER(downloadDirKey);
//    if (!directoryPath) {
//        directoryPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"WBNetworking"] stringByAppendingPathComponent:@"download"];
//        
//        WB_NSUSERDEFAULT_SETTER(directoryPath, downloadDirKey);
//    }
//    
//    
//    [WBDistCache writeData:data toDir:directoryPath filename:fileName];
}

+ (NSURL *)getDownloadDataFromCacheWithRequestUrl:(NSString *)requestUrl {
    
    NSAssert(requestUrl, @"ReuqestUrl is nil!");

    NSString *fileName = nil;
    NSString *type = nil;
    NSArray *strArray = nil;
    NSURL *fileUrl = nil;
    

    strArray = [requestUrl componentsSeparatedByString:@"."];
    if (strArray.count > 0) {
        type = strArray[strArray.count - 1];
    }
    
    if (type) {
        fileName = [NSString stringWithFormat:@"%@.%@",[self md5:requestUrl],type];
    }else {
        fileName = [NSString stringWithFormat:@"%@",[self md5:requestUrl]];
    }
    
    
//    NSString *directoryPath = WB_NSUSERDEFAULT_GETTER(downloadDirKey);
//    NSData *data = nil;
//
//    if (directoryPath) data = [WBDistCache readDataFromDir:directoryPath filename:fileName];
//    
//    if (data) {
//        NSString *path = [directoryPath stringByAppendingPathComponent:fileName];
//        fileUrl = [NSURL fileURLWithPath:path];
//    }
    
    return fileUrl;
}

+ (unsigned long long)totalDownloadDataSize {
    return 0;
}

+ (void)clearDownloadData {

}

+ (NSString *)getDownDirectoryPath {
    return nil;
}

#pragma mark - 散列值
+ (NSString *)md5:(NSString *)string {
    if (string == nil || string.length == 0) {
        return nil;
    }

    unsigned char digest[CC_MD5_DIGEST_LENGTH],i;
    
    CC_MD5([string UTF8String],(int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding],digest);
    
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x",(int)(digest[i])];
    }
    
    return [ms copy];
}

@end
