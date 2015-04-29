//
// Created by xiaoweiwu on 4/28/14.
// Copyright (c) 2014 xiaowei wu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface M3BaseViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *backBarButtonItem;
-(void)updateAppreance;
-(void)updateNavBarItem;
-(void)updateNavigationBar;
- (IBAction)backAction:(id)sender;
-(void)setTabBarItemWithImage:(UIImage *)image withSelectedImage:(UIImage *)selImage;
@end