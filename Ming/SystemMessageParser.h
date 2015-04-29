//
//  SystemMessageParser.h
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-11.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2BaseHttpParser.h"

@interface SystemMessageParser : M2BaseHttpParser

+(instancetype)sharedHttpParser;
-(void)postSystemMessagesystemId:(NSString*)systemIds startTime:(NSString*)refreshTime OnCompletion:(JSONArrayResponse)completionBlock ;
-(void)postSystemMessageDonestartTime:(NSString*)refreshTime OnCompletion:(JSONArrayResponse)completionBlock;
-(void)handleSystemMessageSystemId:(NSString*)systemId MsgID:(NSString*)msgID Action:(NSString*)action Comment:(NSString*)comment OnCompletion:(JSONArrayResponse)completionBlock;
-(void)batchHandleSystemMessageSystemId:(NSString *)systemId MsgID:(NSString *)msgID Action:(NSString *)action Comment:(NSString *)comment OnCompletion:(JSONArrayResponse)completionBlock;

@end
