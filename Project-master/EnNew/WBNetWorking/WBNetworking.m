//
//  WBNetworking.m
//  WBNetworking
//
//  Created by Haisheng Liang on 16/8/19.
//  Copyright © 2016年 Haisheng Liang. All rights reserved.
//

#import "WBNetworking.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "WBNetworking+cache.h"
#import "WBNetworking+requestManager.h"
#import <CommonCrypto/CommonDigest.h>

#define WB_ERROR_IMFORMATION @"网络出现错误，请检查网络连接"

#define WB_ERROR [NSError errorWithDomain:@"com.woodbunny.WBNetworking.ErrorDomain" code:-999 userInfo:@{ NSLocalizedDescriptionKey:WB_ERROR_IMFORMATION}]

static NSMutableArray   *requestTasksPool;

static NSDictionary     *headers;

static WBNetworkStatus  networkStatus;

static NSTimeInterval   requestTimeout = 20.f;

static int CACHEMAXSIZE = 10485760;

@implementation WBNetworking

#pragma mark - manager

+ (AFHTTPSessionManager *)manager {
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.operationQueue.maxConcurrentOperationCount = 1;
    
    // 导入证书
    NSString *certFilePath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:certFilePath];
    NSSet *certSet = [NSSet setWithObject:certData];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey withPinnedCertificates:certSet];
    // 是否允许无效的证书 默认为NO
    securityPolicy.allowInvalidCertificates = YES;
    // 是否验证证书所属域名 默认为YES
    securityPolicy.validatesDomainName = NO;
    
    manager.securityPolicy = securityPolicy;
    
    //默认解析模式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval = requestTimeout;
    
    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    //配置请求序列化
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    manager.responseSerializer = serializer;
    
    //配置响应序列化
    NSSet *contentTypes = [NSSet setWithArray:@[@"application/json",
                                                @"text/html",
                                                @"text/json",
                                                @"text/plain",
                                                @"text/javascript",
                                                @"text/xml",
                                                @"image/*",
                                                @"application/octet-stream",
                                                @"application/zip"]];
    
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    
    //每次网络请求的时候，检查此时磁盘中的缓存大小，如果超过阈值，则清理所有缓存
    //未来优化点：1、这里到时会做进一步优化，到时会有两种清理策略，一种基于时间维度，一种基于缓存大小,
    //          2、清理也不会清理全部，会采取LRU算法来淘汰在磁盘中价值最低的缓存
    if ([self totalCacheSize] > CACHEMAXSIZE) [self clearTotalCache];
    
    return manager;
}

#pragma mark - 检查网络
+ (void)checkNetworkStatus {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus = WBNetworkStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusUnknown:
                networkStatus = WBNetworkStatusUnknown;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus = WBNetworkStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus = WBNetworkStatusReachableViaWiFi;
                break;
            default:
                networkStatus = WBNetworkStatusUnknown;
                break;
        }
        
    }];
}

+ (WBNetworkStatus)networkStatus{
    return networkStatus;
}

+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTasksPool == nil) requestTasksPool = [NSMutableArray array];
    });
    return requestTasksPool;
}

#pragma mark - get
+ (WBURLSessionTask *)getWithUrl:(NSString *)url
                  refreshRequest:(BOOL)refresh
                           cache:(BOOL)cache
                          params:(NSDictionary *)params
                   progressBlock:(WBGetProgress)progressBlock
                    successBlock:(WBResponseSuccessBlock)successBlock
                       failBlock:(WBResponseFailBlock)failBlock {
    
    //将session拷贝到堆中，block内部才可以获取得到session
    __block WBURLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self manager];
    
    if (networkStatus == WBNetworkStatusNotReachable) {
        if (failBlock) failBlock(session, WB_ERROR);
        return session;
    }
    
    id responseObj = [self getCacheResponseObjectWithRequestUrl:url params:params];
    
    if (responseObj && cache) {
        if (successBlock) successBlock(session, responseObj, YES);
    }
    
    session = [manager GET:url
                parameters:params
                  progress:^(NSProgress * _Nonnull downloadProgress) {
                      if (progressBlock) progressBlock(downloadProgress.completedUnitCount,
                                                       downloadProgress.totalUnitCount);
                      
                  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      if (successBlock) successBlock(task, responseObject, NO);
                      if (cache) [self cacheResponseObject:responseObject requestUrl:url params:params];
                      [[self allTasks] removeObject:task];
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      if ( ![error.domain isEqualToString:@"com.woodbunny.WBNetworking.ErrorDomain"] && error.code == -999 ) {
                          return;
                      }
                      if (failBlock) failBlock(task, error);
                      [[self allTasks] removeObject:task];
                  }];
    
    if (!refresh) {
        WBURLSessionTask *oldTask = [self cancleSameRequestInTasksPool:session];
        if (oldTask) {
            [[self allTasks] removeObject:oldTask];
        }
        return nil;
    }
    
    if (session){
        [[self allTasks] addObject:session];
        [session resume];
    }
    return session;
}

