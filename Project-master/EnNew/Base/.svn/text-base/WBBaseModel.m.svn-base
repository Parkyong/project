//
//  WBBaseModel.m
//  WBNetWork
//
//  Created by Haisheng Liang on 16/8/19.
//  Copyright © 2016年 Haisheng Liang. All rights reserved.
//

#import <CFNetwork/CFNetworkErrors.h>
#import <objc/runtime.h>
#import <MJExtension/MJExtension.h>

#import "WBBaseModel.h"
//#import "EJUserCenterManager.h"
#import "EnnTipsManager.h"

NSString *const WBBaseModelNetworkErrorNotification = @"WBBaseModelNetworkErrorNotification";

static NSLock*  dataLock = nil;
static NSString *pageKeyPath = @"pageNum";
static NSString *pageSizeKeyPath = @"pageSize";

/**
 * Model的状态
 */
typedef NS_OPTIONS(NSInteger, WBModelState) {
    WBModelStateError     = -1,
    WBModelStateReady     = 0,
    WBModelStateLoading   = 1,
    WBModelStateFinished  = 2
};

@interface WBBaseModel()<WBBaseModelDelegation,ReformerProtocol>

@property (nonatomic, strong, readwrite) id data;
@property (nonatomic, strong, readwrite) WBApiError *apiError;

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) DataSendOption option;
@property (nonatomic, assign) WBModelState state;
@property (nonatomic, assign, readwrite) BOOL hasMore;

@property (nonatomic, strong) id uploadData;
@property (nonatomic, copy) UploadProgressBlock progress;

@end

@implementation WBBaseModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.page = 1;
        self.pageSize = 10;
        self.hasMore = YES;
        self.state = WBModelStateReady;
        self.delegate = self;
        self.reformer = self;
    }
    return self;
}

- (void)dealloc{
    WBApiManager* manager  = [WBApiManager sharedManager];
    [manager cancelTaskWithModel:self];
}

- (NSUInteger)page{
    return _page > 0 ? _page : 1;
}

- (void)setPageKeyPath:(NSString*)key{
    pageKeyPath = key;
}

- (void)setPageSizeKeyPath:(NSString*)key{
    pageSizeKeyPath = key;
}

- (id)data{
    if (_data && ![_data isEqual:[NSNull null]]) {
        return _data;
    }
    return nil;
}

- (void)changeData:(id)item{
    @synchronized(self)
    {
        _data = item;
    }
}

#pragma mark - over write by child

- (NSUInteger)pageSize{
    return 10;
}

- (NSString *)version{
    return nil;
}

- (NSString*)customHost{
    return nil;
}

- (NSString*)pathPattern{
    return nil;
}

- (NSString*)method{
    return @"POST";
}

