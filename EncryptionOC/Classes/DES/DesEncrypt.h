//
//  Des.h
//  UZai5.2
//
//  Created by UZAI on 14-8-18.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * kCCEncrypt = 0,
 kCCDecrypt,
 *
 */
@interface DesEncrypt : NSObject
+(NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(uint32_t)encryptOrDecrypt key:(NSString*)key;

/**
 *  字符串明文转成data密文
 *
 */
+ (NSData *)tripleDESStringToData:(NSString *) plainText
                        operation:(uint32_t) op
                              key:(NSString *) key;

/**
 *  data明文转成字符串密文
 *
 */
+ (NSString *)tripleDESDataToString:(NSData *) plainData
                          operation:(uint32_t) op
                                key:(NSString *) key;

+(NSString*)DES:(NSString*)aPlainText encryptOrDecrypt:(uint32_t)encryptOrDecrypt key:(NSString*)aKey;

+(NSString*)HexStringOfData:(NSString*)data encryptedWithKey:(NSString*)key usePadding:(BOOL)usePadding;

+(NSString*)DataOfHexString:(NSString*)hexString decryptedWithKey:(NSString*)key;


//MD5加密
+ (NSString *)md5:(NSString *)input;

@end
