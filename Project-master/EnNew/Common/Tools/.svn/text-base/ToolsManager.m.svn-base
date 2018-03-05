//
//  ToolsManager.m
//  iOS的框架
//
//  Created by zhngyy on 16/7/1.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#import "ToolsManager.h"
#import "NEShakeGestureManager.h"

@implementation ToolsManager

#pragma mark - 颜色返回图片
+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
    
}

#pragma mark - 身份证*隐藏
+ (NSString *)hideIdNumCardNumber:(NSString *)idCarNum
{
    if(idCarNum.length<18||!idCarNum)
    {
        return nil;
    }
    NSString *startString = [idCarNum substringToIndex:3];
    NSString *endString = [idCarNum substringWithRange:NSMakeRange(idCarNum.length - 4, 4)];
    NSString *stringNum = [NSString stringWithFormat:@"%@***********%@", startString, endString];
    return stringNum;
}

#pragma mark - 银行卡后五位显示 *1551
+ (NSString *)showBankCardLastFiveNumber:(NSString *)bankCardNum
{
    if(bankCardNum.length<5||!bankCardNum)
    {
        return nil;
    }
    NSString *endFourString = [bankCardNum substringWithRange:NSMakeRange(bankCardNum.length - 4, 4)];
    NSString *decorateString = [NSString stringWithFormat:@"*%@",endFourString];
    return decorateString;
}

#pragma mark - 判断是不是手机号码
+(BOOL)isPhoneNumber:(NSString *)number
{
    NSString *phoneRegex1=@"1[34578]([0-9]){9}";
    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
    return  [phoneTest1 evaluateWithObject:number];
}

#pragma mark - 是否是身份证
+ (BOOL)validateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark - 是不是银行卡号
+(BOOL)isBankCard:(NSString *)cardNumber
{
    if(cardNumber.length==0)
    {
        return NO;
    }
    NSString *digitsOnly = [ToolsManager getDigitsOnly:cardNumber];
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
    {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo)
        {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}
//剔除卡号里的非法字符
+(NSString *)getDigitsOnly:(NSString*)s
{
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < s.length; i++)
    {
        c = [s characterAtIndex:i];
        if (isdigit(c))
        {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    return digitsOnly;
}

#pragma mark - 是否是邮箱
+ (BOOL)isValidateEmail:(NSString *)Email{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}

#pragma mark - 数组去重
+ (NSArray *)arrayWithMemberIsOnly:(NSArray *)array{
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [array count]; i++)
    {
        if ([categoryArray containsObject:[array safeObjectAtIndex:i]]==NO)
        {
            [categoryArray safeAddObject:[array safeObjectAtIndex:i]];
        }
    }
    return categoryArray;
}

@end
