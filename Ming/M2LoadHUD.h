//
//  M2LoadHUD.h
//  Ming
//
//  Created by wu xiaowei on 14/12/11.
//  Copyright (c) 2014年 xiaowei wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M2LoadHUD : NSObject
@property BOOL isShow;
+(instancetype)sharedHUD;
-(void)show;
-(void)dismiss;
@end
