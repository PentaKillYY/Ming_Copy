//
//  M2BaseHttpParser.m
//  Ming2.0
//
//  Created by xiaoweiwu on 12/3/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import "M2BaseHttpParser.h"
#import "M2HttpClient.h"
#import <SVProgressHUD.h>
#import <Reachability.h>
#import "M2NetworkEngine.h"
#import "M2SearchHUD.h"
#import "AppDelegate.h"
#import "M2LoadHUD.h"

@implementation M2BaseHttpParser

#pragma mark ====Get Post Request========
/**
 *  Get请求
 *
 *  @param path            路径
 *  @param parameters      参数
 *  @param completionBlock 完成回调
 */
-(void)getPath:(NSString *)path withParameters:(NSDictionary *)parameters onCompletion:(JSONResponse)completionBlock{
    if (![self checkReachability]) {
        [[M2SearchHUD sharedHUD] dismiss];
        return;
    }
    
    if (!_hideHUD) {
        [[M2LoadHUD sharedHUD] show];
    }
    
    [[M2HttpClient sharedHttpClient]getPath:path parameters:parameters  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json;
        if ([responseObject respondsToSelector:@selector(objectAtIndex:)]) {
            json=[responseObject objectAtIndex:0];
        }else{
            json=(NSDictionary *)responseObject;
        }
        
        completionBlock(json);
        [[M2LoadHUD sharedHUD] dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code==-1001) {
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            [appDelegate.window makeToast:NSLocalizedString(@"timeout", @"") duration:3 position:@"center"];
        }
        NSLog(@"Request Error:%@",error);
        [[M2LoadHUD sharedHUD] dismiss];
        [[M2SearchHUD sharedHUD] dismiss];
    }];
}

/**
 *  post请求
 *
 *  @param path            路径
 *  @param parameters      参数
 *  @param completionBlock 回调
 */
-(void)postPath:(NSString *)path withParameters:(NSDictionary *)parameters onCompletion:(JSONResponse)completionBlock{
    if (![self checkReachability]) {
        [[M2SearchHUD sharedHUD] dismiss];
        return;
    }
    
    if (!_hideHUD) {
//        [[M2LoadHUD sharedHUD] show];
        [[M2LoadHUD sharedHUD] show];

    }
    
    [[M2HttpClient sharedHttpClient]postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseArray=(NSArray *)responseObject;
        if ([responseArray count]==1) {
            completionBlock(responseObject[0]);
        }else if ([responseArray count]==0){
            
        }else{
            completionBlock(responseObject);
        }
        [[M2LoadHUD sharedHUD] dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code==-1001) {
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            [appDelegate.window makeToast:NSLocalizedString(@"timeout", @"") duration:3 position:@"center"];
        }
        
        NSLog(@"Request Error:%@",error);
//        [[M2LoadHUD sharedHUD] dismiss];
        [[M2LoadHUD sharedHUD] dismiss];
        [[M2SearchHUD sharedHUD] dismiss];

    }];
}

/**
 *  post请求
 *
 *  @param path            路径
 *  @param parameters      参数
 *  @param completionBlock 成功回调
 *  @param failureBlock    失败回调
 */
-(void)postPath:(NSString *)path withParameters:(NSDictionary *)parameters onCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock{
    if (![self checkReachability]) {
        [[M2SearchHUD sharedHUD] dismiss];
        return;
    }
    
    if (!_hideHUD) {
//        [[M2LoadHUD sharedHUD] show];
        [[M2LoadHUD sharedHUD] show];

    }
    

    [[M2HttpClient sharedHttpClient]postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseArray=(NSArray *)responseObject;
        if ([responseArray count]==1) {
            completionBlock(responseObject[0]);
        }else if ([responseArray count]==0){
            
        }else{
            completionBlock(responseObject);
        }
        [[M2LoadHUD sharedHUD] dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code==-1001) {
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            [appDelegate.window makeToast:NSLocalizedString(@"timeout", @"") duration:3 position:@"center"];
        }
        
        NSLog(@"Request Error:%@",error);
//        [[M2LoadHUD sharedHUD] dismiss];
        [[M2LoadHUD sharedHUD] dismiss];
        [[M2SearchHUD sharedHUD] dismiss];
        failureBlock(@{kKey:@0});
    }];
}

