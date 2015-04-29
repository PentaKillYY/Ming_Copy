//
//  UIWebView.m
//  Shake
//
//  Created by HuangLuyang on 14-12-16.
//  Copyright (c) 2014年 Huang Luyang. All rights reserved.
//

#import "UIWebView+JavaScriptAlert.h"

@implementation UIWebView (JavaScriptAlert)

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame {
    // Here we need to pass a full frame
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView:[message URLDecodedString]]];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects: nil]];
    [alertView setDelegate:self];
    
    // [alertView setUseMotionEffects:true];
    // And launch the dialog
    
    [alertView show];
    NSLog(@"消息%@",message);
    if ([self calculateSize:[message URLDecodedString]].height >30) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            [NSThread sleepForTimeInterval:5];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [alertView close];
            });
        });
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            [NSThread sleepForTimeInterval:3];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [alertView close];
            });
        });
    }
}

- (UIView *)createDemoView:(NSString*)hudText
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
    label.backgroundColor = [UIColor clearColor];
    label.text = hudText;
    [label setNumberOfLines:0];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    CGSize labelSize = [self calculateSize:hudText];
    
    label.textAlignment = NSTextAlignmentLeft;
    label.frame= CGRectMake(10, 10, labelSize.width, labelSize.height);
    
    return label;
}

- (CGSize)calculateSize:(NSString*)contentText{
    NSLog(@"calculateSize");
    CGSize titleSize;
    NSRange range2 = [contentText rangeOfString:@"\n"];
    if (range2.location !=  NSNotFound) {
        NSArray *textComps = [contentText componentsSeparatedByString:@"\n"];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle.copy};
            for (int i = 0; i < [textComps count]; i++) {
                CGSize tempSize = [[textComps objectAtIndex:i] boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                titleSize.height += tempSize.height;
                if (tempSize.width >= titleSize.width) {
                    titleSize.width = tempSize.width;
                }
            }
            
        }else{
            for (int i = 0; i < [textComps count]; i++) {
                CGSize tempSize = [contentText sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                titleSize.height += tempSize.height;
                if (tempSize.width >= titleSize.width) {
                    titleSize.width = tempSize.width;
                }
            }
        }
    }else{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle.copy};
            titleSize = [contentText boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        }else{
            titleSize = [contentText sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        }
        
    }
    return titleSize;
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    [alertView close];
}
@end
