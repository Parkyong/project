//
//  NSString+encrypt.m
//  EJZG
//
//  Created by Haisheng Liang on 16/9/1.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

//#import <CommonCrypto/CommonDigest.h>
//#import <CommonCrypto/CommonCryptor.h>

#import "NSString+encrypt.h"
#import "NSData+CommonCrypto.h"
#import "GTMBase64.h"
#import "GTMDefines.h"

@implementation NSString (encrypt)

#pragma mark -
#pragma mark - md5

/*
 * 32位md5加密方式
 */
+ (NSString*)md5_32:(NSString*)input
{
    const char *str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

/*
 * 16位md5加密方式
 */
+ (NSString*)md5_16:(NSString*)input
{
    const char *str = [input UTF8String];
    unsigned char result[16];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


#pragma mark -
#pragma mark - sha

/*
 * sha1加密方式
 */
+ (NSString*)sha1:(NSString*)input
{
    return ([self sha:input type:1]);
}

/*
 * sha256加密方式
 */
+ (NSString*)sha256:(NSString*)input
{
    return ([self sha:input type:256]);
}

/*
 * sha384加密方式
 */
+ (NSString*)sha384:(NSString*)input
{
    return ([self sha:input type:384]);
}

/*
 * sha512加密方式
 */
+ (NSString*)sha512:(NSString*)input
{
    return ([self sha:input type:512]);
}

/*
 * 通用sha加密方式
 */
+ (NSString*)sha:(NSString*)input type:(NSInteger)type
{
    const char *str = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *hashData = [NSData dataWithBytes:str length:input.length];
    
    uint8_t *digest;
    NSInteger length = 0;
    switch (type) {
        case 1: {
            length = CC_SHA1_DIGEST_LENGTH;
            digest = malloc(length * sizeof(uint8_t));
            CC_SHA1(hashData.bytes, (CC_LONG)hashData.length, digest);
        }
            break;
        case 256: {
            length = CC_SHA256_DIGEST_LENGTH;
            digest = malloc(length * sizeof(uint8_t));
            CC_SHA256(hashData.bytes, (CC_LONG)hashData.length, digest);
        }
            break;
        case 384: {
            length = CC_SHA384_DIGEST_LENGTH;
            digest = malloc(length * sizeof(uint8_t));
            CC_SHA384(hashData.bytes, (CC_LONG)hashData.length, digest);
        }
            break;
        case 512: {
            length = CC_SHA512_DIGEST_LENGTH;
            digest = malloc(length * sizeof(uint8_t));
            CC_SHA512(hashData.bytes, (CC_LONG)hashData.length, digest);
        }
            break;
        default:
            break;
    }
    
    if (NULL == digest || 0 == length) {
        return nil;
    }
    
    NSMutableString *result = [NSMutableString stringWithCapacity:length * 2];
    for(int i = 0; i < length; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    if (digest) {
        free(digest);
    }
    
    return result;
    
}


#pragma mark -
#pragma mark - aes

+ (NSString*)aesEncrypt:(NSString*)data key:(NSString*)key iv:(NSString*)iv
{
    NSData *aesData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aesKey = [[key dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash];
    
    //NSString* hexPwdString=[aesKey hexString];
    NSUInteger length = aesKey.length;
    NSMutableString *hexPwdString = [NSMutableString stringWithCapacity:length * 2];
    const unsigned char *byte = aesKey.bytes;
    for (int i = 0; i < length; i++, byte++) {
        [hexPwdString appendFormat:@"%02X", *byte];
    }
    NSLog(@"%@",hexPwdString);

#if 1
    NSData *result = [aesData AES256EncryptedDataUsingKey:aesKey error:nil];
#else
    NSData *aesIV = [iv dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [self aesEncryptWithData:aesData key:aesKey iv:aesIV];
#endif
    NSString *base64String = [[NSString alloc] initWithData:[GTMBase64 encodeData:result]
                                                   encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSData*)aesEncryptWithData:(NSData*)data key:(NSData*)key iv:(NSData*)iv
{
    unsigned char cKey[kCCKeySizeAES128];
    bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:kCCKeySizeAES128];
    
    char cIv[kCCBlockSizeAES128];
    bzero(cIv, kCCBlockSizeAES128);
    if (iv) {
        [iv getBytes:cIv length:kCCBlockSizeAES128];
    }
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    uint8_t *buffer = malloc(bufferSize *sizeof(uint8_t));
    memset((void*)buffer, 0, bufferSize);
    
    NSData *result = nil;
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          cKey,     // Key
                                          kCCKeySizeAES128,    // kCCKeySizeAES
                                          cIv,       // IV
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (kCCSuccess == cryptStatus) {
        result = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
    }
    
    if (buffer) {
        free(buffer);
    }
    
    return result;
}

+ (NSString*)aesDecrypt:(NSString*)data key:(NSString*)key iv:(NSString*)iv
{
    NSData *aesData = [GTMBase64 decodeData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *aesKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aesIV = [iv dataUsingEncoding:NSUTF8StringEncoding];
    
#if 1
    NSData *result = [aesData decryptedAES256DataUsingKey:aesKey andIV:aesIV error:nil];
#else
    NSData *result = [self aesDecryptWithData:aesData key:aesKey iv:aesIV];
#endif
    return ([[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
}

+ (NSData*)aesDecryptWithData:(NSData*)data key:(NSData*)key iv:(NSData*)iv
{
    unsigned char cKey[kCCKeySizeAES128];
    bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:kCCKeySizeAES128];
    
    char cIv[kCCBlockSizeAES128];
    bzero(cIv, kCCBlockSizeAES128);
    if (iv) {
        [iv getBytes:cIv length:kCCBlockSizeAES128];
    }
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    uint8_t *buffer = malloc(bufferSize *sizeof(uint8_t));
    memset((void*)buffer, 0, bufferSize);
    
    NSData *result = nil;
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [key bytes],     // Key
                                          [key length],    // kCCKeySizeAES
                                          [iv bytes],       // IV
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        result = [[NSData alloc] initWithBytes:buffer length:encryptedSize];
    }
    
    if (buffer) {
        free(buffer);
    }
    
    return result;
}


#pragma mark -
#pragma mark - rsa

+ (NSString*)rsaEncrypt:(NSString*)data key:(SecKeyRef)key
{
    NSData *rsaData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [self rsaEncryptWithData:rsaData key:key];
    return ([result base64EncodedStringWithOptions:0]);
}

+ (NSData*)rsaEncryptWithData:(NSData*)data key:(SecKeyRef)key
{
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    
    NSData *plainTextBytes = data;
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [NSMutableData dataWithCapacity:0];
    
    for (int i=0; i<blockCount; i++) {
        int bufferSize = (int)MIN(blockSize,[plainTextBytes length] - i * blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        
        OSStatus status = SecKeyEncrypt(key,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        
        if (status == noErr){
            NSData *encryptedBytes = [NSData dataWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
            
        }else{
            
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer) {
        free(cipherBuffer);
    }
    
    return encryptedData;
}

+ (NSString*)rsaDecrypt:(NSString*)data key:(SecKeyRef)key
{
    NSData *rsaData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [self rsaDecryptWithData:rsaData key:key];
    return ([[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
}

+ (NSData*)rsaDecryptWithData:(NSData*)data key:(SecKeyRef)key
{
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    size_t keyBufferSize = [data length];
    
    NSMutableData *bits = [NSMutableData dataWithLength:keyBufferSize];
    OSStatus sanityCheck = SecKeyDecrypt(key,
                                         kSecPaddingNone,
                                         (const uint8_t *) [data bytes],
                                         cipherBufferSize,
                                         [bits mutableBytes],
                                         &keyBufferSize);
    
    if (sanityCheck != 0) {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:sanityCheck userInfo:nil];
        NSLog(@"Error: %@", [error description]);
    }
    [bits setLength:keyBufferSize];
    
    return bits;
}


#pragma mark -
#pragma mark - 扫码部分加密

+ (SecKeyRef)genSecKeyRef:(NSString*)key {
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"ennew" ofType:@"der"];
    NSData *certificateData = [[NSData alloc]initWithContentsOfFile:publicKeyPath];
    
    //    NSData *data = [NSData dataWithBytes:[key UTF8String] length:key.length];
    CFDataRef dataRef = CFBridgingRetain(certificateData);
    SecCertificateRef certificate = SecCertificateCreateWithData(kCFAllocatorDefault, dataRef);
    SecPolicyRef policy =SecPolicyCreateBasicX509();
    
    SecTrustRef trust;
    SecTrustResultType trustResult;
    OSStatus status = SecTrustCreateWithCertificates(certificate, policy, &trust);
    if (status == noErr) {
        status = SecTrustEvaluate(trust, &trustResult);
    }
    
    SecKeyRef keyRef = SecTrustCopyPublicKey(trust);
    
    CFRelease(certificate);
    CFRelease(policy);
    CFRelease(trust);
    CFBridgingRelease(dataRef);
    
    return keyRef;
}

+ (NSString*)encryptInfoWithSafeNum:(NSString*)safeNum content:(NSString*)content userId:(NSString*)userId {
    // 随机16位key iv
    NSString *key = [self randomStr:16];//128加密为16位
    //    NSString *iv = [self randomStr:32];
    
    NSData *contentTextData = [[NSString stringWithFormat:@"%@##%@",content,safeNum] dataUsingEncoding:NSUTF8StringEncoding];
    
    //为了测试，这里先把密钥写死
    //    NSData *aesKey = [@"12345678901234561234567890123456" dataUsingEncoding:NSUTF8StringEncoding];
    //Byte keyByte[] = {0x08,0x08,0x04,0x0b,0x02,0x0f,0x0b,0x0c,0x01,0x03,0x09,0x07,0x0c,0x03,
    //  0x07,0x0a,0x04,0x0f,0x06,0x0f,0x0e,0x09,0x05,0x01,0x0a,0x0a,0x01,0x09,
    //0x06,0x07,0x09,0x0d};
    //byte转换为NSData类型，以便下边加密方法的调用
    //NSData *keyData = [[NSData alloc] initWithBytes:keyByte length:32];
    //
    
    
    //NSData *enContentTextData = [contentTextData AES256EncryptWithKey:[key dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *enContentTextData = [self AES128EncryptWithContent:contentTextData Key:[key dataUsingEncoding:NSUTF8StringEncoding]];
    
    // aes加密原数据 yyyyMMddHHmmss base64
    NSString *aesContent = [[NSString alloc] initWithData:[GTMBase64 encodeData:enContentTextData] encoding:NSUTF8StringEncoding];
    //[self aesEncrypt:[NSString stringWithFormat:@"%@##%@",content,@"20151212121212"] key:key iv:iv];
    
    // rsa加密key iv
    SecKeyRef keyRef = [self genSecKeyRef:@""];
    //base64
    NSString *rsaKey = [self rsaEncrypt:key key:keyRef];
    //    NSString *rsaIV = [self rsaEncrypt:iv key:keyRef];
    
    // userID safeNum content - md5
    NSString *signStr = [NSString stringWithFormat:@"%@%@", rsaKey, aesContent];
    NSString *md5Sign =  [self md5_16:signStr];
    
    
    
    // 拼接最终使用的串
    //    NSString *retStr = [NSString stringWithFormat:@"{\"encoderMethod\":\"AESNopadding\",\"data\":\"%@\",\"asyCryptMethod\":\"RSA\",\"keyInfo\":\"%@\",\"ivInfo\":\"%@\",\"signedInfo\":{\"signatureMethod\":\"NONE\",\"digestMethod\":\"MD5\"},\"signedValue\":\"%@\",\"fileSignedValue\":\"NONE\"}",aesContent, rsaKey, rsaIV,md5Sign];
    
    NSString *retStr = [NSString stringWithFormat:@"{\"encoderMethod\":\"AES\",\"data\":\"%@\",\"asyCryptMethod\":\"RSA\",\"keyInfo\":\"%@\",\"signedInfo\":{\"digestMethod\":\"MD5\"},\"signedValue\":\"%@\"}",aesContent, rsaKey,md5Sign];

    return retStr;
}

+ (NSString*)randomStr:(NSInteger)length
{
    NSString *letters = @"1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i=0; i<length; i++) {
        [randomString appendFormat: @"%c", [letters characterAtIndex: rand()%[letters length]]];
    }
    
    return randomString;
}

+ (NSString *)bytesToHexString:(Byte*)bytes length:(NSInteger)length{
    NSString *hexStr=@"";
    for(int i = 0; i < length; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if(1 == newHexStr.length) {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else {
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    return hexStr;
}

+ (NSString*)encryptForScanCodeWithData:(NSData*)data key:(NSData*)key iv:(NSData*)iv
{
    unsigned char cKey[kCCKeySizeAES128];
    bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:kCCKeySizeAES128];
    
    char cIv[kCCBlockSizeAES128];
    bzero(cIv, kCCBlockSizeAES128);
    if (iv) {
        [iv getBytes:cIv length:kCCBlockSizeAES128];
    }
    
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    uint8_t *buffer = malloc(bufferSize *sizeof(uint8_t));
    memset((void*)buffer, 0, bufferSize);
    
    NSString *hexStr=@"";
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          cKey,     // Key
                                          kCCKeySizeAES128,    // kCCKeySizeAES
                                          cIv,       // IV
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (kCCSuccess == cryptStatus) {
        hexStr = [self bytesToHexString:buffer length:encryptedSize];
    }
    
    if (buffer) {
        free(buffer);
    }
    
    return hexStr;
}

+ (NSString*)encryptForScanCode:(NSString*)data key:(NSString*)key iv:(NSString*)iv {
    NSData *aesData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aesKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aesIV = [iv dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *aesCode = [self encryptForScanCodeWithData:aesData key:aesKey iv:aesIV];
    return aesCode;
}

+ (NSData *)AES128EncryptWithContent:(NSData*)data Key:(NSData *)key   //加密
{
    
    //AES256加密，密钥应该是32位的
    //const void * keyPtr2 = [key bytes];
    //char (*keyPtr)[32] = keyPtr2;
    
    //对于块加密算法，输出大小总是等于或小于输入大小加上一个块的大小
    //所以在下边需要再加上一个块的大小
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding/*这里就是刚才说到的PKCS7Padding填充了*/ | kCCOptionECBMode,
                                          [key bytes], kCCKeySizeAES128,
                                          NULL,/* 初始化向量(可选) */
                                          [data bytes], dataLength,/*输入*/
                                          buffer, bufferSize,/* 输出 */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);//释放buffer
    return nil;
}

@end
