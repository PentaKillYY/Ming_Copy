//
//  M2UtilityParser.h
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-13.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2BaseHttpParser.h"
typedef void (^Progress)(NSInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead);

typedef void (^downLoadResponse)(NSString *filePath);

typedef  void (^progressResponse)(double progess);

typedef void (^failureBlock)();

@interface M2UtilityParser : M2BaseHttpParser
+(instancetype)sharedParser;
-(void)getEmployeeInfoWithKeyWord:(NSString *)keyWord onCompletion:(JSONArrayResponse)completeBlock;
-(void)getEmployeeAssetOnCompletion:(JSONArrayResponse)completeBlock;
-(void)getSharedFileOnCompletion:(JSONArrayResponse)completeBlock;

-(void)getShareFileWithFolderPath:(NSString *)folderPath OnCompletion:(JSONArrayResponse)completeBlock;

-(void)searchFileWithKeyWord:(NSString *)key onCompletion:(JSONArrayResponse)completeBlock;
-(void)addFileLogForUrl:(NSString *)urlStr;

-(void)downloadFileFromUrl:(NSString *)url onCompletion:(downLoadResponse)completeBlock andProgressBlock:(Progress)progressBlock;

-(void)getFileFromUrl:(NSString *)url onCompletion:(downLoadResponse)completeBlock andProgressBlock:(progressResponse)progressBlock;
-(void)getFileFromUrl:(NSString *)url onCompletion:(downLoadResponse)completeBlock andProgressBlock:(progressResponse)progressBlock andfailureBlock:(failureBlock)failure;

@end
