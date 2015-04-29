//
//  NSString.h
//  Ming
//
//  Created by HuangLuyang on 14-12-9.
//  Copyright (c) 2014年 xiaowei wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (OAURLEncodingAdditions)
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
@end
