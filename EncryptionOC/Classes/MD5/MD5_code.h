//
//  MD5_code.h
//  EncryptionOC
//
//  Created by 李孔文 on 2018/4/9.
//  Copyright © 2018年 李孔文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface MD5_code : NSObject
+(NSString*)md5:(NSString*) str;
+(NSString *)file_md5:(NSString*) path;
@end
