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
+ (void)removeAllcount
{

    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL result = [manager removeItemAtPath:BABarAccountFile error:nil];
    // 2. 获取caches路径
//    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//
//    // 3. 把要删除的文件名称拼接到caches的路径上去(我要删除icon.png这个文件)
//    NSString *deleteFilePath = [cachesPath stringByAppendingPathComponent:];
//
//    // 4. 让manager执行删除动作, result = 1说明删除成功, =0删除失败
//    BOOL result = [manager removeItemAtPath:deleteFilePath error:nil];
    
    if (result) {
        LogApi(@"删除成功");
    }else{
        LogApi(@"删除失败");
    }
}

+ (XBAccount *)account
{
    // 取出账号
    XBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:BABarAccountFile];
    
 
    return account;

}

@end
