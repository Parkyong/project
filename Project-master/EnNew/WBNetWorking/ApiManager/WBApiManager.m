//
//  WBApiManager.m
//  WBNetWork
//
//  Created by Haisheng Liang on 16/8/19.
//  Copyright © 2016年 Haisheng Liang. All rights reserved.
//

#import "WBApiManager.h"
#import "WBNetworking.h"
#import "WBBaseModel.h"
#import "NSString+encrypt.h"
#import "PushManager.h"
#import "EnnTipsManager.h"
//#import "EJUserCenterManager.h"
//#import "EJChangeTicket.h"

static NSString *kBaseApiURL = @"http://api.woodbunny.com";

static NSString *apiErrorCodeKeyPath;
static NSString *apiErrorMessageKeyPath;
static NSString *apiContentCodeKeyPath;

extern NSString * const AFNetworkingOperationFailingURLResponseErrorKey;

@interface WBApiManager()
@property (nonatomic, assign, getter=isDebug) BOOL debug;
@end

@implementation WBApiManager

+ (instancetype)sharedManager {
    static WBApiManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
        _sharedManager.debug = YES;
    });
    return _sharedManager;
}

+ (void)checkNetworkStatus{
    [WBNetworking checkNetworkStatus];
}

+ (void)setBaseApiUrl:(NSString*)url{
    kBaseApiURL = url;
}

+ (NSString *)baseApiUrl{
    return kBaseApiURL;
}

+ (void)setErrorKeyPath:(NSString*)key{
    apiErrorCodeKeyPath = key;
}

+ (void)setErrorMessageKeyPath:(NSString*)key{
    apiErrorMessageKeyPath = key;
}

+ (void)setContentKeyPath:(NSString*)key{
    apiContentCodeKeyPath = key;
}

