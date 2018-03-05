//
//  WBNetworking.h
//  WBNetworking
//
//  Created by Haisheng Liang on 16/8/19.
//  Copyright © 2016年 Haisheng Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  网络状态
 */
typedef NS_ENUM(NSInteger, WBNetworkStatus) {
    /**< 未知网络 */
    WBNetworkStatusUnknown             = 1 << 0,
    /**< 无法连接 */
    WBNetworkStatusNotReachable        = 1 << 1,
    /**< WWAN网络 */
    WBNetworkStatusReachableViaWWAN    = 1 << 2,
    /**< WiFi网络 */
    WBNetworkStatusReachableViaWiFi    = 1 << 3
};

/**
 *  请求任务
 */
typedef NSURLSessionTask WBURLSessionTask;

/**
 *  成功回调
 *
 *  @param response 成功后返回的数据
 */
typedef void(^WBResponseSuccessBlock)(NSURLSessionTask *task, id response, BOOL isFromCache);

/**
 *  失败回调
 *
 *  @param error 失败后返回的错误信息
 */
typedef void(^WBResponseFailBlock)(NSURLSessionTask *task, NSError *error);

/**
 *  下载进度
 *
 *  @param bytesWritten              已下载的大小
 *  @param totalBytes                总下载大小
 */
typedef void (^WBDownloadProgress)(int64_t bytesRead,
                                   int64_t totalBytes);

/**
 *  下载成功回调
 *
 *  @param url                       下载存放的路径
 */
typedef void(^WBDownloadSuccessBlock)(NSURL *url);


/**
 *  上传进度
 *
 *  @param bytesWritten              已上传的大小
 *  @param totalBytes                总上传大小
 */
typedef void(^WBUploadProgressBlock)(int64_t bytesWritten,
                                     int64_t totalBytes);
/**
 *  多文件上传成功回调
 *
 *  @param response 成功后返回的数据
 */
typedef void(^WBMultUploadSuccessBlock)(NSArray *responses);

/**
 *  多文件上传失败回调
 *
 *  @param error 失败后返回的错误信息
 */
typedef void(^WBMultUploadFailBlock)(NSArray *errors);

typedef WBDownloadProgress WBGetProgress;

typedef WBDownloadProgress WBPostProgress;

typedef WBResponseFailBlock WBDownloadFailBlock;

@interface WBNetworking : NSObject

/**
 *  检查网络状态
 */
+ (void)checkNetworkStatus;

/**
 *  网络状态
 *
 *  @return 返回当前状态
 */
+ (WBNetworkStatus)networkStatus;

/**
 *	设置超时时间
 *
 *  @param timeout 超时时间
 */
+ (void)setupTimeout:(NSTimeInterval)timeout;

/**
 *  配置请求头
 *
 *  @param httpHeader 请求头
 */
+ (void)configHttpHeader:(NSDictionary *)httpHeader;

/**
 *  获取请求头
 *
 *  @return httpHeader 请求头
 */
+ (NSDictionary *)requestHeader;

/**
 *  正在运行的网络任务
 *
 *  @return
 */
+ (NSArray *)currentRunningTasks;

/**
 *  取消单个请求
 */
+ (void)cancelOneRequestWithURL:(NSString *)url;

/**
 *  取消指定url的所有
 */
+ (void)cancelAllRequestWithURL:(NSString *)url;

/**
 *  取消所有请求
 */
+ (void)cancleAllRequest;

/**
 *  GET请求
 *
 *  @param url              请求路径
 *  @param cache            是否缓存
 *  @param refresh          是否刷新请求(遇到重复请求，若为YES，则会取消旧的请求，用新的请求，若为NO，则忽略新请   求，用旧请求)
 *  @param params           拼接参数
 *  @param progressBlock    进度回调
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 *
 *  @return 返回的对象中可取消请求
 */
+ (WBURLSessionTask *)getWithUrl:(NSString *)url
                  refreshRequest:(BOOL)refresh
                           cache:(BOOL)cache
                          params:(NSDictionary *)params
                   progressBlock:(WBGetProgress)progressBlock
                    successBlock:(WBResponseSuccessBlock)successBlock
                       failBlock:(WBResponseFailBlock)failBlock;




/**
 *  POST请求
 *
 *  @param url              请求路径
 *  @param cache            是否缓存
 *  @param refresh          解释同上
 *  @param params           拼接参数
 *  @param progressBlock    进度回调
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 *
 *  @return 返回的对象中可取消请求
 */
+ (WBURLSessionTask *)postWithUrl:(NSString *)url
                   refreshRequest:(BOOL)refresh
                            cache:(BOOL)cache
                           params:(NSDictionary *)params
                    progressBlock:(WBPostProgress)progressBlock
                     successBlock:(WBResponseSuccessBlock)successBlock
                        failBlock:(WBResponseFailBlock)failBlock;




/**
 *  文件上传
 *
 *  @param url              上传文件接口地址
 *  @param data             上传文件数据
 *  @param type             上传文件类型
 *  @param name             上传文件服务器文件夹名
 *  @param mimeType         mimeType
 *  @param progressBlock    上传文件路径
 *	@param successBlock     成功回调
 *	@param failBlock		失败回调
 *
 *  @return 返回的对象中可取消请求
 */
+ (WBURLSessionTask *)uploadFileWithUrl:(NSString *)url
                               fileData:(NSData *)data
                                   type:(NSString *)type
                                   name:(NSString *)name
                               mimeType:(NSString *)mimeType
                                 params:(NSDictionary *)params
                          progressBlock:(WBUploadProgressBlock)progressBlock
                           successBlock:(WBResponseSuccessBlock)successBlock
                              failBlock:(WBResponseFailBlock)failBlock;


/**
 *  多文件上传
 *
 *  @param url           上传文件地址
 *  @param datas         数据集合
 *  @param type          类型
 *  @param name          服务器文件夹名
 *  @param mimeType      mimeTypes
 *  @param progressBlock 上传进度
 *  @param successBlock  成功回调
 *  @param failBlock     失败回调
 *
 *  @return 任务集合
 */
+ (NSArray *)uploadMultFileWithUrl:(NSString *)url
                         fileDatas:(NSArray *)datas
                              type:(NSString *)type
                              name:(NSString *)name
                          mimeType:(NSString *)mimeTypes
                            params:(NSDictionary *)params
                     progressBlock:(WBUploadProgressBlock)progressBlock
                      successBlock:(WBMultUploadSuccessBlock)successBlock
                         failBlock:(WBMultUploadFailBlock)failBlock;

/**
 *  文件下载
 *
 *  @param url           下载文件接口地址
 *  @param progressBlock 下载进度
 *  @param successBlock  成功回调
 *  @param failBlock     下载回调
 *
 *  @return 返回的对象可取消请求
 */
+ (WBURLSessionTask *)downloadWithUrl:(NSString *)url
                        progressBlock:(WBDownloadProgress)progressBlock
                         successBlock:(WBDownloadSuccessBlock)successBlock
                            failBlock:(WBDownloadFailBlock)failBlock;

@end
