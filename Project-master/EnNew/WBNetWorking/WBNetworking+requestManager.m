//
//  WBNetworking+requestManager.m
//  WBNetworking
//
//  Created by 蔡欣东 on 2016/8/9.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "WBNetworking+requestManager.h"
#import "NSURLRequest+decide.h"

@implementation WBNetworking (requestManager)

+ (BOOL)haveSameRequestInTasksPool:(WBURLSessionTask *)task {
    __block BOOL isSame = NO;
    [[self currentRunningTasks] enumerateObjectsUsingBlock:^(WBURLSessionTask *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([task.originalRequest isTheSameRequest:obj.originalRequest]) {
            isSame  = YES;
            *stop = YES;
        }
    }];
    return isSame;
}

+ (WBURLSessionTask *)cancleSameRequestInTasksPool:(WBURLSessionTask *)task {
    __block WBURLSessionTask *oldTask = nil;
    
    [[self currentRunningTasks] enumerateObjectsUsingBlock:^(WBURLSessionTask *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([task.originalRequest isTheSameRequest:obj.originalRequest]) {
            if (obj.state == NSURLSessionTaskStateRunning) {
                [obj cancel];
                oldTask = obj;
            }
            *stop = YES;
        }
    }];
    
    return oldTask;
}

@end
