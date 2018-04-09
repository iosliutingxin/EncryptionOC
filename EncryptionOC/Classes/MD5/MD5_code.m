//
//  MD5_code.m
//  EncryptionOC
//
//  Created by 李孔文 on 2018/4/9.
//  Copyright © 2018年 李孔文. All rights reserved.
//

#import "MD5_code.h"

@implementation MD5_code
+(NSString*)md5:(NSString*) str

{
    
    const char *cStr = [str UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), result );
    
    NSMutableString *hash = [NSMutableString string];
    
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
        
    {
        
        [hash appendFormat:@"%02X",result[i]];
        
    }
    
    return [hash lowercaseString];
    
}

//校验文件：

#define CHUNK_SIZE 1024

+(NSString *)file_md5:(NSString*) path

{
    
    NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    if(handle == nil)
        
        return nil;
    
    CC_MD5_CTX md5_ctx;
    
    CC_MD5_Init(&md5_ctx);
    
    NSData* filedata;
    
    do {
        
        filedata = [handle readDataOfLength:CHUNK_SIZE];
        
        CC_MD5_Update(&md5_ctx, [filedata bytes], [filedata length]);
        
    }
    
    while([filedata length]);
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_Final(result, &md5_ctx);
    
    [handle closeFile];
    
    NSMutableString *hash = [NSMutableString string];
    
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
        
    {
        
        [hash appendFormat:@"%02x",result[i]];
        
    }
    
    return [hash lowercaseString];
    
}

@end
