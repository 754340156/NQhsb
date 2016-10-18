//
//  NSDate+DAdditions.m
//  FCHK_Iphone
//
//  Created by Dean on 13-3-14.
//  Copyright (c) 2013年 FCHK Holdings Ltd. All rights reserved.
//

#import "NSDate+DAdditions.h"

@implementation NSDate (DAdditions)
+ (NSString *)timeStringWithInterval:(NSTimeInterval)time{
    
    long int distance = [[NSDate date] timeIntervalSince1970] - time/1000;
    NSString *string;
    if (distance < 1){//avoid 0 seconds
        string = @"刚刚";
    }
    else if (distance < 60) {
        string = [NSString stringWithFormat:@"%ld秒前", (distance)];
    }
    else if (distance < 3600) {//60 * 60
        distance = distance / 60;
        string = [NSString stringWithFormat:@"%ld分钟前", (distance)];
    }
    else if (distance < 86400) {//60 * 60 * 24
        distance = distance / 3600;
        string = [NSString stringWithFormat:@"%ld小时前", (distance)];
    }
    else if (distance < 2592000) {//60 * 60 * 24 * 7
        distance = distance / 86400;
        string = [NSString stringWithFormat:@"%ld天前", (distance)];
    }
//    else if (distance < 2419200) {//60 * 60 * 24 * 7 * 4
//        distance = distance / 604800;
//        string = [NSString stringWithFormat:@"%ld周前", (distance)];
//    }
    else if (distance < 31104000) { // 60 * 60 * 24 * 30 * 12
        distance = distance / 2592000;
        string = [NSString stringWithFormat:@"%ld月前", (distance)];
    }else {
        NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
     
    }
    return string;
}

// yyyy-MM-dd
+ (NSString *)timeStringWithDataTimeToDate:(NSTimeInterval)time
{
    NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年M月d日h时m分"];
    }
    NSString *string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
    return string;

    
}
+ (NSString *)timeStringWithDataTime:(NSTimeInterval)time
{
    NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd hh:mm"];
    }
    NSString *string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
    return string;
}
+ (NSString *)timeStringWithUserListTime:(NSTimeInterval)time
{
    NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YY-MM-dd hh:mm"];
    }
    NSString *string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
    return string;
}
- (NSString *)stringWithSeperator:(NSString *)seperator{
	return [self stringWithSeperator:seperator includeYear:YES];
}

// Return the formated string by a given date and seperator.
+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSDate *date = [formatter dateFromString:str];
	
	return date;
}

- (NSString *)stringWithFormat:(NSString*)format {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	NSString *string = [formatter stringFromDate:self];
	
	return string;
}

// Return the formated string by a given date and seperator, and specify whether want to include year.
- (NSString *)stringWithSeperator:(NSString *)seperator includeYear:(BOOL)includeYear{
	if( seperator==nil ){
		seperator = @"-";
	}
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	if( includeYear ){
		[formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd",seperator,seperator]];
	}else{
		[formatter setDateFormat:[NSString stringWithFormat:@"MM%@dd",seperator]];
	}
	NSString *dateStr = [formatter stringFromDate:self];
	
	
	return dateStr;
}

// return the date by given the interval day by today. interval can be positive, negtive or zero.
+ (NSDate *)relativedDateWithInterval:(NSInteger)interval{
	return [NSDate dateWithTimeIntervalSinceNow:(24*60*60*interval)];
}

// return the date by given the interval day by given day. interval can be positive, negtive or zero.
- (NSDate *)relativedDateWithInterval:(NSInteger)interval{
	NSTimeInterval givenDateSecInterval = [self timeIntervalSinceDate:[NSDate relativedDateWithInterval:0]];
	return [NSDate dateWithTimeIntervalSinceNow:(24*60*60*interval+givenDateSecInterval)];
}

- (NSString *)weekday{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	NSString *weekdayStr = nil;
	[formatter setDateFormat:@"c"];
	NSInteger weekday = [[formatter stringFromDate:self] integerValue];
	if( weekday==1 ){
		weekdayStr = @"星期日";
	}else if( weekday==2 ){
		weekdayStr = @"星期一";
	}else if( weekday==3 ){
		weekdayStr = @"星期二";
	}else if( weekday==4 ){
		weekdayStr = @"星期三";
	}else if( weekday==5 ){
		weekdayStr = @"星期四";
	}else if( weekday==6 ){
		weekdayStr = @"星期五";
	}else if( weekday==7 ){
		weekdayStr = @"星期六";
	}
	
	return weekdayStr;
}

- (NSString *)convertDateToStringWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [dateFormatter setTimeZone:timeZone];
    NSString *dateStr = [dateFormatter stringFromDate:self];
  
    return dateStr;
}

- (NSDate *)convertStringToDate:(NSString *)string format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    //    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    //    [dateFormatter setTimeZone:timeZone];
    NSDate *date = [dateFormatter dateFromString:string];
    
    return date;
}

- (NSDate *)cc_dateByMovingToBeginningOfDay
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
    [parts setHour:0];
    [parts setMinute:0];
    [parts setSecond:0];
    return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *)cc_dateByMovingToEndOfDay
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
    [parts setHour:23];
    [parts setMinute:59];
    [parts setSecond:59];
    return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *)cc_dateByMovingToFirstDayOfTheMonth
{
    NSDate *d = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&d interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day the month based on %@", self);
    return d;
}

- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousMonth
{
    NSDateComponents *c = [[NSDateComponents alloc] init] ;
    c.month = -1;
    return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth];
}

- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingMonth
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.month = 1;
    return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth];
}

- (NSDateComponents *)cc_componentsForMonthDayAndYear
{
    return [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
}

- (NSUInteger)cc_weekday
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}

- (NSUInteger)cc_numberOfDaysInMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}
///时间戳转时间
+ (NSString *)gp_timeTransformWith:(long)timeInterval
{
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate:detailDate];
    
    return currentDateStr;
}


@end
