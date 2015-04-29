//
//  UINavigationController+CustomTransition.h
//  yushan
//
//  Created by wu xiaowei on 13-5-4.
//  Copyright (c) 2013年 YuLing-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (CustomTransition)
-(void)pushViewControllerWithCustomAnimation:(UIViewController *)viewController;
-(void)popViewControllerDoCustomAnimation;
-(void)popToRootViewControllerDoCustomAnimation;
@end
