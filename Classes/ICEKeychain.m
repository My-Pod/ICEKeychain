//
//  ICEKeychain1.m
//  ICEKeychain
//
//  Created by WLY on 16/9/5.
//  Copyright © 2016年 WLY. All rights reserved.
//

#import "ICEKeychain.h"



void ICELog(NSString *format, ...) {
#ifdef DEBUG
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}

@implementation ICEKeychain


#pragma mark - life cycle

+ (ICEKeychain *)keychain{
    return [[ICEKeychain alloc] init];
}



#pragma mark - private method

//获取设置信息
- (NSMutableDictionary *)keychianDicWithServer:(NSString *)server{
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    //Populate it with the data and the attributes we want to use.
    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword; // We specify what kind of keychain item this is.
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked; // This item can only be accessed when the user unlocks the device.
    
    keychainItem[(__bridge id)kSecAttrServer] = server;
    
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    
    return keychainItem;
    
}

//创建 keychainItem
- (void)createKeychainItemWithServer:(NSString *)server;{
    
    //判断是否是第一次启动, 如果是第一次启动, 则先删除之前的, 再创建新的.如果不是第一次使用, 则说明已经创建过了,则无需重复创建
    BOOL isNotFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLaunch"];
    
    if (isNotFirstLaunch == NO) {
        [self deletekeychainItemWithServer:server];
        OSStatus sts = SecItemAdd((__bridge CFDictionaryRef)[self keychianDicWithServer:server], NULL);
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLaunch"];
        ICELog(@"创建 keychainItme: %d", sts);
    }else{
        //如果不存在则创建
        if (SecItemCopyMatching((__bridge CFDictionaryRef)[self keychianDicWithServer:server], NULL) != noErr) {
            OSStatus sts = SecItemAdd((__bridge CFDictionaryRef)[self keychianDicWithServer:server], NULL);
            ICELog(@"创建 keychainItme: %d", sts);
        }
    }
}

//删除 keychainItem
- (void)deletekeychainItemWithServer:(NSString *)server{
    if (SecItemCopyMatching((__bridge CFDictionaryRef)[self keychianDicWithServer:server], NULL) == noErr) {
        OSStatus sts = SecItemDelete((__bridge CFDictionaryRef)[self keychianDicWithServer:server]);
        ICELog(@"删除%d",sts);
    }else{
        ICELog(@"不存在, 删除失败!");
    }

}


//更新 keychainItem
- (void)updateKeychainItem:(NSDictionary *)newItem
                withServer:(NSString *)server
{
    //更新之前先调用创建.
    [self createKeychainItemWithServer:server];
    
    NSMutableDictionary *keychainItem = [self keychianDicWithServer:server];
    //Must set these back to false for SecItemUpdate to work
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanFalse;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanFalse;
    
    OSStatus sts = SecItemUpdate((__bridge CFDictionaryRef)keychainItem, (__bridge CFDictionaryRef)newItem);
    ICELog(@"更新%d",sts);
}

//从钥匙串获取 指定 key 的值.
- (id)getKeychainItemWithKey:(CFStringRef)key withServer:(NSString *)server{
    CFDictionaryRef result = nil;
    
    OSStatus sts = SecItemCopyMatching((__bridge CFDictionaryRef)[self keychianDicWithServer:server], (CFTypeRef *)&result);
    if (sts == noErr) {
        NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
        id value = resultDict[(__bridge id)key];
        return value;
    }else{
        ICELog(@"获取密码错误%d",sts);
        return nil;
    }
}

#pragma mark - public methods

+ (void)saveValue:(NSString *)vlaue withServer:(NSString *)server{
    NSMutableDictionary *newItem = [NSMutableDictionary dictionary];
    newItem[(__bridge id)kSecValueData] = [vlaue dataUsingEncoding:NSUTF8StringEncoding];
    [[self keychain] updateKeychainItem:newItem withServer:server];
}

+ (NSString *)getValueWithServer:(NSString *)server{
    return [[NSString alloc] initWithData:[[ICEKeychain keychain] getKeychainItemWithKey:kSecValueData withServer:server] encoding:NSUTF8StringEncoding];
}


@end
