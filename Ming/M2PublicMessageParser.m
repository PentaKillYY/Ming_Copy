//
//  M2PublicMessageParser.m
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-9.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2PublicMessageParser.h"
#import "UserInfo.h"
#import "Message.h"

@implementation M2PublicMessageParser

+(instancetype)sharedHttpParser{
    static M2PublicMessageParser *sharedParser;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedParser=[[M2PublicMessageParser alloc]init];
    });
    return sharedParser;
}

-(void)getTop5PublicMessageOnCompletion:(JSONArrayResponse)completionBlock{
    NSDictionary *parameter=@{@"token":[UserInfo sharedUserInfo].token,@"employeeNO":[UserInfo sharedUserInfo].employeeNo};
    [self postPath:@"GetTop5PublicMessage" withParameters:parameter onCompletion:^(id json) {
        NSArray *jsonArray=(NSArray *)json;
        NSMutableArray *modelArray=[NSMutableArray array];
        for (NSDictionary *dict in jsonArray) {
            NSError *error;
            Message *message=[[Message alloc]initWithDictionary:dict error:&error];
            if (error) {
                NSLog(@"create message model failed:error:%@",[error localizedDescription]);
            }else{
                [modelArray addObject:message];
            }
        }
        completionBlock(modelArray);
    }];
}


-(void)getMySummaryCountOnCompletion:(JSONDictResponse)completionBlock{
    NSDictionary *parameter=@{@"token":[UserInfo sharedUserInfo].token,@"employeeNO":[UserInfo sharedUserInfo].account};
    self.hideHUD=YES;
    [self postPath:@"GetMySummaryCount" withParameters:parameter onCompletion:^(id json) {
        NSDictionary *jsonDict=(NSDictionary *)json;
        completionBlock(jsonDict);
    }];
}

-(void)getGetPublicMessagePublicTime:(NSString*)publicTime OnCompletion:(JSONArrayResponse)completionBlock
{
    NSDictionary *parameter=@{@"token":[UserInfo sharedUserInfo].token,@"employeeNO":[UserInfo sharedUserInfo].employeeNo,@"systemIds":@"",@"startTime":publicTime};
    [self postMessagePath:@"GetPublicMessage" withParameters:parameter onCompletion:^(id json){
        NSArray* jsonArray = (NSArray*)json;
        
        completionBlock(jsonArray);
    }];
}

@end
