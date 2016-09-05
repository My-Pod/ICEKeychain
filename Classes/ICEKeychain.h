//
//  ICEKeychain1.h
//  ICEKeychain
//
//  Created by WLY on 16/9/5.
//  Copyright © 2016年 WLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICEKeychain : NSObject

/**
 *  一个 seaver 对应一个 value.
 */
+ (void)saveValue:(NSString *)vlaue
       withServer:(NSString *)server;
+ (NSString *)getValueWithServer:(NSString *)server;

@end
