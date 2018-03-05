//
//  NSString+encrypt.h
//  EJZG
//
//  Created by Haisheng Liang on 16/9/1.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (encrypt)

+ (NSString*)md5_32:(NSString*)input;
+ (NSString*)md5_16:(NSString*)input;

+ (NSString*)sha1:(NSString*)input;
+ (NSString*)sha256:(NSString*)input;
+ (NSString*)sha384:(NSString*)input;
+ (NSString*)sha512:(NSString*)input;

+ (NSString*)aesEncrypt:(NSString*)data key:(NSString*)key iv:(NSString*)iv;
+ (NSString*)aesDecrypt:(NSString*)data key:(NSString*)key iv:(NSString*)iv;

+ (NSString*)rsaEncrypt:(NSString*)data key:(SecKeyRef)key;
+ (NSString*)rsaDecrypt:(NSString*)data key:(SecKeyRef)key;

+ (NSString*)encryptForScanCode:(NSString*)data key:(NSString*)key iv:(NSString*)iv;
+ (NSString*)encryptInfoWithSafeNum:(NSString*)safeNum content:(NSString*)content userId:(NSString*)userId;

@end
