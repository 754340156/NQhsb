//
//  DateTool.m
//  Accounting
//
//  Created by ccg on 13-8-30.
//  Copyright (c) 2013年 ccg. All rights reserved.
//

#import "DateTool.h"
#import "NSDate+String.h"
@implementation DateTool



#pragma mark 根据时间转换日期元素
- (NSDateComponents *)dateComponentsWithDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
    NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    
    return comps;
}

#pragma mark 获取指定日期在年的开始时间
- (NSDate *)startDateInYearOfDate:(NSDate *)date
{
    NSDateComponents *comps = [self dateComponentsWithDate:date];
    NSString *dateStr = [NSString stringWithFormat:@"%ld-01-01 00:00:00", (long)comps.year];
    return [NSDate dateWithString:dateStr];
}

#pragma mark 获取指定日期在年的结束时间
- (NSDate *)endDateInYearOfDate:(NSDate *)date
{
    NSDateComponents *comps = [self dateComponentsWithDate:date];
    NSString *dateStr = [NSString stringWithFormat:@"%ld-12-30 23:59:59", (long)comps.year];
    return [NSDate dateWithString:dateStr];
}

#pragma mark 获取指定日期在月的开始时间
- (NSDate *)startDateInMonthOfDate:(NSDate *)date
{
    NSDateComponents *comps = [self dateComponentsWithDate:date];
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-01 00:00:00", (long)comps.year, (long)comps.month];
    return [NSDate dateWithString:dateStr];
}

#pragma mark 获取指定日期在月的结束时间
- (NSDate *)endDateInMonthOfDate:(NSDate *)date
{
    NSDateComponents *comps = [self dateComponentsWithDate:date];
    int day = [self dayWithYear:comps.year Month:comps.month];
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%d 23:59:59", (long)comps.year, (long)comps.month, day];
    return [NSDate dateWithString:dateStr];
}

#pragma mark 获取指定日期在周的开始时间
- (NSDate *)startDateInWeekOfDate:(NSDate *)date
{
    NSDateComponents *comps = [self dateComponentsWithDate:date];
    int day = comps.day - comps.weekday + 1;
    
    // 当计算出的周的开始是上月，则默认从这个月的第一天开始
    if (day < 1) {
        day = 1;
    }
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%d 00:00:00", (long)comps.year, (long)comps.month, day];
    
    return [NSDate dateWithString:dateStr];
}

#pragma mark 获取指定日期在周的结束时间
- (NSDate *)endDateInWeekOfDate:(NSDate *)date
{
    NSDateComponents *comps = [self dateComponentsWithDate:date];
    int maxDay = [self dayWithYear:comps.year Month:comps.month];
    int day = comps.day - comps.weekday + 7;
    
    // 当计算出的时间超出范围则取当前时间的最大天数
    if ( day > maxDay) {
        day = maxDay;
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%d 23:59:59", (long)comps.year, (long)comps.month, day];
    
    return [NSDate dateWithString:dateStr];
}

#pragma mark 获取指定日期在天的开始时间
- (NSDate *)startDateInDayOfDate:(NSDate *)date
{
    NSDateComponents *comps = [self dateComponentsWithDate:date];
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld 00:00:00", (long)comps.year, (long)comps.month, (long)comps.day];
    
    return [NSDate dateWithString:dateStr];
}

#pragma mark 获取指定日期在天的结束时间
- (NSDate *)endDateInDayOfDate:(NSDate *)date
{
    NSDateComponents *comps = [self dateComponentsWithDate:date];
    NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d 23:59:59", comps.year, comps.month, comps.day];
    
    return [NSDate dateWithString:dateStr];
}


#pragma mark 获取指定年的开始时间
- (NSDate *)startDateInYearWithYear:(NSInteger)year
{
    NSString *dateStr = [NSString stringWithFormat:@"%d-01-01 00:00:00", year];
    
    return [NSDate dateWithString:dateStr];
}

#pragma mark 获取指定月的开始时间
- (NSDate *)startDateInMonthWithYear:(NSInteger)year Month:(NSInteger)month
{
    NSString *dateStr = [NSString stringWithFormat:@"%d-%d-01 00:00:00", year, month];
    
    return [NSDate dateWithString:dateStr];
}

#pragma mark 获取指定周的开始时间
- (NSDate *)startDateInWeekWithYear:(NSInteger)year Month:(NSInteger)month Week:(NSInteger)weekday Day:(NSInteger)day
{
    NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%ld 00:00:00", year, month, day - weekday + 1];
    
    return [NSDate dateWithString:dateStr];
}

#pragma mark 获取指定日的开始时间
- (NSDate *)startDateInDayWithYear:(NSInteger)year Month:(NSInteger)month Week:(NSInteger)weekday Day:(NSInteger)day
{
    NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d 00:00:00", year, month, day];
    
    return [NSDate dateWithString:dateStr];
}

#pragma mark 获取指定月的结束时间
- (NSDate *)endDateInMonthWithYear:(NSInteger)year Month:(NSInteger)month
{
    // 根据年和月获取总天数
    int day = [self dayWithYear:year Month:month];
    NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d 23:59:59", year, month, day];
    
    return [NSDate dateWithString:dateStr];
}

#pragma mark 计算相应月份的天数
- (NSInteger)dayWithYear:(NSInteger)year Month:(NSInteger)month
{
    int day = 30;
    if (month == 2) {
        if ((year % 400 == 0) || (year % 4 == 0 && year % 100 == 0)) {
            day = 29;
        } else {
            day = 28;
        }
    } else if(month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
        day = 31;
    } else {
        day = 30;
    }
    
    return day;
}



@end
