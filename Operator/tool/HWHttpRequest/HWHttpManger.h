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
 * 获取用户的订单编号
 * payType  1 支付宝   2 微信
 */
+ (void)getUserorderIdgoodsId:(NSString *)orderId payType:(NSString *)payType success:(void (^)(id result))success failBlock:(void(^)(NSError*error))failBlock;

/**
 添加话术本声音
 */
+ (void)AdduserWordsWithType:(NSString *)type content:(NSString *)content title:(NSString *)title remark:(NSString*)remark success:(void (^)(id result))success failBlock:(void(^)(NSError*error))failBlock;

/**
 获取录音模板分析数据
 已选择模板列表生成问题分析
 */
+ (void)getquestionListWithIds:(NSString *)ids success:(void (^)(id result))success failBlock:(void(^)(NSError*error))failBlock;

/**
 根据模板id获取题库（未缓存）
 */
+ (void)getquestiondataId:(NSString *)dataid type:(NSString *)type success:(void (^)(id result))success failBlock:(void(^)(NSError*error))failBlock;

/**
 根据模板id获取题库（已缓存）
 */
+ (void)getCacheQuestiondataId:(NSString *)dataid questionlogId:(NSString *)questionlogId success:(void (^)(id result))success failBlock:(void(^)(NSError*error))failBlock;



@end
