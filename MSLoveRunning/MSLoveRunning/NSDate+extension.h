//
//  NSDate+extension.h
//  doctorDetail
//
//  Created by ww on 16/8/4.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (extension)

- (BOOL)isToday;

+ (NSDate *)dateStartOfDay:(NSDate *)date;


+ (BOOL)isSameDayWithDate:(NSDate*)firstDate andDate:(NSDate*)secondDate;

+ (BOOL)isSameDayWithTime:(NSTimeInterval )firstTime andTime:(NSTimeInterval )secondTime;

+ (NSDate*)acquireTimeFromDate:(NSDate*)date;


+ (NSInteger)acquireWeekDayFromDate:(NSDate*)date;

- (NSInteger)day;
- (NSInteger)month;
- (NSInteger)year;


+(NSDate *)dateFromString:(NSString *)string withDateFormat:(NSString *)format;
-(NSString *)stringFromDateFormat:(NSString *)format;

@end
