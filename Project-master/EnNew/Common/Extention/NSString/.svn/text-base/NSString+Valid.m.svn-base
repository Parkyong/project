/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "NSString+Valid.h"

@implementation NSString (Valid)

- (BOOL)isChinese{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isValidNickName {
    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isPhoneNumber{
    NSString *phoneRegex=@"1[3-9]([0-9]){9}";
    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF matches %@",phoneRegex];
    return  [phoneTest1 evaluateWithObject:self];
}

- (BOOL)isComplicatedPassword{
    //密码长度6-12位，包含至少1个数字、1个字母、特殊字符
    NSString *passwordRegex=@"(?=^.{6,12}$)(?=(?:.*?\\d){1})(?=(?:.*?[a-zA-Z]){1})(?!.*\\s)[0-9a-zA-Z!@#$%*()_+^&]*$";
    NSPredicate *passwordValid = [NSPredicate predicateWithFormat:@"SELF matches %@",passwordRegex];
    return  [passwordValid evaluateWithObject:self];
}

@end
