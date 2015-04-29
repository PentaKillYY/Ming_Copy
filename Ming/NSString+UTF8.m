//
//  NSString.m
//  Ming
//
//  Created by HuangLuyang on 14-12-9.
//  Copyright (c) 2014年 xiaowei wu. All rights reserved.
//

#import "NSString+UTF8.h"

@implementation NSString (OAURLEncodingAdditions)
- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    
    return result;
}


- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)self, CFSTR(""),kCFStringEncodingUTF8));CFSTR(""),kCFStringEncodingUTF8;
    return result;
}

@end
