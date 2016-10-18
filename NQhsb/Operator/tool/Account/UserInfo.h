//
//  BABar.h
//  Hippo
//
//  Created by jock on 16/6/30.
//  Copyright © 2016年 jock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBAccount.h"
@interface  UserInfo: NSObject
/**
 *  实例化
 */
+ (UserInfo *)shared;
/**
 *  保存
 */
+ (void)saveAccount:(XBAccount *)account;
/**
 *  取出数据
 *
 *  @return account
 */
+ (XBAccount *)account;

@end
