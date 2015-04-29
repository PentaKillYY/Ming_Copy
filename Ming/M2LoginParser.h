//
//  M2LoginParser.h
//  Ming2.0
//
//  Created by xiaoweiwu on 12/3/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import "M2BaseHttpParser.h"

@interface M2LoginParser : M2BaseHttpParser

+(instancetype)sharedHttpParser;
-(void)loginWithUserInfoDictionary:(NSDictionary *)authInfo onCompletion:(JSONResponse)completionBlock;
-(void)validateTokeOnCompletion:(JSONResponse)completionBlock;
-(void)validateTokeOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock;
-(void)validateTokeOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock onNoConnect:(JSONResponse)noConnectBlock;

-(void)getEmployeeInfoOnCompletion:(JSONResponse)completionBlock;
-(void)upLoadAvatarImage:(UIImage *)avator OnCompletion:(JSONDictResponse)completionBlock;
-(void)getSystemListOnCompletion:(JSONArrayResponse)completionBlock;
-(void)getVersionInfoOnCompletion:(JSONResponse)completionBlock;
-(void)getVersionInfoOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock;
-(void)getVersionInfoOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock onNoConnect:(JSONResponse)noConnectBlock;

@end
