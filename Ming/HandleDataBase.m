//
//  HandleDataBase.m
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-27.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "HandleDataBase.h"
#import <FMDatabase.h>
#import <FMDatabaseAdditions.h>
#include "sys/stat.h"
#import "UserInfo.h"
@implementation HandleDataBase

/**
 *  计算大小
 *
 *  @return 大小
 */
+(NSInteger)calculateCacheSize
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *userPath = [documentsDir stringByAppendingPathComponent:@"Message.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:userPath];
    NSError *error;
    if (find) {
       return  (int)[self fileSizeAtPath:userPath];
    }else{
        NSLog(@"Failed with message: '%@'.",[error localizedDescription]);
        return 0;
    }
}

/**
 *  清理数据库缓存
 */
+(void)cleanDataBaseCache
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *userPath = [documentsDir stringByAppendingPathComponent:@"Message.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:userPath];
    NSError *error;
    if (find) {
        FMDatabase *db= [FMDatabase databaseWithPath:userPath] ;
        if (![db open]) {
            NSLog(@"Could not open db.");
        }else{
            [db open];
            [db setShouldCacheStatements:YES];
            [db executeUpdate:@"delete from MessageDoneTable"];
            [db executeUpdate:@"delete from PublicTable"];
          
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [UserInfo sharedUserInfo].msgDoneFreshTime = [formatter dateFromString:@""];
            [UserInfo sharedUserInfo].publicFreshTime = [formatter dateFromString:@""];
            [[UserInfo sharedUserInfo] synchronize];

        }
        
    }else{
        NSLog(@"Failed with message: '%@'.",[error localizedDescription]);
    }
}

/**
 *  文件大小
 *
 *  @param filePath 路径
 *
 *  @return 大小
 */
+(long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
@end
