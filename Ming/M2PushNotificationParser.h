//
//  M2PushNotificationParser.h
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-31.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2BaseHttpParser.h"

@interface M2PushNotificationParser : M2BaseHttpParser

+(instancetype)sharedHttpParser;
-(void)postUpdateClientAppInfoToken:(NSString*)token OnCompletion:(JSONResponse)completionBlock;

@end
