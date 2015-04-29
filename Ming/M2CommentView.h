//
//  M2CommentView.h
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-16.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#define UIKeyboardCoViewWillRotateNotification @"UIKeyboardCoViewWillRotateNotification"
//#define UIKeyboardCoViewDidRotateNotification @"UIKeyboardCoViewDidRotateNotification"
@protocol UIKeyboardCoViewDelegate;
@interface M2CommentView : UIView

@property (nonatomic,assign) BOOL isRotating;

@property(nonatomic,assign)id<UIKeyboardCoViewDelegate> delegate;
@end
@protocol UIKeyboardCoViewDelegate <NSObject>

@optional

- (void) keyboardCoViewWillAppear:(M2CommentView*)keyboardCoView;

- (void) keyboardCoViewDidAppear:(M2CommentView*)keyboardCoView;

- (void) keyboardCoViewWillDisappear:(M2CommentView*)keyboardCoView;

- (void) keyboardCoViewDidDisappear:(M2CommentView*)keyboardCoView;

@end
