//
//  ViewController.m
//  test
//
//  Created by WLY on 16/7/29.
//  Copyright © 2016年 WLY. All rights reserved.
//

#import "ViewController.h"
#import "ICEKeychain.h"
NSString *const keychainIdentify = @"waniyun";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ICEKeychain saveUserName:@"userName" andPassword:@"pase"];
    [ICEKeychain saveUserName:@"fasfasdsasdfa"];
    NSLog(@"%@",[ICEKeychain getUserName]);
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
