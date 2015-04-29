//
//  M2HttpClient.h
//  Ming2.0
//
//  Created by xiaoweiwu on 12/3/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//
#import "AFHTTPClient.h"

@interface M2HttpClient : AFHTTPClient
+(instancetype)sharedHttpClient;
@end
