//
//  M2UtilityParser.m
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-13.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2UtilityParser.h"
#import "UserInfo.h"
#import "M2SearchHUD.h"
#import "AppDelegate.h"

@implementation M2UtilityParser

+(instancetype)sharedParser{
    static M2UtilityParser *sharedParser;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedParser=[[M2UtilityParser alloc]init];
    });
    return sharedParser;
}

-(void)getEmployeeInfoWithKeyWord:(NSString *)keyWord onCompletion:(JSONArrayResponse)completeBlock{
    self.hideHUD=YES;
    NSDictionary *parameters=@{@"token":[UserInfo sharedUserInfo].token,@"employeeNo":[UserInfo sharedUserInfo].employeeNo,@"key":keyWord};
    [self postPath:kEmployeeInfoQuery withParameters:parameters onArrayCompletion:^(NSArray *json) {
        [[M2SearchHUD sharedHUD] dismiss];
        completeBlock(json);
    }];
}

-(void)getEmployeeAssetOnCompletion:(JSONArrayResponse)completeBlock{
    self.hideHUD=YES;
    NSDictionary *parameters=@{@"token":[UserInfo sharedUserInfo].token,@"employeeNo":[UserInfo sharedUserInfo].employeeNo};
    [self postPath:kGetEmployeeAsset withParameters:parameters onArrayCompletion:^(NSArray *json) {
        [[M2SearchHUD sharedHUD] dismiss];
        completeBlock(json);
    }];
}

-(void)getSharedFileOnCompletion:(JSONArrayResponse)completeBlock{
     NSDictionary *parameters=@{@"token":[UserInfo sharedUserInfo].token,@"employeeNo":[UserInfo sharedUserInfo].employeeNo};
    [self postPath:kGetSharedFile withParameters:parameters onArrayCompletion:^(NSArray *json) {
        completeBlock(json);
    }];
}

-(void)getShareFileWithFolderPath:(NSString *)folderPath OnCompletion:(JSONArrayResponse)completeBlock{
    NSDictionary *parameters=@{@"token":[UserInfo sharedUserInfo].token,@"employeeNo":[UserInfo sharedUserInfo].employeeNo,@"folderPath":folderPath};
    [self postPath:kGetSharedFile withParameters:parameters onArrayCompletion:^(NSArray *json) {
        completeBlock(json);
    }];
}

-(void)searchFileWithKeyWord:(NSString *)key onCompletion:(JSONArrayResponse)completeBlock{
    self.hideHUD=YES;
    NSDictionary *parameters=@{@"token":[UserInfo sharedUserInfo].token,@"employeeNo":[UserInfo sharedUserInfo].employeeNo,@"key":key};
    [self postPath:kSearchFile withParameters:parameters onArrayCompletion:^(NSArray *json) {
        completeBlock(json);
    }];
}

-(void)addFileLogForUrl:(NSString *)urlStr{
    self.hideHUD=YES;
    NSDictionary *parameters=@{@"token":[UserInfo sharedUserInfo].token,@"employeeNo":[UserInfo sharedUserInfo].employeeNo,@"fileUrl":urlStr,@"actionType":@2};
    [self postPath:kAddFileLog withParameters:parameters onCompletion:^(id json) {
        NSLog(@"file Log response:%@",json);
    }];
}

-(void)downloadFileFromUrl:(NSString *)url onCompletion:(downLoadResponse)completeBlock andProgressBlock:(Progress)progressBlock{
    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFURLConnectionOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *fileNameString=[url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileNameString];
    
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        progressBlock(bytesRead,(NSInteger)totalBytesRead,(NSInteger)totalBytesExpectedToRead);
    }];
    
    [operation setCompletionBlock:^{
        completeBlock(filePath);
    }];
    
    [operation start];
}

-(void)getFileFromUrl:(NSString *)url onCompletion:(downLoadResponse)completeBlock andProgressBlock:(progressResponse)progressBlock{
    
//    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSArray *stringArray=[url componentsSeparatedByString:@"/"];

//    NSString *fileNameString=[url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *fileNameString=[stringArray lastObject];
//    NSLog(@"filenameStrng length:%d",fileNameString.length);
    
    if (fileNameString.length>100) {
        fileNameString=[fileNameString substringFromIndex:fileNameString.length-100];
    }
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileNameString];
    
    MKNetworkOperation *operation=[self downLoadFileFromURL:url toFile:filePath];
    [operation onDownloadProgressChanged:^(double progress) {
//        NSLog(@"download progress: %.2f", progress*100.0);
        progressBlock(progress);
    }];
    
    [operation addCompletionHandler:^(MKNetworkOperation* completedRequest) {
        NSLog(@"download file finished!");
        
        completeBlock(filePath);
    }  errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"download file error: %@", err);
        if (err.code==404) {
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            [appDelegate.window makeToast:NSLocalizedString(@"filenotfound", @"") duration:3 position:@"center"];
        }
    }];
}

-(void)getFileFromUrl:(NSString *)url onCompletion:(downLoadResponse)completeBlock andProgressBlock:(progressResponse)progressBlock andfailureBlock:(failureBlock)failure{
    //    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSArray *stringArray=[url componentsSeparatedByString:@"/"];
    
    //    NSString *fileNameString=[url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *fileNameString=[stringArray lastObject];
    //    NSLog(@"filenameStrng length:%d",fileNameString.length);
    
    if (fileNameString.length>100) {
        fileNameString=[fileNameString substringFromIndex:fileNameString.length-100];
    }
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileNameString];
    
    MKNetworkOperation *operation=[self downLoadFileFromURL:url toFile:filePath];
    [operation onDownloadProgressChanged:^(double progress) {
        //        NSLog(@"download progress: %.2f", progress*100.0);
        progressBlock(progress);
    }];
    
    [operation addCompletionHandler:^(MKNetworkOperation* completedRequest) {
        NSLog(@"download file finished!");
        
        completeBlock(filePath);
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"download file error: %@", err);
        if (err.code==404) {
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            [appDelegate.window makeToast:NSLocalizedString(@"filenotfound", @"") duration:3 position:@"center"];
        }
        failure();
    }];
}

@end
