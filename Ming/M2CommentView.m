//
//  M2CommentView.m
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-16.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2CommentView.h"

@implementation M2CommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         [self keyboardCoViewCommonInit];
    }
    return self;
}

- (void) keyboardCoViewCommonInit{
    //It's not rotating
    self.isRotating = NO;
    
    //Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
   
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Keyboard notification methods
- (void) keyboardWillAppear:(NSNotification*)notification{
    
    //Get begin, ending rect and animation duration
    CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //Transform rects to local coordinates
    beginRect = [self fixKeyboardRect:beginRect];
    endRect = [self fixKeyboardRect:endRect];
    
    //Get this view begin and end rect
    CGRect selfBeginRect = CGRectMake(beginRect.origin.x,
                                      beginRect.origin.y - self.frame.size.height,
                                      beginRect.size.width,
                                      self.frame.size.height);
    CGRect selfEndingRect = CGRectMake(endRect.origin.x,
                                       endRect.origin.y - self.frame.size.height,
                                       endRect.size.width,
                                       self.frame.size.height);
    
    //Set view position and hidden
    self.frame = selfBeginRect;
    self.alpha = 0.0f;
    [self setHidden:NO];
    
    //If it's rotating, begin animation from current state
//    UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
//    if (self.isRotating){
//        options |= UIViewAnimationOptionBeginFromCurrentState;
//    }
    
    //Start the animation
    if ([self.delegate respondsToSelector:@selector(keyboardCoViewWillAppear:)])
        [self.delegate keyboardCoViewWillAppear:self];
    [UIView animateWithDuration:animDuration
                     animations:^(void){
                         self.frame = selfEndingRect;
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         self.frame = selfEndingRect;
                         self.alpha = 1.0f;
                         if ([self.delegate respondsToSelector:@selector(keyboardCoViewDidAppear:)])
                             [self.delegate keyboardCoViewDidAppear:self];
                     }];
    

    
    
    
}


- (void) keyboardWillDisappear:(NSNotification*)notification{
    
    //Start animation ONLY if the view will not rotate
    if (!self.isRotating){
        
        //Get begin, ending rect and animation duration
        CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat animDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        //Transform rects to local coordinates
        beginRect = [self fixKeyboardRect:beginRect];
        endRect = [self fixKeyboardRect:endRect];
        
        //Get this view begin and end rect
        CGRect selfBeginRect = CGRectMake(beginRect.origin.x,
                                          beginRect.origin.y - self.frame.size.height,
                                          beginRect.size.width,
                                          self.frame.size.height);
        CGRect selfEndingRect = CGRectMake(endRect.origin.x,
                                           endRect.origin.y - self.frame.size.height,
                                           endRect.size.width,
                                           self.frame.size.height);
        
        //Set view position and hidden
        self.frame = selfBeginRect;
        self.alpha = 1.0f;
        
        
//        //Animation options
//        UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
        
        //Animate view
        if ([self.delegate respondsToSelector:@selector(keyboardCoViewWillDisappear:)])
            [self.delegate keyboardCoViewWillDisappear:self];
        [UIView animateWithDuration:animDuration
                         animations:^(void){
                             self.frame = selfEndingRect;
                             self.alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             self.frame = selfEndingRect;
                             self.alpha = 0.0f;
                             [self setHidden:YES];
                             if ([self.delegate respondsToSelector:@selector(keyboardCoViewDidDisappear:)])
                                 [self.delegate keyboardCoViewDidDisappear:self];
                         }];
    }
}

#pragma mark - Private methods
- (CGRect) fixKeyboardRect:(CGRect)originalRect{
    
    //Get the UIWindow by going through the superviews
    UIView * referenceView = self.superview;
    while ((referenceView != nil) && ![referenceView isKindOfClass:[UIWindow class]]){
        referenceView = referenceView.superview;
    }
    
    //If we finally got a UIWindow
    CGRect newRect = originalRect;
    if ([referenceView isKindOfClass:[UIWindow class]]){
        //Convert the received rect using the window
        UIWindow * myWindow = (UIWindow*)referenceView;
        newRect = [myWindow convertRect:originalRect toView:self.superview];
    }
    
    //Return the new rect (or the original if we couldn't find the Window -> this should never happen if the view is present)
    return newRect;
}

@end
