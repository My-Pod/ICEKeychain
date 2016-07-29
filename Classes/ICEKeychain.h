//
//  ICEKeychain.h
//  LoginText
//
//  Created by WLY on 16/7/29.
//  Copyright © 2016年 WLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICEKeychain : NSObject

+ (void)saveUserName:(NSString *)userName
        andPassword:(NSString *)password;

+ (void)saveUserName:(NSString *)userName;
+ (void)savePassword:(NSString *)password;

+ (void)deleteKeychianItem;

+ (NSString *)getUserName;
+ (NSString *)getPassword;


@end
