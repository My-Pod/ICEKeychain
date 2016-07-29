//
//  ICEKeychain.m
//  LoginText
//
//  Created by WLY on 16/7/29.
//  Copyright © 2016年 WLY. All rights reserved.
//

#import "ICEKeychain.h"
#import <Security/Security.h>
#import <UIKit/UIKit.h>


void ICELog(NSString *format, ...) {
#ifdef DEBUG
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}


@implementation ICEKeychain



+ (instancetype)keychain{
    ICEKeychain *keychain = [[ICEKeychain alloc] init];
    return keychain;
}

#pragma mark - public method
//保存用户名 和密码
+ (void)saveUserName:(NSString *)userName andPassword:(NSString *)password{
    NSMutableDictionary *newItem = [NSMutableDictionary dictionary];
    newItem[(__bridge id)kSecValueData] = [password dataUsingEncoding:NSUTF8StringEncoding];
    newItem[(__bridge id)kSecAttrAccount] = userName;
    [[self keychain] updateKeychainItem:newItem];
}
//保存用户名
+ (void)savePassword:(NSString *)password{
    NSMutableDictionary *newItem = [NSMutableDictionary dictionary];
    newItem[(__bridge id)kSecValueData] = [password dataUsingEncoding:NSUTF8StringEncoding];
    [[self keychain] updateKeychainItem:newItem];
}

//保存秘密
+ (void)saveUserName:(NSString *)userName{
    NSMutableDictionary *newItem = [NSMutableDictionary dictionary];
    newItem[(__bridge id)kSecAttrAccount] = userName;
    [[self keychain] updateKeychainItem:newItem];
}

//获取用户名
+ (NSString *)getUserName{
    return [[ICEKeychain keychain] getKeychainItemWithKey:kSecAttrAccount];
}
//获取密码
+ (NSString *)getPassword{
    return [[NSString alloc] initWithData:[[ICEKeychain keychain] getKeychainItemWithKey:kSecValueData] encoding:NSUTF8StringEncoding];
}
//删除
+ (void)deleteKeychianItem{
    [[self keychain] deletekeychainItem];
}
#pragma mark - private method


// keychainItme 查询条件
- (NSMutableDictionary *)keychainDic{
    
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    //Populate it with the data and the attributes we want to use.
    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword; // We specify what kind of keychain item this is.
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked; // This item can only be accessed when the user unlocks the device.
    
    keychainItem[(__bridge id)kSecAttrServer] = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];;
    
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    
    return keychainItem;
}

//创建 keychainItem
- (void)createKeychainItem{
    //判断当前钥匙串中是否已存在此值
    if (SecItemCopyMatching((__bridge CFDictionaryRef)[self keychainDic], NULL) == noErr) {
        ICELog(@"已经存在");
    }else{
        OSStatus sts = SecItemAdd((__bridge CFDictionaryRef)[self keychainDic], NULL);
        ICELog(@"创建%d",sts);
    }
}

//更新 keychainItem
- (void)updateKeychainItem:(NSDictionary *)newItem{
    [self createKeychainItem];
    
    NSMutableDictionary *keychainItem = [self keychainDic];
    //Must set these back to false for SecItemUpdate to work
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanFalse;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanFalse;
    
    OSStatus sts = SecItemUpdate((__bridge CFDictionaryRef)keychainItem, (__bridge CFDictionaryRef)newItem);
    ICELog(@"更新%d",sts);
}

//删除 keychainItem
- (void)deletekeychainItem{
    OSStatus sts = SecItemDelete((__bridge CFDictionaryRef)[self keychainDic]);
    ICELog(@"删除%d",sts);
}

//从钥匙串获取 指定 key 的值.
- (id)getKeychainItemWithKey:(CFStringRef)key{
    CFDictionaryRef result = nil;
    OSStatus sts = SecItemCopyMatching((__bridge CFDictionaryRef)[self keychainDic], (CFTypeRef *)&result);
    if (sts == noErr) {
        NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
        id value = resultDict[(__bridge id)key];
        return value;
    }else{
       ICELog(@"获取密码错误%d",sts);
    }
    return nil;
}


@end