- (void)dataTaskWithModel:(WBBaseModel*)model
            progressBlock:(WBPostProgress)progressBlock
             successBlock:(WBResponseSuccessBlock)succes
                failBlock:(WBResponseFailBlock)failBlock{
    
    NSString *host = kBaseApiURL;
    NSString *customHost = [model customHost];
    //验证自定义地址格式是否正确
    if (customHost && [self validateUrlFromString:customHost]) {
        host = customHost;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",host,[model pathPattern]?:@""];
    if(self.isDebug) NSLog(@"url => %@", url);
    
    NSDictionary *parameters = model.needEncrypt ? [self encryptParameters:[model parameters]] : [model parameters];
    if(self.isDebug) NSLog(@"parameters => %@", [WBApiManager stringWithDictionary:parameters]);
    
    [self dataTaskWithHTTPMethod:[model method] postWithUrl:url refreshRequest:model.needRefresh cache:model.useCache params:parameters progressBlock:progressBlock successBlock:^(NSURLSessionTask *task, id response, BOOL isFromCache) {
        if(self.isDebug) NSLog(@"respone -> %@",response);
        
        if ( ![response isKindOfClass:[NSDictionary class]] ) {
            NSError *error = [NSError errorWithDomain:@"com.woodbunny.WBNetworking.ErrorDomain" code:991 userInfo:@{ NSLocalizedDescriptionKey:@"response is not a NSDictionary."}];
            WBApiError *apiError = [self errorHandler:task error:error];
            failBlock(task, apiError);
            return;
        }
        
        if( (apiErrorCodeKeyPath && ([[response safeValueForKey:apiErrorCodeKeyPath] intValue] != 0)) || [[response safeValueForKey:@"successful"] boolValue] == NO ){
            
            NSInteger errCode = [[response safeObjectForKey:apiErrorCodeKeyPath] integerValue];
            
            NSString *errMsg = @"";
            if (apiErrorMessageKeyPath){
                errMsg = [NSString stringWithFormat:@"%@",[response safeObjectForKey:apiErrorMessageKeyPath]];
            }
            NSError *error = [NSError errorWithDomain:@"com.woodbunny.WBNetworking.ErrorDomain" code:errCode userInfo:@{@"errMsg":errMsg?:@""}];
            failBlock(task, [self errorHandler:task error:error]);
            return;
        }
        
        id content = apiContentCodeKeyPath ? [response objectForKey:apiContentCodeKeyPath] : response;
        
//        if (!content) {
//            NSError *error = [NSError errorWithDomain:@"com.woodbunny.WBNetworking.ErrorDomain" code:992 userInfo:nil];
//            failBlock(task, [self errorHandler:task error:error]);
//            return;
//        }
        
        if ([model.reformer respondsToSelector:@selector(reformDataWithModel:data:)]) {
            succes(task, [model.reformer reformDataWithModel:model data:content], isFromCache);
        }else{
            succes(task, response, isFromCache);
        }
    } failBlock:^(NSURLSessionTask *task, NSError *error) {
        if(self.isDebug) NSLog(@"respone -> %@", task.response);
        WBApiError *apiError = [self errorHandler:task error:error];
        if (apiError.errCode == 630) {
//            EJChangeTicket *ticketModel = [[EJChangeTicket alloc] init];
//            ticketModel.accessToken = [EJUserCenterManager sharedManager].accessToken;
//            ticketModel.success = ^(EJLoginResponse *data){
//                //换票&&更新session
//                [[EJUserCenterManager sharedManager] setSessionId:data.sessionId accessToken:data.accessToken];
//                //请求重发
//                [self dataTaskWithModel:model progressBlock:progressBlock successBlock:succes failBlock:failBlock];
//            };
//            ticketModel.failtrue = ^(WBApiError *error){
//                failBlock(task, apiError);
//            };
//            [ticketModel loadData:LoadDataOption];
//            return;
        }
        failBlock(task, [self errorHandler:task error:error]);
    }];
}

- (void)uploadTaskWithModel:(WBBaseModel*)model
            progressBlock:(WBPostProgress)progressBlock
             successBlock:(WBResponseSuccessBlock)succes
                failBlock:(WBResponseFailBlock)failBlock{
    
    NSString *host = kBaseApiURL;
    NSString *customHost = [model customHost];
    //验证自定义地址格式是否正确
    if (customHost && [self validateUrlFromString:customHost]) {
        host = customHost;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",host,[model pathPattern]?:@""];
    if(self.isDebug) NSLog(@"url => %@", url);
    
    NSDictionary *parameters = [model parameters];
    if(self.isDebug) NSLog(@"parameters => %@", [WBApiManager stringWithDictionary:parameters]);
    
    NSData   *data     = [model uploadData];
    NSString *filename = [model fileName];
    NSString *fileType = [self mimeTypeFrom:data];
    [self uploadFileWithUrl:url fileData:data type:[fileType lastPathComponent] name:filename mimeType:fileType params:parameters progressBlock:progressBlock successBlock:^(NSURLSessionTask *task, id response, BOOL isFromCache) {
        if(self.isDebug) NSLog(@"respone -> %@",response);
        
        if ( ![response isKindOfClass:[NSDictionary class]] ) {
            NSError *error = [NSError errorWithDomain:@"com.woodbunny.WBNetworking.ErrorDomain" code:991 userInfo:@{ NSLocalizedDescriptionKey:@"response is not a NSDictionary."}];
            failBlock(nil, [self errorHandler:task error:error]);
            return;
        }
        
        if( (apiErrorCodeKeyPath && [[response safeObjectForKey:apiErrorCodeKeyPath] integerValue] != 0 ) || ![[response safeObjectForKey:@"successful"] boolValue]){
            
            NSInteger errCode = [[response safeObjectForKey:apiErrorCodeKeyPath] integerValue];
            
            NSString *errMsg = @"";
            if (apiErrorMessageKeyPath){
                errMsg = [NSString stringWithFormat:@"%@",[response safeObjectForKey:apiErrorMessageKeyPath]];
            }
            NSError *error = [NSError errorWithDomain:@"com.woodbunny.WBNetworking.ErrorDomain" code:errCode userInfo:@{@"errMsg":errMsg}];
            failBlock(task, [self errorHandler:task error:error]);
            return;
        }
        
        id content = apiContentCodeKeyPath ? [response safeObjectForKey:apiContentCodeKeyPath] : response;
        
//        if (!content) {
//            NSError *error = [NSError errorWithDomain:@"com.woodbunny.WBNetworking.ErrorDomain" code:992 userInfo:nil];
//            failBlock(task, [self errorHandler:task error:error]);
//            return;
//        }
        
        if ([model.reformer respondsToSelector:@selector(reformDataWithModel:data:)]) {
            succes(task, [model.reformer reformDataWithModel:model data:content], isFromCache);
        }else{
            succes(task, response, isFromCache);
        }
        
    } failBlock:^(NSURLSessionTask *task, NSError *error) {
        if(self.isDebug) NSLog(@"respone -> %@", task.response);
        failBlock(task, [self errorHandler:task error:error]);
    }];
    
}


- (WBApiError*)errorHandler:(NSURLSessionTask*)task error:(NSError*)error{
    
    NSInteger errCode = 0;
    NSString *errMsg;
    NSInteger statusCode;
    
    NSHTTPURLResponse *errorResponse = (NSHTTPURLResponse*)task.response;
    statusCode = errorResponse.statusCode;
    if (statusCode == 630) {
        errCode = statusCode;
        errMsg = @"登录已过期，为保障您的交易安全，请重新登录。";
        error = [[NSError alloc] initWithDomain:@"" code:630 userInfo:nil];
    }
    if (statusCode == 631) {
        errCode = statusCode;
        errMsg = @"您的账号已在其他设备上登录，如果非本人操作，请找回密码或者修改密码！";
        error = [[NSError alloc] initWithDomain:@"" code:630 userInfo:nil];
    }
    //if(statusCode == 630 || statusCode == 631){
    if(statusCode == 631){
//        //清除登录信息
//        [[EJUserCenterManager sharedManager] cleanUserInfo];
//        //如果当前是需要登录的页面跳转首页
//        BOOL needLogin = [PushManager viewControllerIsNeedLogin:NSStringFromClass([[PushManager currentViewController] class])];
//        if (needLogin) {
//            //弹出登录界面
//            [[PushManager shareManager] performSelector:@selector(presentLoginControllerWithSuccessBlock:) withObject:nil afterDelay:0.2];
//            //[[PushManager shareManager] pushHomeViewController];
//            [EJTipsManager showTipsMessage:errMsg stayTime:2 completion:nil];
//        }
//        
        return nil;
    }
    
    statusCode = error.code;
    if (statusCode == 991) {
        errCode = statusCode;
        errMsg = @"数据格式错误";
    }else{
        errCode = error.code;
        errMsg = error.userInfo[@"errMsg"]?:nil;
    }
    
    if (errCode == 0) {
        NSError *networkError = [error.userInfo safeValueForKey:@"NSUnderlyingError"];
        if(networkError) errCode = networkError.code;
    }
    
    WBApiError *apiError = [[WBApiError alloc] initWithError:error];
    apiError.errCode = errCode;
    apiError.errMessage = errMsg;
    return apiError;
}

- (void)cancelTaskWithModel:(WBBaseModel*)model{
    //如果是上传任务不取消
    if (model.uploadData) {
        return;
    }
    NSString *host = kBaseApiURL;
    NSString *customHost = [model customHost];
    //验证自定义地址格式是否正确
    if (customHost && [self validateUrlFromString:customHost]) {
        host = customHost;
    }
    NSString *url = [NSString stringWithFormat:@"%@/%@",host,[model pathPattern]?:@""];
    [WBNetworking cancelAllRequestWithURL:url];
}

- (BOOL)validateUrlFromString:(NSString*)string{
    if (!string) {
        return NO;
    }
    NSError *error = nil;
    NSString *pattern = @"http(s)?://[^\\s]*";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray<NSTextCheckingResult *> *result = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    if (result) {
        return YES;
    }
    return NO;
}

- (NSDictionary*)encryptParameters:(NSDictionary*)parameters{

    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *timeString = [dateFormatter stringFromDate:currentDate];
    
    NSData *parametersData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *parametersString = [[NSString alloc] initWithData:parametersData encoding:NSUTF8StringEncoding];
    
    NSString *crptyStr = [NSString encryptInfoWithSafeNum:timeString content:parametersString userId:nil];
    
    NSData *jsonData = [crptyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *cryptParameter = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        return nil;
    }
    
    return cryptParameter;
}

- (NSString *)mimeTypeFrom:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return @"application/octet-stream";
}

- (WBURLSessionTask*)dataTaskWithHTTPMethod:(NSString *)method
                                postWithUrl:(NSString *)url
                             refreshRequest:(BOOL)refresh
                                      cache:(BOOL)cache
                                     params:(NSDictionary *)params
                              progressBlock:(WBPostProgress)progressBlock
                               successBlock:(WBResponseSuccessBlock)successBlock
                                  failBlock:(WBResponseFailBlock)failBlock{
    WBURLSessionTask *task;
    if ([method isEqualToString:@"GET"]) {
        task = [WBNetworking getWithUrl:url refreshRequest:refresh cache:cache params:params progressBlock:progressBlock successBlock:successBlock failBlock:failBlock];
    }
    if ([method isEqualToString:@"POST"]) {
        task = [WBNetworking postWithUrl:url refreshRequest:refresh cache:cache params:params progressBlock:progressBlock successBlock:successBlock failBlock:failBlock];
    }
    return task;
}

- (WBURLSessionTask*)uploadFileWithUrl:(NSString *)url
                               fileData:(NSData *)data
                                   type:(NSString *)type
                                   name:(NSString *)name
                               mimeType:(NSString *)mimeType
                                 params:(NSDictionary *)params
                          progressBlock:(WBUploadProgressBlock)progressBlock
                           successBlock:(WBResponseSuccessBlock)successBlock
                              failBlock:(WBResponseFailBlock)failBlock{
    WBURLSessionTask *task;
    task = [WBNetworking uploadFileWithUrl:url fileData:data type:type name:name mimeType:mimeType params:params progressBlock:progressBlock successBlock:successBlock failBlock:failBlock];
    return task;
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return nil;
    }
    return dic;
}

+ (NSString*)stringWithDictionary:(NSDictionary*)dictionary{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end

@implementation WBApiError
- (instancetype)initWithError:(NSError*)error{
    self = [super initWithDomain:error.domain code:error.code userInfo:error.userInfo];
    if (self) {
        
    }
    return self;
}
@end
