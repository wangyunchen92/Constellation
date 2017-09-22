//
//  YMDateTool.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMDateTool.h"

@implementation YMDateTool
//过去时间处理
+ (NSString *)distanceTimeWithBeforeTime:(double)beTime
{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    
    double distanceTime = now - beTime;
    
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    
    [df setDateFormat:@"HH:mm"];
    
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    
    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {//小于一分钟
        
        distanceStr = @"刚刚";
        
    }
    else if (distanceTime < 60*60) {//时间小于一个小时
        
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
        
    }
    else if(distanceTime < 24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
        
    }
    else if(distanceTime< 24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] == 1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        else{
            [df setDateFormat:@"MM-dd HH:mm"];
            distanceStr = [df stringFromDate:beDate];
        }
    }
    else if(distanceTime < 24*60*60*365){
        
        [df setDateFormat:@"MM-dd HH:mm"];
        
        distanceStr = [df stringFromDate:beDate];
        
    }
    else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}
// 和当前时间进行比较  输出字符串为（刚刚几个小时前 几天前 ）
+(NSString *)inputTimeStr:(NSString *)timeStr
{
    NSDate *nowDate = [NSDate date];
    NSDate *sinceDate = [self becomeDateStr:timeStr];
    int i  = [nowDate timeIntervalSinceDate:sinceDate];
    
    NSString  *str  = @"";
    if (i <= 60) {
        
        str = @"刚刚";
    }
    else if(i>60 && i<=3600 )
    {
        
        str = [NSString stringWithFormat:@"%d分钟前",i/60];
    }
    else if (i>3600 && i<60*60*24)
    {
        
        str = [NSString stringWithFormat:@"%d小时前",i/3600];
    }
    else
    {
        int k = i/(3600*24);
        
        //在这里大于1天的我们可以以周几的形式显示
        if (k>1) {
            
            str  = [self weekdayStringFromDate:[self becomeDateStr:timeStr]];
        }
        else
        {
            str = [NSString stringWithFormat:@"%d天前",i/(3600*24)];
        }
    }
    
    return str;
    
}

//把时间字符串转换成NSDate
+ (NSDate *)becomeDateStr:(NSString *)dateStr
{
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date1 = [formatter2 dateFromString:dateStr];
    return date1;
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}


//时间比较
+ (int)compareDate:(NSString*)date01 withDate:(NSString*)date02 {
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    
    NSDate *dt2 = [[NSDate alloc] init];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            ci = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            ci= -1;
            break;
            //date02 = date01
        case NSOrderedSame:
            ci=0;
            break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);
            break;
    }
    return ci;
}
//以固定格式 比较时间的大小
+(int)compareCurrentDateWithOtherDateStr:(NSString* )otherDateStr format:(NSString* )format{
    
    NSDate* currentDate = [self getCurrentDateWithFormat:format];//@"yyyy-MM-dd HH:mm:ss"
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSDate *otherDate  = [formatter dateFromString:otherDateStr];
    
    int flag =  [self compareDateWithFormatDate:currentDate withDate:otherDate];
    return flag;
}

