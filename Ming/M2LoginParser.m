//
//  M2LoginParser.m
//  Ming2.0
//
//  Created by xiaoweiwu on 12/3/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import "M2LoginParser.h"
#import "Constant.h"
#import "UserInfo.h"
#import "NSDictionary+EmployeeInfo.h"

@implementation M2LoginParser

+(instancetype)sharedHttpParser{
    static M2LoginParser *sharedHttpParser;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//单例模式
        sharedHttpParser=[[M2LoginParser alloc]init];
    });
    return sharedHttpParser;
}

/**
 *  判断账号密码
 *
 *  @param authInfo        登陆用户信息，包括账号和密码
 *  @param completionBlock 回调函数
 */
-(void)loginWithUserInfoDictionary:(NSDictionary *)authInfo onCompletion:(JSONResponse)completionBlock{
    NSMutableDictionary *authInfo2=[authInfo mutableCopy];
    [authInfo2 setObject:[NSString stringWithFormat:@"%d",versionCount] forKey:@"versionCount"];
    [authInfo2 setObject:@"IOS" forKey:@"appType"];
    [self postPath:kLoginUrl withParameters:authInfo2 onCompletion:^(NSDictionary *json) {
        completionBlock(json);
    }];
}

-(void)validateTokeOnCompletion:(JSONResponse)completionBlock{
    [self postPath:kTokenUrl withParameters:@{@"token":[UserInfo sharedUserInfo].token,@"employeeNo":[UserInfo sharedUserInfo].employeeNo} onCompletion:^(NSDictionary *json){
        completionBlock(json);
    } onFailure:^(id json) {
        completionBlock(json);
    }];
}

-(void)validateTokeOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock{
    [self postPath:kTokenUrl withParameters:@{@"token":[UserInfo sharedUserInfo].token,@"employeeNo":[UserInfo sharedUserInfo].employeeNo} onCompletion:^(NSDictionary *json){
        completionBlock(json);
    } onFailure:^(id json) {
        failureBlock(json);
    }];

}

-(void)validateTokeOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock onNoConnect:(JSONResponse)noConnectBlock{
    [self postPath:kTokenUrl withParameters:@{@"token":[UserInfo sharedUserInfo].token,@"employeeNo":[UserInfo sharedUserInfo].account} onCompletion:^(NSDictionary *json){
        completionBlock(json);
    } onFailure:^(id json) {
        failureBlock(json);
    } onNoConnect:noConnectBlock];

}


-(void)getEmployeeInfoOnCompletion:(JSONResponse)completionBlock{
    [self postPath:kEmployeeInfo withParameters:@{@"token":[UserInfo sharedUserInfo].token,@"employeeNo":[UserInfo sharedUserInfo].account} onCompletion:^(NSDictionary *json) {
        
        [[UserInfo sharedUserInfo]setWithDict:json];
        [[UserInfo sharedUserInfo]synchronize];
        completionBlock(json);
    }];
}


-(void)getVersionInfoOnCompletion:(JSONResponse)completionBlock{
    [self postPath:kGetVersionInfo withParameters:@{@"appType":@"IOS"} onCompletion:^(id json) {
        completionBlock(json);
    }];
}

-(void)getVersionInfoOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock{
    [self postPath:kGetVersionInfo withParameters:@{@"appType":@"IOS"} onCompletion:^(id json) {
        completionBlock(json);
    } onFailure:^(id json) {
        failureBlock(json);
    }];

}


-(void)getVersionInfoOnCompletion:(JSONResponse)completionBlock onFailure:(JSONResponse)failureBlock onNoConnect:(JSONResponse)noConnectBlock{
    [self postPath:kGetVersionInfo withParameters:@{@"appType":@"IOS"} onCompletion:^(id json) {
        completionBlock(json);
    } onFailure:^(id json) {
        failureBlock(json);
    } onNoConnect:noConnectBlock];

}

-(void)upLoadAvatarImage:(UIImage *)avator OnCompletion:(JSONDictResponse)completionBlock{
    NSDictionary *parameters=@{@"token":[UserInfo sharedUserInfo].token,@"employeeNo":[UserInfo sharedUserInfo].employeeNo};
    [self upLoadImage:avator ToPath:kUploadImage WithParamenters:parameters OnCompletion:^(NSDictionary *json) {
        NSString *avatarUrl=json[@"key"];
//        [UserInfo sharedUserInfo].avatarUrl=[NSString stringWithFormat:kUserImageFormat,avatarUrl];
        
        [UserInfo sharedUserInfo].avatarUrl=avatarUrl;
        [[UserInfo sharedUserInfo] synchronize];
        completionBlock(json);
    }];
}

-(void)getSystemListOnCompletion:(JSONArrayResponse)completionBlock{
    NSDictionary *parameters=@{@"token":[UserInfo sharedUserInfo].token,@"employeeNo":[UserInfo sharedUserInfo].account};
    [self postPath:kGetSystemList withParameters:parameters onArrayCompletion:^(NSArray *json) {
        
        [UserInfo sharedUserInfo].systemList=json;
        [[UserInfo sharedUserInfo] synchronize];
        completionBlock(json);
    }];
}
@end
