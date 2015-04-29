//
//  M2TimeSheetViewController.h
//  Ming2.0
//
//  Created by xiaoweiwu on 1/20/14.
//  Copyright (c) 2014 xiaowei wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M3BackViewController.h"

@interface M2TimeSheetViewController :M3BackViewController
@property (nonatomic,strong) NSString *timeSheetCount;
- (IBAction)reloadWebView:(id)sender;

@end