//格式化时间比较
+ (int)compareDateWithFormatDate:(NSDate*)date1 withDate:(NSDate*)date2{
    int ci;
    //    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSDate *dt1 = [[NSDate alloc] init];
    //    NSDate *dt2 = [[NSDate alloc] init];
    //    dt1 = [df dateFromString:date01];
    //    dt2 = [df dateFromString:date02];
    
    NSComparisonResult result = [date1 compare:date2];
    DDLog(@"result  === %ld",(long)result);
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            ci = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            ci= -1;
            break;
            //date02 = date01
        case NSOrderedSame:
            ci=0;
            break;
        default: NSLog(@"erorr dates %@, %@", date1, date2);
            break;
    }
    DDLog(@"ci ======= %d",ci);
    return ci;
}
//根据 date 字符串 和时间格式 获取 date
+(NSDate* )getDateWithDateStr:(NSString* )otherDateStr formate:(NSString*)format{
    DDLog(@"otherDateStr === %@",otherDateStr);
    NSDate  *tmpDate = [NSDate dateWithTimeIntervalSince1970:otherDateStr.longLongValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSString *formatDateStr = [formatter stringFromDate:tmpDate];
    
    NSDate *otherDate  = [formatter dateFromString:formatDateStr];
    
    DDLog(@"dateStr == %@  otherDate == %@",formatDateStr,otherDate);
    return otherDate;
}

//时间格式化
+ (NSString *)timeForDateFormatted:(NSString*)totalSeconds format:(NSString* )format{
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:totalSeconds.longLongValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString* datestring = [dateFormatter stringFromDate:date];
    return datestring;
}

//获取当前格式化时间
+(NSDate* )getCurrentDateWithFormat:(NSString* )format{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    NSDate *date       = [formatter dateFromString:dateTime];
   // DDLog(@"---------- currentDate == %@",date);
    return date;
}

+(NSString* )futureTimeWithfutureTime:(NSString* )futureTime format:(NSString*)format{
//    NSDate* currentDate = [self getCurrentDateWithFormat:format];
    NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
    [dateformat setDateFormat:format];
    NSDate* otherDate   = [dateformat dateFromString:futureTime];
    
  //  [NSDate timeIntervalSinceReferenceDate];
    
  //  NSTimeInterval nowInterval = [[NSDate date]timeIntervalSince1970];
  //  NSTimeInterval futureInterval = [otherDate timeIntervalSince1970 ];
    NSTimeInterval distanceTime = [otherDate timeIntervalSinceDate:[self getCurrentDateWithFormat:format]];//futureInterval - nowInterval;
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
  //  NSTimeInterval time = [otherDate timeIntervalSinceDate:[self getCurrentDateWithFormat:format]];
    
    int days=((int)distanceTime)/(3600*24);
    int hours=((int)distanceTime)%(3600*24)/3600;
    int minus =((int)distanceTime)%3600/60;
    int second = ((int)distanceTime)%60;
  //  NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时%i分%i秒",days,hours,minus,second];
  //  DDLog(@"dateContent == %@ \nnowInterval  == %f futureInterval == %f \n timeInterVal === %f",dateContent,nowInterval,futureInterval,distanceTime);
    NSString* distanceStr = nil;
    
    if (distanceTime <= 0) {
        distanceStr = @"活动时间已到期";
    }
    else if (distanceTime < 60 * 60 && distanceTime > 0) {
         distanceStr = [NSString stringWithFormat:@"%d分%d秒",minus,second];
    }
    else if (distanceTime <= 24* 60 * 60 && distanceTime >= 60 * 60) {
        distanceStr = [NSString stringWithFormat:@"%d时%d分",hours ,minus];
        
    }
    else {
       // distanceStr = [NSString stringWithFormat:@"%d天%d时%d分",days,hours,minus];
        distanceStr = [NSString stringWithFormat:@"%d天",days];
    }
    
    return distanceStr;
}
//传入 秒  得到 xx:xx:xx
-(NSString *)getHHMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@时%@分%@秒",str_hour,str_minute,str_second];
    
    return format_time;
    
}
//传入 秒  得到  xx分钟xx秒
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@分%@秒",str_minute,str_second];
    
    NSLog(@"format_time : %@",format_time);
    
    return format_time;
}

+ (NSString* )timeForDateFormatStr:(NSString* )dateFormatStr format:(NSString* )format newFormat:(NSString* )newFormat{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSDate * date      = [formatter dateFromString:dateFormatStr];
    NSString *dateTime = [formatter stringFromDate:date];
    DDLog(@"date === %@  dateTime == %@",date,dateTime);
    
    //切割字符串
    NSArray *dateArr = [dateFormatStr componentsSeparatedByString:@" "];
    DDLog(@"dateArr == %@",dateArr);
    if (dateArr.count > 0) {
        return dateArr[0];
    }else{
        return dateFormatStr;
    }
    
    // [formatter setDateStyle:NSDateFormatterMediumStyle];
    //[formatter setTimeStyle:NSDateFormatterShortStyle];
    
    // NSTimeZone* timeZone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    //  [formatter setTimeZone:timeZone];
    // NSLocale* local =[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]  ;
    //[formatter setLocale: local];
    // NSDate *
    // NSDateFormatter *nDateFormat = [[NSDateFormatter alloc]init];
    //  [nDateFormat setDateFormat:newFormat];
    //      [formatter setDateFormat:newFormat];
    
    //    NSDate*  date1  = [nDateFormat dateFromString:dateTime];
    
    //   dateTime = [nDateFormat stringFromDate:date1];
    //   DDLog(@"date === %@  dateTime == %@",date1,dateTime);
    
    //   DDLog(@"date == %@ dateFormatStr == %@  dateTime == %@",date,dateFormatStr,dateTime);
    return dateTime;
}



@end
