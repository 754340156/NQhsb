//
//  NSString+YWExtension.h
//  YWBaseFrameWork
//
//  Created by mac on 16/7/17.
//  Copyright © 2016年 NeiQuan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (YWExtension)

/// 验证字符串为空 ,为空:YES, 不为空:NO
+ (BOOL)StringIsNULL:(NSString *)string;

/// 验证手机号码, 正确:YES , 错误: 提示
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//判断是否全为中文
+(BOOL)isValidateHomePhoneNum:(NSString *)string;

//判断某个字符串的长度是否在某个范围内0除外
- (BOOL)RangeMinNum:(int) minNum maxNum:(int) maxNum;

//判断是否只有数字或字母
- (BOOL)isOnlyNumAndLetter;

//判断是否是微信
+ (BOOL)isWheatNumber:(NSString *)str;

//判断是否全为数字
+ (BOOL)isPureNumandCharacters:(NSString *)string;

//判断是否身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard;

/* 判断文本是否包含emoji */
+ (BOOL)isContainsEmoji:(NSString *)string;

//银行卡判断  -——>不适合16位以上信用卡的判断
+ (BOOL)isValidCreditNumber:(NSString*)value;

//根据字符计算高度  -——>目前本人遇到的最精确的计算方法
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constrainedToWidth:(CGFloat)width;
// 去除尾部space, /n, /t
+(NSString*)trimWithstring:(NSString *)string;

@end
