//
//  UIWebView.h
//  Shake
//
//  Created by HuangLuyang on 14-12-16.
//  Copyright (c) 2014年 Huang Luyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"
#import "NSString+UTF8.h"
@interface UIWebView (JavaScriptAlert)<CustomIOS7AlertViewDelegate>
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame;
@end
