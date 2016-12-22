//
//  NSDate+String.m
//  Accounting
//
//  Created by ccg on 13-8-30.
//  Copyright (c) 2013年 ccg. All rights reserved.
//

#import "NSDate+String.h"

@implementation NSDate (String)

#pragma mark 获取时间字符串
- (NSString *)dateString
{
    // 定义时间格式
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    df.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    
    return [df stringFromDate:self];
}
#pragma mark 获取时间字符串，天数类型
- (NSString *)dateStringByDay
{
    // 定义时间格式
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    df.dateFormat=@"yyyy-MM-dd";
    
    return [df stringFromDate:self];
}

#pragma mark 获取时间字符串，日期类型
- (NSString *)dateStringByDate
{
    // 定义时间格式
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    df.dateFormat=@"yyyy年MM月dd日";
    
    return [df stringFromDate:self];
}

#pragma mark 获取时间字符串，时间类型
- (NSString *)dateStringByTime
{
    // 定义时间格式
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    df.dateFormat=@"HH:mm:ss";
    
    return [df stringFromDate:self];
}

#pragma mark 根据字符串获取时间
+ (NSDate *)dateWithString:(NSString *)str
{
    // 定义时间格式
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    df.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [df dateFromString:str];
    
    return date;
}

#pragma mark 根据字符串获取时间，日期类型
+ (NSDate *)dateWithStringByDay:(NSString *)str
{
    // 定义时间格式
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    df.dateFormat=@"yyyy.MM.dd";
    NSDate *date = [df dateFromString:str];
    
    return date;
}

#pragma mark 根据当前时间和天数获取时间
- (NSDate *)dateWithDay:(NSInteger)day
{
    NSDateComponents *comps = [[[DateTool alloc] init] dateComponentsWithDate:self];
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld", (long)comps.year, (long)comps.month, (long)day, (long)comps.hour, (long)comps.minute, (long)comps.second];
    
    return [NSDate dateWithString:dateStr];
}

#pragma mark 根据月份获取时间
- (NSDate *)dateWithMonth:(NSInteger)month
{
    NSDateComponents *comps = [[[DateTool alloc]init] dateComponentsWithDate:self];
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld", (long)comps.year, month, (long)comps.day, (long)comps.hour, (long)comps.minute, (long)comps.second];
    
    return [NSDate dateWithString:dateStr];
}

#pragma mark 根据年份获取时间
+ (NSDate *)dateWithYear:(NSInteger)year
{
    NSString *dateStr = [NSString stringWithFormat:@"%ld-12-31 23:59:59", (long)year];
    
    return [NSDate dateWithString:dateStr];
}

#pragma mark 将指定时间的日期赋给当前对象的日期，时间不变
- (NSDate *)copyDateButTimeWithDate:(NSDate *)date
{
    NSDateComponents *selfComps = [[[DateTool alloc]init] dateComponentsWithDate:self];
    NSDateComponents *dateComps = [[[DateTool alloc]init] dateComponentsWithDate:date];
    
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld",(long)dateComps.year, (long)dateComps.month, (long)dateComps.day, (long)selfComps.hour, (long)selfComps.minute, (long)selfComps.second];
    
    return [NSDate dateWithString:dateStr];
}

@end
