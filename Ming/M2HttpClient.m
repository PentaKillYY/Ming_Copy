//
//  M2HttpClient.m
//  Ming2.0
//
//  Created by xiaoweiwu on 12/3/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import "M2HttpClient.h"
#import <AFJSONRequestOperation.h>
#import "Constant.h"

@implementation M2HttpClient

+(instancetype)sharedHttpClient{
    static M2HttpClient *sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient=[[M2HttpClient alloc]initWithBaseURL:[NSURL URLWithString:kHttpBaseUrlString]];
    });
    return sharedClient;
}

-(instancetype)initWithBaseURL:(NSURL *)url{
    self=[super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

@end
