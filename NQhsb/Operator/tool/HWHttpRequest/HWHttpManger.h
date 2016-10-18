//
//  HWHttpManger.h
//  Operator
//
//  Created by NeiQuan on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <Foundation/Foundation.h>

//用户请求网络数据
@interface HWHttpManger : NSObject

/**
 获取用户的订单
 */
+ (void)getUserordersuccess:(void (^)(id result))success failBlock:(void(^)(NSError*error))failBlock;

/**
 添加话术本声音
 */
+ (void)AdduserWordsWithType:(NSString *)type content:(NSString *)content title:(NSString *)title remark:(NSString*)remark success:(void (^)(id result))success failBlock:(void(^)(NSError*error))failBlock;



@end
