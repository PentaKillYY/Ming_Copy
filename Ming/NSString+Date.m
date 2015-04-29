//
//  NSString+Date.m
//  Ming2.0
//
//  Created by xiaoweiwu on 12/24/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

-(NSString *)getYearString{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    NSDate *date=[dateFormatter dateFromString:self];
    dateFormatter.dateFormat=@"yyyy-MM-dd";
    return [dateFormatter stringFromDate:date];
}

@end