/**
 *  post请求
 *
 *  @param path            路径
 *  @param parameters      参数
 *  @param completionBlock 成功回调
 *  @param failureBlock    失败回调
 *  @param noConnectBlock  无网络回调
 */
-(void)postPath:(NSString *)path
 withParameters:(NSDictionary *)parameters
   onCompletion:(JSONResponse)completionBlock
      onFailure:(JSONResponse)failureBlock
    onNoConnect:(JSONResponse)noConnectBlock{
    if (![self checkReachability]) {
        [[M2SearchHUD sharedHUD] dismiss];
        noConnectBlock(nil);
        return;
    }
    
    if (!_hideHUD) {
//        [[M2LoadHUD sharedHUD] show];
        [[M2LoadHUD sharedHUD] show];
    }
    
    [[M2HttpClient sharedHttpClient]postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseArray=(NSArray *)responseObject;
        if ([responseArray count]==1) {
            completionBlock(responseObject[0]);
        }else if ([responseArray count]==0){
            
        }else{
            completionBlock(responseObject);
        }
        [[M2LoadHUD sharedHUD] dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code==-1001) {
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            [appDelegate.window makeToast:NSLocalizedString(@"timeout", @"") duration:3 position:@"center"];
        }
        
        NSLog(@"Request Error:%@",error);
//        [[M2LoadHUD sharedHUD] dismiss];
        [[M2LoadHUD sharedHUD] dismiss];
        [[M2SearchHUD sharedHUD] dismiss];
        failureBlock(@{kKey:@0});
        
    }];
}

/**
 *  post 请求
 *
 *  @param path            路径
 *  @param parameters      参数
 *  @param completionBlock 成功回调传数组
 */
-(void)postPath:(NSString *)path withParameters:(NSDictionary *)parameters onArrayCompletion:(JSONArrayResponse)completionBlock{
    if (![self checkReachability]) {
        [[M2SearchHUD sharedHUD] dismiss];
        return;
    }
    
    if (!_hideHUD) {
//        [[M2LoadHUD sharedHUD] show];
        [[M2LoadHUD sharedHUD] show];

    }
    [[M2HttpClient sharedHttpClient]postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseArray=(NSArray *)responseObject;
        if ([responseArray count]==0){
            completionBlock(responseArray);
        }else{
            completionBlock(responseObject);
        }
        [[M2LoadHUD sharedHUD] dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code==-1001) {
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            [appDelegate.window makeToast:NSLocalizedString(@"timeout", @"") duration:3 position:@"center"];
        }
        NSLog(@"Request Error:%@",error);
//        [[M2LoadHUD sharedHUD] dismiss];
        [[M2LoadHUD sharedHUD] dismiss];
        [[M2SearchHUD sharedHUD] dismiss];

    }];
}


-(void)postPath:(NSString *)path withParameters:(NSDictionary *)parameters onDictCompletion:(JSONDictResponse)completionBlock{
    if (![self checkReachability]) {
        [[M2SearchHUD sharedHUD] dismiss];
        return;
    }
    
    if (!_hideHUD) {
//        [[M2LoadHUD sharedHUD] show];
        [[M2LoadHUD sharedHUD] show];

    }
    [[M2HttpClient sharedHttpClient]postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict=(NSDictionary *)responseObject;
        completionBlock(responseDict);
        [[M2LoadHUD sharedHUD] dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code==-1001) {
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            [appDelegate.window makeToast:NSLocalizedString(@"timeout", @"") duration:3 position:@"center"];
        }
        NSLog(@"Request Error:%@",error);
//        [[M2LoadHUD sharedHUD] dismiss];
        [[M2SearchHUD sharedHUD] dismiss];
        [[M2SearchHUD sharedHUD] dismiss];
    }];
}

/**
 *  获取未审批消息
 *
 *  @param path            路径
 *  @param parameters      参数
 *  @param completionBlock 回调
 */
