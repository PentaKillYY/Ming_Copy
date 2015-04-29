//
//  M2PushNotificationParser.m
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-31.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2PushNotificationParser.h"

@implementation M2PushNotificationParser
+(instancetype)sharedHttpParser{
    static M2PushNotificationParser *sharedParser;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedParser=[[M2PushNotificationParser alloc]init];
    });
    
    return sharedParser;
}

/**
 *  向业务服务器提交推送设备令牌
 *
 *  @param token           设备令牌
 *  @param completionBlock completionBlock description
 */
-(void)postUpdateClientAppInfoToken:(NSString*)token OnCompletion:(JSONResponse)completionBlock
{
    if ([UserInfo sharedUserInfo].deviceToken != nil) {
        NSDictionary *parameter = @{@"token":token,@"appType":@"IOS",@"notifictionUrl":[UserInfo sharedUserInfo].deviceToken,@"enableReceiveNotification":@"true",@"systemIDs":@""};
    
        [self postPath:@"UpdateClientAppInfo" withParameters:parameter onCompletion:^(NSDictionary *json) {
        }];
    }
}
@end
