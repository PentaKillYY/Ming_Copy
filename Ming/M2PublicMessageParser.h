//
//  M2PublicMessageParser.h
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-9.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2BaseHttpParser.h"

@interface M2PublicMessageParser : M2BaseHttpParser

+(instancetype)sharedHttpParser;
-(void)getTop5PublicMessageOnCompletion:(JSONArrayResponse)completionBlock;
-(void)getMySummaryCountOnCompletion:(JSONDictResponse)completionBlock;
-(void)getGetPublicMessagePublicTime:(NSString*)publicTime OnCompletion:(JSONArrayResponse)completionBlock;

@end
