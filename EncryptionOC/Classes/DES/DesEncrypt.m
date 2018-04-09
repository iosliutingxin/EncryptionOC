//
//  Des.m
//  UZai5.2
//
//  Created by UZAI on 14-8-18.
//  Copyright (c) 2014年 xiaowen. All rights reserved.
//

#import "DesEncrypt.h"
#import <CommonCrypto/CommonCrypto.h>
#import "GTMBase64.h"

@implementation DesEncrypt
+(NSString*)DES:(NSString*)aPlainText encryptOrDecrypt:(CCOperation)aEncryptOrDecrypt key:(NSString*)aKey
{
	const void* vplainText;
    NSUInteger plainTextBufferSize;
	
	const char* key = [aKey UTF8String];
	size_t keySize = 8 < strlen(key) ? 8 : strlen(key);
	
	if (kCCDecrypt == aEncryptOrDecrypt)
	{
		NSData* encryptData = [GTMBase64 decodeData:[aPlainText dataUsingEncoding:NSUTF8StringEncoding]];
		plainTextBufferSize = [encryptData length];
		vplainText = [encryptData bytes];
	}
	else
	{
		NSData* data = [aPlainText dataUsingEncoding:NSUTF8StringEncoding];
		plainTextBufferSize = [data length];
		vplainText = [data bytes];
	}
	
	NSString* result = nil;
	if (kCCDecrypt == aEncryptOrDecrypt)
	{
		char* decryptText = (char*)malloc(plainTextBufferSize + 1);
		memset(decryptText, 0x00, plainTextBufferSize + 1);
		
		size_t decryptedDataLength = 0;
		CCCryptorStatus status = CCCrypt(kCCDecrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding | kCCOptionECBMode,
										 key, keySize,
										 NULL,
										 vplainText, plainTextBufferSize,
										 decryptText, plainTextBufferSize,
										 &decryptedDataLength);
		
		if (kCCSuccess == status) {
			result = [[NSString alloc] initWithData:[NSData dataWithBytes:decryptText
                                                                   length:decryptedDataLength]
                                           encoding:NSUTF8StringEncoding];
		}
		
		free(decryptText);
	}
	else
	{
		size_t encryptedBufferSize = 0;
		if (0 != plainTextBufferSize % 8) {
			encryptedBufferSize = ((plainTextBufferSize + 8) >> 3) << 3;
		}
		
		char* encryptText = (char*)malloc(encryptedBufferSize + 1);
		memset(encryptText, 0x00, encryptedBufferSize + 1);
		
		size_t encryptedDataLength = 0;
		CCCryptorStatus status = CCCrypt(kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding | kCCOptionECBMode,
										 key, keySize,
										 NULL,
										 vplainText, plainTextBufferSize,
										 encryptText, encryptedBufferSize,
										 &encryptedDataLength);
		
		if (kCCSuccess == status) {
			NSData* encryptedData = [NSData dataWithBytes:encryptText length:encryptedDataLength];
			result = [GTMBase64 stringByEncodingData:encryptedData];
		}
		
		free(encryptText);
	}
	
	return result;
}


+(NSString *)HexStringOfData:(NSString *)data encryptedWithKey:(NSString *)key usePadding:(BOOL)usePadding
{
	NSString *hexString = nil;
	
	if (nil != data && nil != key) {
		const char *dataBuffer = [data UTF8String];
		size_t dataSize = strlen(dataBuffer);
		
		const char* keyBuffer = [key UTF8String];
		size_t keySize = 8 < strlen(keyBuffer) ? 8 : strlen(keyBuffer);
		
		size_t cryptedBufferSize = dataSize;
		if (0 != dataSize % 8) {
			cryptedBufferSize = ((dataSize + 8) >> 3) << 3;
		}
		
		size_t encryptDataSize = dataSize;
		BOOL needPadding = NO;
		if (YES == usePadding) {
			if (cryptedBufferSize != dataSize) {
				needPadding = YES;
			}
		} else {
			encryptDataSize = cryptedBufferSize;
		}
		
		char *encryptBuffer = (char *)malloc(encryptDataSize);
		memset(encryptBuffer, 0x00, encryptDataSize);
		memcpy(encryptBuffer, dataBuffer, dataSize);
		
		char *cryptedDataBuffer = (char*)malloc(cryptedBufferSize);
		memset(cryptedDataBuffer, 0x00, cryptedBufferSize);
		
		size_t cryptedDataSize = 0;
        CCCryptorStatus status = CCCrypt(kCCEncrypt,
                                         kCCAlgorithmDES,
                                         YES == needPadding ? (kCCOptionECBMode | kCCOptionPKCS7Padding) : kCCOptionECBMode,
                                         keyBuffer,
                                         keySize,
                                         NULL,
                                         encryptBuffer,
                                         encryptDataSize,
                                         cryptedDataBuffer,
                                         cryptedBufferSize,
                                         &cryptedDataSize);
        
		if (status == kCCSuccess) {
			
			size_t encodeBufferSize = cryptedDataSize * 2;
			char *encodeBuffer = (char*)malloc(encodeBufferSize + 1);
			memset(encodeBuffer, 0x00, encodeBufferSize + 1);
			
			char* p = encodeBuffer;
			for (int i=0; i<cryptedDataSize; i++) {
				char byte = cryptedDataBuffer[i];
				
				sprintf(p, "%02X", (unsigned char)byte);
				p += 2;
			}
            
			hexString = [[NSString alloc] initWithData:[NSData dataWithBytes:encodeBuffer length:encodeBufferSize]
                                              encoding:NSASCIIStringEncoding];
			
            free(encodeBuffer);
		}
        
        free(encryptBuffer);
        free(cryptedDataBuffer);
	}
	
	return hexString;
}


