//
//  HMac_code.h
//  EncryptionOC
//
//  Created by 李孔文 on 2018/4/9.
//  Copyright © 2018年 李孔文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
@interface HMac_code : NSObject
+  (NSString *)HMacHashWithKey:(NSString *)key data:(NSString *)data;
@end
