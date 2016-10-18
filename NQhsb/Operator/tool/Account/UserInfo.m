//
//  BABar.m
//  Hippo
//
//  Created by jock on 16/6/30.
//  Copyright © 2016年 jock. All rights reserved.
//


#import "UserInfo.h"
#define BABarAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HippoAccount.data"]

@implementation UserInfo


+ (UserInfo *)shared {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
        
        
    });
    return instance;
}


+ (void)saveAccount:(XBAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:BABarAccountFile];
}

+ (XBAccount *)account
{
    // 取出账号
    XBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:BABarAccountFile];
    
 
    return account;

}

@end
