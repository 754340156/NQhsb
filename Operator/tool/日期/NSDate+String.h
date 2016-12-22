//
//  NSDate+String.h
//  Accounting
//
//  Created by ccg on 13-8-30.
//  Copyright (c) 2013年 ccg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateTool.h"
@interface NSDate (String)

// 获取时间字符串
- (NSString *)dateString;
// 获取时间字符串，天数类型
- (NSString *)dateStringByDay;

// 获取时间字符串，日期类型
- (NSString *)dateStringByDate;
// 获取时间字符串，时间类型
- (NSString *)dateStringByTime;

// 根据字符串获取时间
+ (NSDate *)dateWithString:(NSString *)str;
// 根据字符串获取时间，日期类型
+ (NSDate *)dateWithStringByDay:(NSString *)str;

// 根据当前时间和天数获取时间
- (NSDate *)dateWithDay:(NSInteger)day;
// 根据当前时间和月份获取时间
- (NSDate *)dateWithMonth:(NSInteger)month;
// 根据年份获取时间
+ (NSDate *)dateWithYear:(NSInteger)year;


// 将指定时间的日期赋给当前对象的日期，时间不变
- (NSDate *)copyDateButTimeWithDate:(NSDate *)date;

@end
