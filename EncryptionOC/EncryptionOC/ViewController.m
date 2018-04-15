//
//  ViewController.m
//  EncryptionOC
//
//  Created by 李孔文 on 2018/4/9.
//  Copyright © 2018年 李孔文. All rights reserved.
//

#import "ViewController.h"
#import "MD5_code.h"
#import "HMac_code.h"
#import "DesEncrypt.h"
#import "EncryptionTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self AEC_EBC];
}

-(void)md5_code{
    
    NSString *password = @"password";
    NSString *code = [MD5_code md5:password];
}

-(void)HMac_code{
    NSString *password = @"password";
    NSString *code = [HMac_code HMacHashWithKey:@"@KNKBKLNknvknav(i0=0ndnakn" data:password];

}
//DES加密
-(void)DES_code{
    NSDictionary *password = @{@"name":@"小白",@"sex":@"woman"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:password options:0 error:NULL];
    NSString *code = [DesEncrypt tripleDESDataToString:data operation:0 key:@"sweet dreams"];
    [self DES_encode:code];
    
}
//DES解密
-(void)DES_encode:(NSString *)code{
    
    NSData * data = [DesEncrypt tripleDESStringToData:code operation:1 key:@"sweet dreams"];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
}
-(void)AEC_EBC{
    //AES - ECB 加密
    NSString * key = @"hk";
    //加密
    NSLog(@"加密: %@",[[EncryptionTools sharedEncryptionTools] encryptString:@"hello" keyString:key iv:nil]);
    //解密
    NSLog(@"解密: %@",[[EncryptionTools sharedEncryptionTools] decryptString:@"cKRPM1ALLG+0q5qCjADoaQ==" keyString:key iv:nil]);
}



@end
