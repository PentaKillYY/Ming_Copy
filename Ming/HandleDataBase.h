//
//  HandleDataBase.h
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-27.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandleDataBase : NSObject

+(NSInteger)calculateCacheSize;
+(void)cleanDataBaseCache;
+(long long) fileSizeAtPath:(NSString*) filePath;

@end