#pragma mark - post
+ (WBURLSessionTask *)postWithUrl:(NSString *)url
                   refreshRequest:(BOOL)refresh
                            cache:(BOOL)cache
                           params:(NSDictionary *)params
                    progressBlock:(WBPostProgress)progressBlock
                     successBlock:(WBResponseSuccessBlock)successBlock
                        failBlock:(WBResponseFailBlock)failBlock {
    __block WBURLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self manager];
    
    if (networkStatus == WBNetworkStatusNotReachable) {
        if (failBlock) failBlock(session, WB_ERROR);
        return session;
    }
    
    id responseObj = [self getCacheResponseObjectWithRequestUrl:url params:params];
    
    if (responseObj && cache) {
        if (successBlock) successBlock(session, responseObj, YES);
    }
    
    session = [manager POST:url
                 parameters:params
                   progress:^(NSProgress * _Nonnull uploadProgress) {
                       if (progressBlock) progressBlock(uploadProgress.completedUnitCount,
                                                        uploadProgress.totalUnitCount);
                       
                   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       if (successBlock) successBlock(task, responseObject, NO);
                       
                       if (cache) [self cacheResponseObject:responseObject requestUrl:url params:params];
                       
                       if ([[self allTasks] containsObject:session]) {
                           [[self allTasks] removeObject:session];
                       }
                       
                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       if ( ![error.domain isEqualToString:@"com.woodbunny.WBNetworking.ErrorDomain"] && error.code == -999 ) {
                           return;
                       }
                       if (failBlock) failBlock(task, error);
                       [[self allTasks] removeObject:session];
                       
                   }];
    
    
    if (!refresh) {
        WBURLSessionTask *oldTask = [self cancleSameRequestInTasksPool:session];
        if (oldTask) {
            [[self allTasks] removeObject:oldTask];
        }
        return nil;
    }
    
    if (session){
        [[self allTasks] addObject:session];
        [session resume];
    }
    return session;
}

#pragma mark - 文件上传
+ (WBURLSessionTask *)uploadFileWithUrl:(NSString *)url
                               fileData:(NSData *)data
                                   type:(NSString *)type
                                   name:(NSString *)name
                               mimeType:(NSString *)mimeType
                                 params:(NSDictionary *)params
                          progressBlock:(WBUploadProgressBlock)progressBlock
                           successBlock:(WBResponseSuccessBlock)successBlock
                              failBlock:(WBResponseFailBlock)failBlock {
    __block WBURLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self manager];
    
    if (networkStatus == WBNetworkStatusNotReachable) {
        if (failBlock) failBlock(session, WB_ERROR);
        return session;
    }
    
    session = [manager POST:url
                 parameters:params
    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *fileName = nil;

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";

        NSString *day = [formatter stringFromDate:[NSDate date]];

        fileName = [NSString stringWithFormat:@"%@.%@",day,type];

        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
      
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) progressBlock (uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
      
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) successBlock(task, responseObject, NO);
        [[self allTasks] removeObject:session];
      
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ( ![error.domain isEqualToString:@"com.woodbunny.WBNetworking.ErrorDomain"] && error.code == -999 ) {
            return;
        }
        if (failBlock) failBlock(task, error);
        [[self allTasks] removeObject:session];
      
    }];
    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
}

