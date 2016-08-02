//
//  ICEKeychain.h
//  LoginText
//
//  Created by WLY on 16/7/29.
//  Copyright © 2016年 WLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICEKeychain : NSObject

//server 为单个 keychainItem 的唯一标示符, 

+ (void)saveUserName:(NSString *)userName
         andPassword:(NSString *)password
          withServer:(NSString *)server;

+ (void)saveUserName:(NSString *)userName
          withServer:(NSString *)server;
+ (void)savePassword:(NSString *)password
          withServer:(NSString *)server;
/**
 *  单独的保存一项值, 此处的 server 不能和保存的密码 server 相同.
 */
+ (void)saveValue:(NSString *)vlaue
       withServer:(NSString *)server;;

+ (void)deleteKeychianItemWithServer:(NSString *)server;

+ (NSString *)getUserNameWithServer:(NSString *)server;
+ (NSString *)getPasswordWithServer:(NSString *)server;

+ (NSString *)getValueWithServer:(NSString *)server;


@end
