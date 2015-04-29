//
//  NSDate+CurrentDate.m
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-6.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "NSDate+CurrentDate.h"

@implementation NSDate (CurrentDate)

-(NSString *)getCurrentDateString{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:[self normalize]];
}

+(NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:dateString];
}

-(NSDate *)normalize{
    NSCalendar *calendar=[NSCalendar currentCalendar];
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents* components = [calendar components:flags
                                               fromDate:self];
    [components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [calendar  dateFromComponents:components];
}

@end
