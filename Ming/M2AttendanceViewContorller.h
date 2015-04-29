//
//  M2AttendanceViewContorllerViewController.h
//  Ming2.0
//
//  Created by xiaoweiwu on 1/20/14.
//  Copyright (c) 2014 xiaowei wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M3BackViewController.h"
@interface M2AttendanceViewContorller : M3BackViewController
@property (nonatomic,strong) NSString *attendaceCount;
- (IBAction)reloadWebView:(id)sender;
@end
