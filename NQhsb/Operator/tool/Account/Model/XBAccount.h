//
//  XBBarAccount.h
//  Hippo
//
//  Created by jock on 16/6/30.
//  Copyright © 2016年 jock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  XBAccount: NSObject

/**
 *  账户ID
 */
@property (nonatomic, copy) NSString *account;

/**
 *  用户token
 */
@property (nonatomic, copy) NSString *token;

/**
 *  验证码
 */
@property (nonatomic, copy) NSString *verCode;

/**
 *  用户状态
 *
 *  1 拉黑用户 2 临时用户 3 付费用户（销售职） 4付费用户（管理职）
 */
@property (nonatomic, copy) NSString *userState;

/**
 * 试用期到期时间   如果已充值就是会员到期时间
 */
@property (nonatomic, copy) NSString *expireTime;


/**
 *  账户id
 */
@property (nonatomic, copy) NSString *ID;

/**
 * 用户头像
 */
@property (nonatomic, copy) NSString *headpic;

/**
 * 用户昵称
 */
@property (nonatomic, copy) NSString *nickname;

/**
 * 登陆号
 */
@property (nonatomic, copy) NSString *phone;

/**
 *  积分
 */
@property (nonatomic, copy) NSString *integral;

/**
 *  性别
 */
@property (nonatomic, copy) NSString *sex;

/**
 *  推送类型
 */
@property (nonatomic, copy) NSString *pushType;

/**
 *  推送token
 */
@property (nonatomic, copy) NSString *pushtoken;

/**
 *  注册时间
 */
@property (nonatomic,copy) NSString *registerTime;

/**
 *  个性签名
 */
@property (nonatomic,copy) NSString *mysign;



+ (instancetype)accountWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
