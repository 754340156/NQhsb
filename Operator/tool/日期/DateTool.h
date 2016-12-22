//
//  DateTool.h
//  Accounting
//
//  Created by ccg on 13-8-30.
//  Copyright (c) 2013年 ccg. All rights reserved.
//  时间工具类

#import <Foundation/Foundation.h>

@interface DateTool : NSObject


// 根据时间转换日期元素
- (NSDateComponents *)dateComponentsWithDate:(NSDate *)date;

// 获取指定日期在年的开始时间
- (NSDate *)startDateInYearOfDate:(NSDate *)date;
// 获取指定日期在年的结束时间
- (NSDate *)endDateInYearOfDate:(NSDate *)date;

// 获取指定日期在月的开始时间
- (NSDate *)startDateInMonthOfDate:(NSDate *)date;
// 获取指定日期在月的结束时间
- (NSDate *)endDateInMonthOfDate:(NSDate *)date;

// 获取指定日期在周的开始时间
- (NSDate *)startDateInWeekOfDate:(NSDate *)date;
// 获取指定日期在周的结束时间
- (NSDate *)endDateInWeekOfDate:(NSDate *)date;

// 获取指定日期在天的开始时间
- (NSDate *)startDateInDayOfDate:(NSDate *)date;
// 获取指定日期在天的结束时间
- (NSDate *)endDateInDayOfDate:(NSDate *)date;



@end
