//
//  SystemMessageParser.m
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-11.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "SystemMessageParser.h"
#import "UserInfo.h"
#import "Message.h"

@implementation SystemMessageParser

+(instancetype)sharedHttpParser{
    static SystemMessageParser *sharedParser;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedParser=[[SystemMessageParser alloc]init];
    });
    return sharedParser;
}

/**
 *  请求未审批信息
 *
 *  @param systemIds       系统id
 *  @param refreshTime     刷新时间
 *  @param completionBlock completionBlock
 */
-(void)postSystemMessagesystemId:(NSString*)systemIds startTime:(NSString*)refreshTime OnCompletion:(JSONArrayResponse)completionBlock 
{
//    NSDictionary *parameter=@{@"token":[UserInfo sharedUserInfo].token,@"employeeNO":[UserInfo sharedUserInfo].account,@"systemIds":systemIds,@"startTime":refreshTime};
//    [self postMessagePath:@"GetSystemMessage" withParameters:parameter onCompletion:^(id json){
//        NSArray *jsonArray=(NSArray *)json;
//        completionBlock(jsonArray);
//    }];
    NSString *lanaguage=[NSLocalizedString(@"lang", @"") isEqualToString:@"en-us"]?@"1":@"0";
    NSDictionary *parameter=@{@"token":[UserInfo sharedUserInfo].token,@"employeeNO":[UserInfo sharedUserInfo].employeeNo,@"systemIds":systemIds,@"startTime":refreshTime,@"Lan":lanaguage};
    [self postMessagePath:@"GetWaitingApproval" withParameters:parameter onCompletion:^(id json){
        NSArray *jsonArray=(NSArray *)json;
        completionBlock(jsonArray);
    }];
}

/**
 *  请求已审批信息
 *
 *  @param refreshTime     刷新时间
 *  @param completionBlock completionBlock
 */
-(void)postSystemMessageDonestartTime:(NSString*)refreshTime OnCompletion:(JSONArrayResponse)completionBlock
{
//    NSDictionary *parameter = @{@"token":[UserInfo sharedUserInfo].token,@"employeeNO":[UserInfo sharedUserInfo].employeeNo,@"systemIds":@"",@"startTime":refreshTime};
//    [self postMessagePath:@"GetSystemMessageDone" withParameters:parameter onCompletion:^(id json){
//        NSArray *jsonArray=(NSArray *)json;
//        completionBlock(jsonArray);
//    }];
    NSDate* now = [NSDate date];
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //fmt.dateFormat = @"yyyy-MM-dd a HH:mm:ss EEEE";
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString* dateString = [fmt stringFromDate:now];
    NSLog(@"\n%@", dateString);
    NSString *lanaguage=[NSLocalizedString(@"lang", @"") isEqualToString:@"en-us"]?@"1":@"0";
    NSDictionary *parameter = @{@"token":[UserInfo sharedUserInfo].token,@"employeeNO":[UserInfo sharedUserInfo].employeeNo,@"systemIds":@"",@"startTime":refreshTime ,@"endTime":dateString, @"pageNo":@"999", @"pageSize":@"1" ,@"lan":lanaguage};
    [self postMessagePath:@"GetDoneApproval" withParameters:parameter onCompletion:^(id json){
        NSArray *jsonArray=(NSArray *)json;
        completionBlock(jsonArray);
    }];
}

/**
 *  审批消息
 *
 *  @param systemId        系统id
 *  @param msgID           消息id
 *  @param action          操作
 *  @param comment         审批内容
 *  @param completionBlock completionBlock
 */
-(void)handleSystemMessageSystemId:(NSString *)systemId MsgID:(NSString *)msgID Action:(NSString *)action Comment:(NSString *)comment OnCompletion:(JSONArrayResponse)completionBlock
{
    NSLog(@"comment:%@",comment);
    NSDictionary *parameter = @{@"token":[UserInfo sharedUserInfo].token,@"employeeNO":[UserInfo sharedUserInfo].employeeNo,@"systemId":systemId,@"msgID":msgID,@"action":action,@"comment":comment};
    [self handleMessagePath:@"HandleSystemMessage" withParameters:parameter onCompletion:^(id json){
        NSArray *jsonArray=(NSArray *)json;
        completionBlock(jsonArray);
    }];
}

/**
 *  批量审批
 *
 *  @param systemId        系统id
 *  @param msgID           消息id
 *  @param action          操作
 *  @param comment         审批内容
 *  @param completionBlock completionBlock
 */
-(void)batchHandleSystemMessageSystemId:(NSString *)systemId MsgID:(NSString *)msgID Action:(NSString *)action Comment:(NSString *)comment OnCompletion:(JSONArrayResponse)completionBlock
{
    NSDictionary *parameter = @{@"token":[UserInfo sharedUserInfo].token,@"employeeNO":[UserInfo sharedUserInfo].employeeNo,@"systemId":systemId,@"msgID":msgID,@"action":action,@"comment":comment};
    [self batchHandleMessagePath:@"HandleSystemMessage" withParameters:parameter onCompletion:^(id json){
        NSArray *jsonArray=(NSArray *)json;
        completionBlock(jsonArray);
    }];
}

@end