+(NSString*)DataOfHexString:(NSString*)hexString decryptedWithKey:(NSString*)key {
	NSString* dataString = nil;
	
	if (nil != hexString && nil != key) {
		const char* hexStringBuffer = [hexString cStringUsingEncoding:NSASCIIStringEncoding];
		size_t hexStringSize = strlen(hexStringBuffer);
		
		const char* keyBuffer = [key UTF8String];
		size_t keySize = 8 < strlen(keyBuffer) ? 8 : strlen(keyBuffer);
		
		size_t decodeBufferSize = hexStringSize / 2;
		char* decodeBuffer = (char*)malloc(decodeBufferSize + 1);
		memset(decodeBuffer, 0x00, decodeBufferSize + 1);
		
		const char* p = hexStringBuffer;
		for (int i=0; i<decodeBufferSize; i++) {
			unsigned int byte = 0;
			sscanf(p, "%02X", &byte);
			decodeBuffer[i] = (unsigned char)byte;
			
			p += 2;
		}
		
		size_t decryptBufferSize = decodeBufferSize;
		char* decryptBuffer = (char*)malloc(decryptBufferSize + 1);
		memset(decryptBuffer, 0x00, decryptBufferSize + 1);
		
		size_t decryptedDataSize = 0;
		if (kCCSuccess == CCCrypt(kCCDecrypt, kCCAlgorithmDES, kCCOptionECBMode,
								  keyBuffer, keySize,
								  NULL,
								  decodeBuffer, decodeBufferSize,
								  decryptBuffer, decryptBufferSize,
								  &decryptedDataSize)) {
			dataString = [[NSString alloc] initWithData:[NSData dataWithBytes:decryptBuffer length:decryptedDataSize]
                                               encoding:NSUTF8StringEncoding];
		}
		
		free(decryptBuffer);
		free(decodeBuffer);
	}
	
	return dataString;
}

+ (NSString *)tripleDESDataToString:(NSData *)plainData operation:(CCOperation)op key:(NSString *)key {
    if (!plainData || plainData.length == 0) {
        return @"";
    }
    
    const void* vplainText;
    size_t plainTextBufferSize;
    
    if (op == kCCDecrypt) {
        plainData = [GTMBase64 decodeData:plainData];
    }
    plainTextBufferSize = plainData.length;
    vplainText = (const void *)plainData.bytes;
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    
    CCCrypt(op,
            kCCAlgorithmDES,
            kCCOptionPKCS7Padding,
            vkey,
            kCCKeySizeDES,
            vkey,
            vplainText,
            plainTextBufferSize,
            (void *)bufferPtr,
            bufferPtrSize,
            &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    free(bufferPtr);
    
    NSString *result;
    
    if (op == kCCDecrypt) {
        result = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    }
    else {
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
}

+ (NSData *)tripleDESStringToData:(NSString *)plainText operation:(CCOperation)op key:(NSString *)key {
    
    if (!plainText || [plainText length] == 0) {
        return [NSData data];
    }
    
    const void* vplainText;
    size_t plainTextBufferSize;
    
    if (op == kCCDecrypt) {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else {
        NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    
    CCCrypt(op,
            kCCAlgorithmDES,
            kCCOptionPKCS7Padding,
            vkey,
            kCCKeySizeDES,
            vkey,
            vplainText,
            plainTextBufferSize,
            (void *)bufferPtr,
            bufferPtrSize,
            &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    free(bufferPtr);
    
    NSString *result;
    
    if (op == kCCDecrypt) {
        result = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    }
    else {
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return [result dataUsingEncoding:NSUTF8StringEncoding];
}

+(NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key
{
    NSData *data = [self tripleDESStringToData:plainText operation:encryptOrDecrypt key:key];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
//MD5加密
+ (NSString *)md5:(NSString *)input
{
  const char *cStr = [input UTF8String];
  unsigned char digest[16];
  CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
  
  NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
  
  for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];
  
  return  output;
}
@end