#pragma mark - 多文件上传
+ (NSArray *)uploadMultFileWithUrl:(NSString *)url
                         fileDatas:(NSArray *)datas
                              type:(NSString *)type
                              name:(NSString *)name
                          mimeType:(NSString *)mimeTypes
                            params:(NSDictionary *)params
                     progressBlock:(WBUploadProgressBlock)progressBlock
                      successBlock:(WBMultUploadSuccessBlock)successBlock
                         failBlock:(WBMultUploadFailBlock)failBlock {
    
    if (networkStatus == WBNetworkStatusNotReachable) {
        if (failBlock) failBlock(@[WB_ERROR]);
        return nil;
    }
    
    __block NSMutableArray *sessions = [NSMutableArray array];
    __block NSMutableArray *responses = [NSMutableArray array];
    __block NSMutableArray *failResponse = [NSMutableArray array];
    
    dispatch_group_t uploadGroup = dispatch_group_create();
    
    NSInteger count = datas.count;
    for (int i = 0; i < count; i++) {
        __block WBURLSessionTask *session = nil;
        
        dispatch_group_enter(uploadGroup);
        
        session = [self uploadFileWithUrl:url
                                 fileData:datas[i]
                                     type:type name:name
                                 mimeType:mimeTypes
                                   params:params
                            progressBlock:^(int64_t bytesWritten, int64_t totalBytes) {
                                if (progressBlock) progressBlock(bytesWritten,
                                                                 totalBytes);
                                
                            } successBlock:^(NSURLSessionTask *task, id response, BOOL isFromCache) {
                                [responses addObject:response];
                                
                                dispatch_group_leave(uploadGroup);
                                
                                [sessions removeObject:session];
                                
                            } failBlock:^(NSURLSessionTask *task, NSError *error) {
                                NSError *Error = [NSError errorWithDomain:url code:-999 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"第%d次上传失败",i],@"index":@(i)}];
                                
                                [failResponse addObject:Error];
                                
                                dispatch_group_leave(uploadGroup);
                                
                                [sessions removeObject:session];
                            }];
        
        [session resume];
        
        if (session) [sessions addObject:session];
    }
    
    [[self allTasks] addObjectsFromArray:sessions];
    
    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        if (responses.count > 0) {
            if (successBlock) {
                successBlock([responses copy]);
                if (sessions.count > 0) {
                    [[self allTasks] removeObjectsInArray:sessions];
                }
            }
        }
        
        if (failResponse.count > 0) {
            if (failBlock) {
                failBlock([failResponse copy]);
                if (sessions.count > 0) {
                    [[self allTasks] removeObjectsInArray:sessions];
                }
            }
        }
        
    });
    
    return [sessions copy];
}

#pragma mark - 下载
+ (WBURLSessionTask *)downloadWithUrl:(NSString *)url
                        progressBlock:(WBDownloadProgress)progressBlock
                         successBlock:(WBDownloadSuccessBlock)successBlock
                            failBlock:(WBDownloadFailBlock)failBlock {
    NSString *type = nil;
    NSArray *subStringArr = nil;
    __block WBURLSessionTask *session = nil;
    
    NSURL *fileUrl = [self getDownloadDataFromCacheWithRequestUrl:url];
    
    if (fileUrl) {
        if (successBlock) successBlock(fileUrl);
        return session;
    }
    
    if (url) {
        subStringArr = [url componentsSeparatedByString:@"."];
        if (subStringArr.count > 0) {
            type = subStringArr[subStringArr.count - 1];
        }
    }
    
    AFHTTPSessionManager *manager = [self manager];
    //响应内容序列化为二进制
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session = [manager GET:url
                parameters:nil
                  progress:^(NSProgress * _Nonnull downloadProgress) {
                      if (progressBlock) progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
                      
                  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      if (successBlock) {
                          NSData *dataObj = (NSData *)responseObject;
                          
                          [self storeDownloadData:dataObj requestUrl:url];
                          
                          NSURL *downFileUrl = [self getDownloadDataFromCacheWithRequestUrl:url];
                          
                          successBlock(downFileUrl);
                      }
                      
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      if (failBlock) {
                          failBlock (task, error);
                      }
                  }];
    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
    
}

#pragma mark - other method


+ (NSArray *)currentRunningTasks {
    return [[self allTasks] copy];
}

+ (NSDictionary *)requestHeader{
    return headers;
}

+ (void)configHttpHeader:(NSDictionary *)httpHeader {
    headers = httpHeader;
}

+ (void)cancelOneRequestWithURL:(NSString *)url {
    if (!url) return;
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(WBURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[WBURLSessionTask class]]) {
                if ([obj.currentRequest.URL.absoluteString hasSuffix:url]) {
                    [obj cancel];
                    *stop = YES;
                }
            }
        }];
    }
}

+ (void)cancelAllRequestWithURL:(NSString *)url {
    if (!url) return;
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(WBURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[WBURLSessionTask class]]) {
                if ([obj.currentRequest.URL.absoluteString hasSuffix:url]) {
                    [obj cancel];
                }
            }
        }];
    }
}

+ (void)cancleAllRequest {
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(WBURLSessionTask  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[WBURLSessionTask class]]) {
                [obj cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    }
}

+ (void)setupTimeout:(NSTimeInterval)timeout {
    requestTimeout = timeout;
}

@end
