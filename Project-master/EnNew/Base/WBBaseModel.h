//
//  WBBaseModel.h
//  WBNetWork
//
//  Created by Haisheng Liang on 16/8/19.
//  Copyright © 2016年 Haisheng Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBApiManager.h"

FOUNDATION_EXTERN NSString *const WBBaseModelNetworkErrorNotification;

@class WBBaseModel;

@protocol WBBaseModelDelegation <NSObject>

@optional
- (void)modelUpdate:(WBBaseModel*)model withNewData:(id)data fromCache:(BOOL)cache;
- (void)modelUpdate:(WBBaseModel*)model withError:(NSError*)error;
- (void)modelUpdate:(WBBaseModel*)model withProgress:(float)progress;

@end

@protocol ReformerProtocol <NSObject>
- (id)reformDataWithModel:(WBBaseModel *)model data:(id)data;
@end

typedef NS_ENUM(NSInteger, DataSendOption) {
    LoadDataOption=0,
    LoadMoreDataOpion,
    RefreshDataOption,
};

typedef void(^SuccessBlock)(id data);
typedef void(^FailBlock)(WBApiError *error);
typedef void(^UploadProgressBlock)(float progress);

@interface WBBaseModel : NSObject

@property (nonatomic, readonly) id data;

@property (nonatomic, assign, readonly) BOOL hasMore;

@property (nonatomic, strong, readonly) WBApiError *apiError;
@property (nonatomic, weak  ) id<WBBaseModelDelegation> delegate;
@property (nonatomic, weak  ) id<ReformerProtocol> reformer;

@property (nonatomic, copy)   SuccessBlock success;
@property (nonatomic, copy)   FailBlock    failtrue;

@property (nonatomic, assign) BOOL needRefresh;
@property (nonatomic, assign) BOOL useCache;

/**
 *  设置翻页的Key
 *
 *  @param key 翻页的key(默认为page)
 */
- (void)setPageKeyPath:(NSString*)key;

/**
 *  设置翻页内容量的Key
 *
 *  @param key 页容量Key(默认为pageSize)
 */
- (void)setPageSizeKeyPath:(NSString*)key;

/**
 *  请求地址
 *
 *  @return 请求主机地址(默认为nil)
 */
- (NSString*)customHost;

/**
 *  请求路径
 *
 *  @return 请求路径(默认为nil)
 */
- (NSString*)pathPattern;

/**
 *  请求类型
 *
 *  @return 请求类型(默认为POST)
 */
- (NSString*)method;

/**
 *  接口的版本号
 *
 *  @return 返回版本号
 */
- (NSString *)version;

/**
 *  页码
 *
 *  @return 返回页码
 */
- (NSUInteger)page;

/**
 *  页面容量
 *
 *  @return 返回页面容量
 */
- (NSUInteger)pageSize;

/**
 *  请求参数
 *
 *  @return 请求参数字典
 */
- (NSDictionary*)parameters;

/**
 *  是否需要加密
 *
 *  @return 加密
 */
- (BOOL)needEncrypt;

/**
 *  response对应的模型名
 *
 *  @return 模型名
 */
- (NSString*)responseClassName;

/**
 *  网络提示
 *
 *  @return 是否使用
 */
- (BOOL)useTips;

/**
 *  允许空返回结果
 *
 *  @return 是否可空
 */
- (BOOL)allowedEmptyContent;

/**
 *  请求提示文字
 *
 *  @return 提示文字
 */
- (NSString*)tipsLoadingText;

/**
 *  错误提示文字
 *
 *  @return 提示文字
 */
- (NSString*)tipsErrorText;

/**
 *  请求数据类型
 *
 *  @return 返回请求数据类型
 */
- (DataSendOption)dataOption;

/**
 *  请求网络数据
 *
 *  @param option 数据类型
 */
- (void)loadData:(DataSendOption)option;

@end

@interface WBBaseModel (WBBaseUploadModel)

@property (nonatomic, strong) id uploadData;
@property (nonatomic, copy) UploadProgressBlock progress;

- (NSString*)fileName;

- (void)upload;

@end
