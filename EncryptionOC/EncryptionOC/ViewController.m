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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self DES_code];
}

-(void)md5_code{
    
    NSString *password = @"password";
    NSString *code = [MD5_code md5:password];
}

-(void)HMac_code{
    NSString *password = @"password";
    NSString *code = [HMac_code HMacHashWithKey:@"@KNKBKLNknvknav(i0=0ndnakn" data:password];

}

-(void)DES_code{
    NSDictionary *password = @{@"name":@"小白",@"sex":@"woman"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:password options:0 error:NULL];
    NSString *code = [DesEncrypt tripleDESDataToString:data operation:0 key:@"sweet dreams"];
    [self DES_encode:code];
    
}

-(void)DES_encode:(NSString *)code{
    
    
    NSData * data = [DesEncrypt tripleDESStringToData:code operation:1 key:@"sweet dreams"];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
}


@end
