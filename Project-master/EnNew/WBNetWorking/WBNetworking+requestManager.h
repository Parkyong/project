//
//  WBNetworking+requestManager.h
//  WBNetworking
//
//  Created by 蔡欣东 on 2016/8/9.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "WBNetworking.h"

@interface WBNetworking (requestManager)

/**
 *  判断网络请求池中是否有相同的请求
 *
 *  @param task 网络请求任务
 *
 *  @return
 */
+ (BOOL)haveSameRequestInTasksPool:(WBURLSessionTask *)task;

/**
 *  取消旧请求
 *
 *  @param task 新请求
 *
 *  @return 旧请求
 */
+ (WBURLSessionTask *)cancleSameRequestInTasksPool:(WBURLSessionTask *)task;

@end