- (NSDictionary*)parameters{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if (propName) {
            NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            id propertyValue = [self valueForKey:propertyName] ?: nil;
            [dict setValue:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    
    if (self.option == LoadMoreDataOpion) {
        [dict setValue:@(self.page) forKey:pageKeyPath];
        [dict setValue:@(self.pageSize) forKey:pageSizeKeyPath];
    }
    if (self.option == RefreshDataOption) {
        self.page = 1;
        [dict setValue:@(self.page) forKey:pageKeyPath];
        [dict setValue:@(self.pageSize) forKey:pageSizeKeyPath];
    }
    if (self.version) {
        [dict setValue:self.version forKey:@"version"];
    }

    NSDictionary *headParameter = [self creatreqHeader];
    NSDictionary *finalParameter = [NSDictionary dictionaryWithObjectsAndKeys:headParameter,@"reqheader",dict,@"reqbody", nil];
    return finalParameter;
}

- (BOOL)needEncrypt{
    return NO;
}

- (NSString*)responseClassName{
    return nil;
}

- (BOOL)useTips{
    return NO;
}

- (BOOL)allowedEmptyContent{
    return YES;
}

- (NSString*)tipsLoadingText{
    return nil;
}

- (NSString*)tipsErrorText{
    return nil;
}

#pragma mark - privete method

- (NSMutableDictionary *)creatreqHeader
{
//    NSString *sessionId = [EJUserCenterManager sharedManager].sessionId;
    NSString *sessionId = @"";
    NSDate *currentDate = [NSDate date];//获取当前时间，日期f
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString *app_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    //[dict setValue:userId forKey:@"userid"];
    [dict setValue:@"" forKey:@"pageid"];
    [dict setValue:@""  forKey:@"controllid"];
    
    [dict setValue:sessionId forKey:@"sessionId"];
    [dict setValue:@"1" forKey:@"sourceSystemType"];
    [dict setValue:@"2" forKey:@"platformType"];
    [dict setValue:app_version  forKey:@"sv"];
    
    [dict setValue:@"" forKey:@"lon"];
    [dict setValue:@"" forKey:@"lat"];
    [dict setValue:@"" forKey:@"bid"];
    
    [dict setValue:@""  forKey:@"requestid"];
    [dict setValue:dateString forKey:@"request_Time"];
    
    return dict;
}

#pragma mark - config network

- (DataSendOption)dataOption{
    return self.option;
}

- (void)loadData:(DataSendOption)option{
    
    //config option
    if (_state == WBModelStateLoading) {
        return;
    }
    _state = WBModelStateLoading;
    _option = option;
    
    if ([self useTips]) {
        [EnnTipsManager showLoadingMessage:[self tipsLoadingText]];
    }
    //send data
    WBApiManager* manager  = [WBApiManager sharedManager];
    [manager dataTaskWithModel:self progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        if ([self.delegate respondsToSelector:@selector(modelUpdate:withProgress:)]) {
            float progress = bytesRead/totalBytes;
            [self.delegate modelUpdate:self withProgress:progress];
        }
    } successBlock:^(NSURLSessionTask *task, id response, BOOL isFromCache) {
        
        if ([self useTips]) {
            [EnnTipsManager hideMessage];
        }
        
        [self manageDataFrom:response isFromCache:isFromCache];
        
        if ([self.delegate respondsToSelector:@selector(modelUpdate:withNewData:fromCache:)]) {
            [self.delegate modelUpdate:self withNewData:response fromCache:isFromCache];
        }
        if (self.success) {
            self.success(self.data);
        }
        self.page = self.page + 1;
        self.apiError = nil;
        
        _state = WBModelStateFinished;
        
    } failBlock:^(NSURLSessionTask *task, NSError *error) {
        
        _state = WBModelStateError;
        
        if ([self useTips]) {
            [EnnTipsManager hideMessage];
            self.apiError = (WBApiError*)error;
            if (self.apiError) {
                NSString *errMsg;
                if (!self.apiError.errMessage || [self.apiError.errMessage isEqualToString:@""]) {
                    NSInteger errCode = (self.apiError.errCode == 0) ? self.apiError.code : self.apiError.errCode;
                    errMsg = [NSString stringWithFormat:@"网络错误(%@)",@(errCode)];
                }else{
                    errMsg = self.apiError.errMessage;
                }
                
                errMsg = [self tipsErrorText]?:errMsg;
                [EnnTipsManager showTipsMessage:errMsg];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:WBBaseModelNetworkErrorNotification object:self];
        
        if ([self.delegate respondsToSelector:@selector(modelUpdate:withError:)]) {
            [self.delegate modelUpdate:self withError:error];
        }
        if (self.failtrue){
            self.failtrue((WBApiError*)error);
        }
    }];
}

- (void)retry{
    [self loadData:self.dataOption];
}

- (void)manageDataFrom:(id)response isFromCache:(BOOL)cached{
    NSString *responseClassName = [self responseClassName];
    if (responseClassName) {
        if (_option == LoadMoreDataOpion) {
            if (cached) return;
            if ([response isKindOfClass:[NSArray class]]) {
                self.hasMore = [response count] >= [self pageSize] ? YES : NO;
                NSMutableArray *tempDataArray;
                if ([self.data isKindOfClass:[NSArray class]]) {
                    tempDataArray = [[NSMutableArray alloc] initWithArray:self.data];
                }else{
                    tempDataArray = [[NSMutableArray alloc] init];
                }
                [tempDataArray addObjectsFromArray:[NSClassFromString(responseClassName) mj_objectArrayWithKeyValuesArray:response]];
                [self changeData:[tempDataArray copy]];
            }else{
                self.hasMore = NO;
            }
        }else{
            if ([response isKindOfClass:[NSArray class]] && [response count] > 0) {
                NSMutableArray *tempDataArray = [[NSMutableArray alloc] init];
                [tempDataArray addObjectsFromArray:[NSClassFromString(responseClassName) mj_objectArrayWithKeyValuesArray:response]];
                [self changeData:[tempDataArray copy]];
            }else{
                [self changeData:[NSClassFromString(responseClassName) mj_objectWithKeyValues:response]];
            }
        }
    }
    else
    {
        if (_option == LoadMoreDataOpion) {
            if (cached) return;
            if ([response isKindOfClass:[NSArray class]] && [response count] > 0) {
                self.hasMore = [response count] >= [self pageSize] ? YES : NO;
                NSMutableArray *tempDataArray;
                if ([self.data isKindOfClass:[NSArray class]]) {
                    tempDataArray = [[NSMutableArray alloc] initWithArray:self.data];
                }else{
                    tempDataArray = [[NSMutableArray alloc] init];
                }
                [tempDataArray addObjectsFromArray:response];
                [self changeData:[tempDataArray copy]];
            }
        }else{
            [self changeData:response];
        }
    }
}

#pragma mark - WBBaseModelDelegation

- (void)modelUpdate:(WBBaseModel*)model withProgress:(float)progress{
    //NSLog(@"progress:%f",progress);
}

- (void)modelUpdate:(WBBaseModel*)model withNewData:(id)data fromCache:(BOOL)cache{
    //NSLog(@"success => %@:%@",NSStringFromClass([model class]), data);
}

- (void)modelUpdate:(WBBaseModel*)model withError:(NSError*)error{
    //NSLog(@"failtrue => %@:%@",NSStringFromClass([model class]), error);
}

#pragma mark - ReformerProtocol
- (id)reformDataWithModel:(WBBaseModel *)model data:(id)data{
    return data;
}


@end


@implementation WBBaseModel (WBBaseUploadModel)

- (NSString*)fileName{
    return @"file";
}

- (void)upload{
    //send data
    WBApiManager* manager  = [WBApiManager sharedManager];
    
    [manager uploadTaskWithModel:self progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        float progress = bytesRead/totalBytes;
        if ([self.delegate respondsToSelector:@selector(modelUpdate:withProgress:)]) {
            [self.delegate modelUpdate:self withProgress:progress];
        }
        if (self.progress) {
            self.progress(progress);
        }
    } successBlock:^(NSURLSessionTask *task, id response, BOOL isFromCache) {
        if ([self useTips]) {
            [EnnTipsManager hideMessage];
        }
        
        [self changeData:response];
        
        if ([self.delegate respondsToSelector:@selector(modelUpdate:withNewData:fromCache:)]) {
            [self.delegate modelUpdate:self withNewData:response fromCache:isFromCache];
        }
        
        if (self.success) {
            self.success(self.data);
        }
        
        self.apiError = nil;
        
    } failBlock:^(NSURLSessionTask *task, NSError *error) {
        if ([self useTips]) {
            [EnnTipsManager hideMessage];
            self.apiError = (WBApiError*)error;
            if (self.apiError) {
                NSString *errMsg;
                if (!self.apiError.errMessage || [self.apiError.errMessage isEqualToString:@""]) {
                    NSInteger errCode = (self.apiError.errCode == 0) ? self.apiError.code : self.apiError.errCode;
                    errMsg = [NSString stringWithFormat:@"网络错误(%@)",@(errCode)];
                }else{
                    errMsg = self.apiError.errMessage;
                }
                
                errMsg = [self tipsErrorText]?:errMsg;
                [EnnTipsManager showTipsMessage:errMsg];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:WBBaseModelNetworkErrorNotification object:self];
        
        if ([self.delegate respondsToSelector:@selector(modelUpdate:withError:)]) {
            [self.delegate modelUpdate:self withError:error];
        }
        
        if (self.failtrue){
            self.failtrue((WBApiError*)error);
        }
    }];
}

@end
