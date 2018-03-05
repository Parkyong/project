//
//  WBApiManager.h
//  WBNetWork
//
//  Created by Haisheng Liang on 16/8/19.
//  Copyright © 2016年 Haisheng Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBApiFilterProtocol.h"
#import "WBNetworking.h"

@class WBBaseModel;

@interface WBApiManager : NSObject

@property (nonatomic, readonly) NSMutableArray <id<WBUrlFilterProtocol>>*urlFilterList;
@property (nonatomic, readonly) NSMutableArray <id<WBNetworkParameterFilterProtocol>>*parameterFilterList;
@property (nonatomic, readonly) NSMutableArray <id<WBNetworkResponseFilterProtocol>>*responseFilterList;

+ (instancetype)sharedManager;

/**
 *  检查网络
 */
+ (void)checkNetworkStatus;

/**
 *  设置BaseApiUrl
 *
 *  @param url apiurl
 */
+ (void)setBaseApiUrl:(NSString*)url;

+ (NSString *)baseApiUrl;

/**
 *  设定错误码key键值
 *
 *  @param key 错误码字段名
 */
+ (void)setErrorKeyPath:(NSString*)key;

/**
 *  设定错误信息key键值
 *
 *  @param key 错误信息字段名
 */
+ (void)setErrorMessageKeyPath:(NSString*)key;

/**
 *  接口内容key键值
 *
 *  @param key 接口内容字段名
 */
+ (void)setContentKeyPath:(NSString*)key;

/**
 *  发起网络请求
 *
 *  @param model     模型
 *  @param succes    成功回调
 *  @param failBlock 失败回调
 */
- (void)dataTaskWithModel:(WBBaseModel*)model
            progressBlock:(WBPostProgress)progressBlock
             successBlock:(WBResponseSuccessBlock)succes failBlock:(WBResponseFailBlock)failBlock;

- (void)uploadTaskWithModel:(WBBaseModel*)model
              progressBlock:(WBPostProgress)progressBlock
               successBlock:(WBResponseSuccessBlock)succes
                  failBlock:(WBResponseFailBlock)failBlock;

- (void)cancelTaskWithModel:(WBBaseModel*)model;



/**
 *  发起网络请求
 *
 *  @param method        请求类型
 *  @param url           请求地址
 *  @param refresh       是否强制刷新
 *  @param cache         是否使用缓存
 *  @param params        参数
 *  @param progressBlock 进度回调
 *  @param successBlock  成功回调
 *  @param failBlock     失败回调
 *
 *  @return WBURLSessionTask
 */
- (WBURLSessionTask *)dataTaskWithHTTPMethod:(NSString*)method
                                 postWithUrl:(NSString *)url
                              refreshRequest:(BOOL)refresh
                                       cache:(BOOL)cache
                                      params:(NSDictionary *)params
                               progressBlock:(WBPostProgress)progressBlock
                                successBlock:(WBResponseSuccessBlock)successBlock
                                   failBlock:(WBResponseFailBlock)failBlock;

@end

@interface WBApiError : NSError

@property (nonatomic, assign) NSInteger errCode;
@property (nonatomic, copy) NSString *errMessage;

- (instancetype)initWithError:(NSError*)error;

@end
