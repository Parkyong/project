//
//  ToolsManager.h
//  iOS的框架
//
//  Created by zhngyy on 16/7/1.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ToolsManager : NSObject

/**
 *  通过纯色值的颜色返回一张纯色图片
 *
 *  @param color 纯颜色
 *
 *  @return 返回的图片
 */
+ (UIImage*) createImageWithColor: (UIColor*) color;

/**
 *  把银行卡的后面四位数显示出来其他都隐藏为*
 *
 *  @param bankCardNum 银行卡号
 *
 *  @return 返回隐藏的银行卡号
 */
+ (NSString *)showBankCardLastFiveNumber:(NSString *)bankCardNum;

/**
 *  隐藏身份证的中间区域只显示前四位后四位
 *
 *  @param idCarNum 身份证号
 *
 *  @return 返回处理过的身份证号
 */
+ (NSString *)hideIdNumCardNumber:(NSString *)idCarNum;

/**
 *  判断是不是手机号码
 *
 *  @param number 手机号
 *
 *  @return 返回结果YES 是，NO 不是
 */
+(BOOL)isPhoneNumber:(NSString *)number;

/**
 *  是否是身份证号
 *
 *  @param identityCard 身份证号
 *
 *  @return 返回的结果
 */
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

/**
 *  判断是否是银行卡号
 *
 *  @param cardNumber 银行卡号
 *
 *  @return 返回结果
 */
+(BOOL)isBankCard:(NSString *)cardNumber;

/**
 *  校验是否是邮箱
 *
 *  @param Email 邮箱号
 *
 *  @return 返回结果
 */
+ (BOOL)isValidateEmail:(NSString *)Email;

/**
 *  数组去重
 *
 *  @param array 去重数组
 *
 *  @return 返回的数组
 */
+ (NSArray *)arrayWithMemberIsOnly:(NSArray *)array;

@end
