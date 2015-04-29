//
//  Go2Util.h
//  Ming
//
//  Created by xiaoweiwu on 4/28/14.
//  Copyright (c) 2014 xiaowei wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Go2Util : NSObject
+(void)transitionToRootTabBarViewControllerFrom:(UIViewController *)fromController;
+(void)gotoLoginFrom:(UIViewController *)fromController;
+(void)gotoLoginFrom:(UIViewController *)fromController shouldShowUser:(BOOL)shouldShow;

+(void)go2AboutFrom:(UIViewController *)fromController;
+(void)go2HelpFrom:(UIViewController*)fromController;
+(void)go2PersonInfoFrom:(UIViewController*)fromController;
+(void)go2AttendanceFrom:(UIViewController *)fromController withCountStr:(NSString *)countStr;
+(void)go2TimeSheetFrom:(UIViewController *)fromController withCountStr:(NSString *)countStr;
+(void)go2AssetsFrom:(UIViewController *)fromController;
+(void)go2MailSearchFrom:(UIViewController *)fromController;
+(void)go2PHSfrom:(UIViewController*)fromController;
+(void)go2MessageDetailForm:(UIViewController*)fromController responseMessage:(NSMutableArray*)response IntegerNumber:(NSInteger)integerNumber;
+(void)go2MessageDoneDetailFrom:(UIViewController *)fromController responseMessage:(NSMutableArray *)response IntegerNumber:(NSInteger)IntegerNumber Count:(NSInteger)count;
+(void)go2MessageInfoForm:(UIViewController *)fromController;
+(void)go2TravelFrom:(UIViewController*)fromController;
+(void)go2LeaveFrom:(UIViewController *)fromController;
@end
