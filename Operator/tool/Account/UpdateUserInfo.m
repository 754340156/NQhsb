//
//  UpdateUserInfo.m
//  Operator
//
//  Created by 白小田 on 2016/12/2.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "UpdateUserInfo.h"

@implementation UpdateUserInfo

+(void)updateUserInfo
{
    [NetWorkHelp netWorkWithURLString:getUser
                           parameters:@{@"account":[UserInfo account].account,
                                        @"token":[UserInfo account].token}
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 XBAccessLoginTokenResult *result = [XBAccessLoginTokenResult mj_objectWithKeyValues:dic[@"response"][@"user"]];
                                 [UserInfo saveAccount:result];
                                 DLog(@"更新用户信息成功");
                             }else{
                                 DLog(@"更新用户信息失败");
                             }
                         } failBlock:^(NSError *error) {
                             
                         }];
}

+(NSString *)getUserDataTime:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:time];
    NSUInteger day = GJCFDateDaysAgo(date);
    NSString *dayStr = [NSString stringWithFormat:@"%lu",(unsigned long)day];
    NSLog(@"%@", dayStr);
    return dayStr;
}
+(NSString *)intervalSinceNow:(NSString *)theDate
{
    NSString *timeString=@"";
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *fromdate=[format dateFromString:theDate];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    
    //获取当前时间
    NSDate *adate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: adate];
    NSDate *localeDate = [adate  dateByAddingTimeInterval: interval];
    
    double intervalTime = [fromDate timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate];
    long lTime = labs((long)intervalTime);
    NSInteger iSeconds =  lTime % 60;
    NSInteger iMinutes = (lTime / 60) % 60;
    NSInteger iHours = labs(lTime/3600);
    NSInteger iDays = lTime/60/60/24;
    NSInteger iMonth =lTime/60/60/24/12;
    NSInteger iYears = lTime/60/60/24/384;
    if (intervalTime<0) {
        iDays = 0;
        iHours = 0;
    }
    
    NSLog(@"相差%ld年%ld月 或者 %ld日%ld时%ld分%ld秒", iYears,iMonth,iDays,iHours,iMinutes,iSeconds);
    
    
    //    if (iHours<1 && iMinutes>0)
    //    {
    //        timeString=[NSString stringWithFormat:@"%ld分",iMinutes];
    //
    //    }else if (iHours>0&&iDays<1 && iMinutes>0) {
    //        timeString=[NSString stringWithFormat:@"%ld时%ld分",iHours,iMinutes];
    //    }
    //    else if (iHours>0&&iDays<1) {
    //        timeString=[NSString stringWithFormat:@"%ld时",iHours];
    //    }else if (iDays>0 && iHours>0)
    //    {
    //        timeString=[NSString stringWithFormat:@"%ld天%ld时",iDays,iHours];
    //    }
    //    else
    if (iDays>0)
    {
        timeString=[NSString stringWithFormat:@"%ld",iDays];
    }else{
        timeString= @"0";
    }
    return timeString;
}

//+ (NSString *)detailTimeAgoString:(NSDate *)date
//{
//    if (GJCFCheckObjectNull(date)) {
//        return nil;
//    }
//    long long timeNow = [date timeIntervalSince1970];
//    NSCalendar * calendar=[GJCFDateUitil sharedCalendar];
//    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
//    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
//    
//    NSInteger year=[component year];
//    NSInteger month=[component month];
//    NSInteger day=[component day];
//    
//    NSDate * today=[NSDate date];
//    component=[calendar components:unitFlags fromDate:today];
//    
//    NSInteger t_year=[component year];
//    
//    NSString  *string=nil;
//    
//    long long now = [today timeIntervalSince1970];
//    
//    long long  distance= timeNow - now ;
//    if(distance<60)
//        string=@"0";
//    else if(distance<60*60)
//        string=@"0";
//    else if(distance<60*60*24)
//        string=@"0";
//    else if(distance<60*60*24*7)
//        string=[NSString stringWithFormat:@"%lld",distance/60/60/24];
//    else if(year==t_year)
//        string=[NSString stringWithFormat:@"%ld月%ld日",(long)month,(long)day];
//    else
//        string=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)year,(long)month,(long)day];
//    
//    return string;
//}
////获取剩余天数
//+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate
//{
//    NSCalendar *gregorian = [[NSCalendar alloc]
//                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    
//    [gregorian setFirstWeekday:2];
//    
//    //去掉时分秒信息
//    NSDate *fromDate;
//    NSDate *toDate;
//    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
//    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
//    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
//    
//    return dayComponents.day;
//}

@end