-(void)postMessagePath:(NSString *)path
        withParameters:(NSDictionary *)parameters
          onCompletion:(JSONResponse)completionBlock
{

    if (![self checkReachability]) {
        [[M2SearchHUD sharedHUD] dismiss];
        if ([path isEqualToString:@"GetWaitingApproval"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NetErrorNotification" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"StstemDoneNetErrorNotification" object:nil];
        }

        return;
    }

    [[M2HttpClient sharedHttpClient]postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseArray=(NSArray *)responseObject;
        
        completionBlock(responseArray);
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code==-1001) {
//            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
//            [appDelegate.window makeToast:@"Request Timeout" duration:3 position:@"center"];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"timeout", @"")];
            if ([path isEqualToString:@"GetWaitingApproval"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TimeoutNotification" object:nil];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SystemDoneTimeoutNotification" object:nil];
            }
            
        }
        NSLog(@"Request Error:%@",error);
        [[M2SearchHUD sharedHUD] dismiss];

    }];

}

/**
 *  审批
 *
 *  @param path            路径
 *  @param parameters      参数
 *  @param completionBlock 回调
 */
-(void)handleMessagePath:(NSString *)path withParameters:(NSDictionary *)parameters onCompletion:(JSONResponse)completionBlock
{
    if (![self checkReachability]) {
        [[M2SearchHUD sharedHUD] dismiss];
        return;
    }

    [[M2HttpClient sharedHttpClient]postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseArray=(NSArray *)responseObject;
        completionBlock(responseArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code==-1001) {
//            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
//            [appDelegate.window makeToast:@"Request Timeout" duration:3 position:@"center"];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"timeout", @"")];
        }
        NSLog(@"Request Error:%@",error);
        [[M2SearchHUD sharedHUD] dismiss];

    }];
}

/**
 *  批量审批
 *
 *  @param path            路径
 *  @param parameters      参数
 *  @param completionBlock 回调
 */
-(void)batchHandleMessagePath:(NSString *)path
               withParameters:(NSDictionary *)parameters
                 onCompletion:(JSONResponse)completionBlock
{

   M2HttpClient* client= [[M2HttpClient alloc] initWithBaseURL:[NSURL URLWithString:kHttpBaseUrlString]];
    [client postPath:path parameters:parameters success:^(AFHTTPRequestOperation* operation,id responseObject){
        NSArray *responseArray=(NSArray *)responseObject;
        completionBlock(responseArray);
    } failure:^(AFHTTPRequestOperation* operation,NSError* error){
        if (error.code==-1001) {
//            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
//            [appDelegate.window makeToast:@"Request Timeout" duration:3 position:@"center"];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"timeout", @"")];
        }
     }];
}

/**
 *  上传图片
 *
 *  @param image           图片
 *  @param path            路径
 *  @param parameters      参数
 *  @param completionBlock 回调
 */
-(void)upLoadImage:(UIImage *)image ToPath:(NSString *)path WithParamenters:(NSDictionary *)parameters OnCompletion:(JSONDictResponse)completionBlock{
    M2HttpClient *httpClient=[M2HttpClient sharedHttpClient];
    
    NSMutableURLRequest *request=[httpClient multipartFormRequestWithMethod:@"POST" path:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.7) name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpg"];
    }];
    
    AFHTTPRequestOperation *operation=[httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        completionBlock(responseObject[0]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code==-1001) {
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            [appDelegate.window makeToast:NSLocalizedString(@"timeout", @"") duration:3 position:@"center"];
        }
        NSLog(@"Request Error:%@",error);
    }];
    
    [operation start];
}


/**
 *  检查网络
 *
 *  @return Bool
 */
-(BOOL)checkReachability{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"网络异常", @"") message:NSLocalizedString(@"检查网络连接", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"confirm", @"") otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    return YES;

}

/**
 *  下载文件
 *
 *  @param url      路径
 *  @param filePath 文件路径
 *
 *  @return NetworkOperation
 */
-(MKNetworkOperation *)downLoadFileFromURL:(NSString *)url toFile:(NSString *)filePath{
    M2NetworkEngine *engine=[M2NetworkEngine sharedNetworkEngine];
    MKNetworkOperation *op=[engine operationWithURLString:url
                                                   params:nil
                                               httpMethod:@"GET"];
    
    [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:filePath
                                                            append:YES]];
    [engine enqueueOperation:op];
    return op;
}

@end
