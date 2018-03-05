//
//  NSDictionary+JSON.m
//  NetToolKit
//
//  Created by caiyangjieto on 15/6/1.
//  Copyright (c) 2015年 qinisky.com. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        return nil;
    }
    
    return dic;
}

@end
