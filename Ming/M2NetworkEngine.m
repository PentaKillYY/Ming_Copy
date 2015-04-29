//
//  M2NetworkEngine.m
//  Ming2.0
//
//  Created by xiaoweiwu on 12/22/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import "M2NetworkEngine.h"

@implementation M2NetworkEngine
+(instancetype)sharedNetworkEngine{
    static M2NetworkEngine *sharedEngine;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine=[[M2NetworkEngine alloc]initWithHostName:@"testbed2.mknetworkkit.com" customHeaderFields:@{@"x-client-identifier" :@"iOS"}];
//        [sharedEngine useCache];
    });
    
    return sharedEngine;
}


-(NSString*) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"FlickrImages"];
    return cacheDirectoryName;
}
@end
