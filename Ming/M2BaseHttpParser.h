//
//  M2BaseHttpParser.h
//  Ming2.0
//
//  Created by xiaoweiwu on 12/3/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFJSONRequestOperation.h>
#import <MKNetworkKit.h>

typedef void(^JSONResponse)(id json);
typedef void(^JSONDictResponse)(NSDictionary *json);
typedef void(^JSONArrayResponse)(NSArray *json);

@interface M2BaseHttpParser : NSObject
@property (nonatomic,assign) BOOL hideHUD;
-(void)getPath:(NSString *)path
withParameters:(NSDictionary *)parameters
  onCompletion:(JSONResponse)completionBlock;

-(void)postPath:(NSString *)path
 withParameters:(NSDictionary *)parameters
   onCompletion:(JSONResponse)completionBlock;

-(void)postPath:(NSString *)path
 withParameters:(NSDictionary *)parameters
   onCompletion:(JSONResponse)completionBlock
      onFailure:(JSONResponse)failureBlock;


-(void)postPath:(NSString *)path
 withParameters:(NSDictionary *)parameters
   onCompletion:(JSONResponse)completionBlock
      onFailure:(JSONResponse)failureBlock
    onNoConnect:(JSONResponse)noConnectBlock;



-(void)postPath:(NSString *)path
        withParameters:(NSDictionary *)parameters
        onArrayCompletion:(JSONArrayResponse)completionBlock;


-(void)postPath:(NSString *)path
        withParameters:(NSDictionary *)parameters
        onDictCompletion:(JSONDictResponse)completionBlock;


-(void)postMessagePath:(NSString *)path
 withParameters:(NSDictionary *)parameters
   onCompletion:(JSONResponse)completionBlock;

-(void)handleMessagePath:(NSString *)path
        withParameters:(NSDictionary *)parameters
          onCompletion:(JSONResponse)completionBlock;

-(void)batchHandleMessagePath:(NSString *)path
          withParameters:(NSDictionary *)parameters
            onCompletion:(JSONResponse)completionBlock;

-(void)upLoadImage:(UIImage *)Image
            ToPath:(NSString *)path
            WithParamenters:(NSDictionary *)parameters
      OnCompletion:(JSONDictResponse)completionBlock;

-(MKNetworkOperation*)downLoadFileFromURL:(NSString *)url toFile:(NSString *)filePath;
@end
