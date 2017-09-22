//
//  YMDateTool.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMDateTool : NSObject

//微信过去的时间处理
+ (NSString *)distanceTimeWithBeforeTime:(double)beTime;
//过去时间  和当前时间进行比较  输出字符串为（刚刚几个小时前 几天前 ）
+(NSString *)inputTimeStr:(NSString *)timeStr;
//过去时间处理
+(NSString* )futureTimeWithfutureTime:(NSString* )futureTime format:(NSString*)format;

//将 时间秒数字符串 转成 date
+(NSDate* )getDateWithDateStr:(NSString* )otherDateStr formate:(NSString*)format;
//获取当前时间 格式化 如 yy-MM-dd HH:mm:ss
+(NSDate* )getCurrentDateWithFormat:(NSString* )format;
//把时间字符串转换成NSDate
+ (NSDate *)becomeDateStr:(NSString *)dateStr;

//以固定格式 比较时间的大小
+(int)compareCurrentDateWithOtherDateStr:(NSString* )otherDateStr format:(NSString* )format;
//格式化时间比较
+ (int)compareDateWithFormatDate:(NSDate*)date1 withDate:(NSDate*)date2;
//时间比较
+ (int)compareDate:(NSString*)date01 withDate:(NSString*)date02;


//时间格式化
+ (NSString *)timeForDateFormatted:(NSString*)totalSeconds format:(NSString* )format;

//将原来的时间格式化字符串  转化成 特定 格式的 时间字符串
+ (NSString* )timeForDateFormatStr:(NSString* )dateFormatStr format:(NSString* )format newFormat:(NSString* )newFormat;

//获取时间 年份格式
//+ (NSString* )getYearTimeWithFormatDateTime:(NSString* )dateTime format:(NSString* )format;


@end
