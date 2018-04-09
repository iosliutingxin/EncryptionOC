//
//  ViewController.m
//  EncryptionOC
//
//  Created by 李孔文 on 2018/4/9.
//  Copyright © 2018年 李孔文. All rights reserved.
//

#import "ViewController.h"
#import "MD5_code.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self md5_code];
}

-(void)md5_code{
    
    NSString *password = @"password";
    NSString *code = [MD5_code md5:password];
}


@end
