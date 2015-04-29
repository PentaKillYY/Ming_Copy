//
//  NSDate+CurrentDate.h
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-6.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CurrentDate)

-(NSString *)getCurrentDateString;
+(NSDate *)dateFromString:(NSString *)dateString;
-(NSDate *)normalize;

@end
