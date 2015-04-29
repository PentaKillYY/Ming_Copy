//
//  UINavigationController+CustomTransition.m
//  yushan
//
//  Created by wu xiaowei on 13-5-4.
//  Copyright (c) 2013年 YuLing-Tech. All rights reserved.
//

#import "UINavigationController+CustomTransition.h"

@implementation UINavigationController (CustomTransition)
-(void)pushViewControllerWithCustomAnimation:(UIViewController *)viewController{
    
    /*
    CATransition *transition=[CATransition animation];
    transition.duration=0.5;
    transition.type=kCATransitionReveal;
    transition.subtype=kCATransitionFromTop;
  //  transition.type=kCATransitionPush;
  //  transition.subtype=kCATransitionFromTop;
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self pushViewController:viewController animated:NO];
     
     */
    
    
    [UIView transitionWithView:self.view duration:0.7 options:UIViewAnimationOptionTransitionCurlUp|UIViewAnimationOptionCurveEaseInOut animations:^{
        [self pushViewController:viewController animated:NO];
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)popViewControllerDoCustomAnimation{
    [UIView transitionWithView:self.view duration:0.7 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        [self popViewControllerAnimated:NO];
    } completion:^(BOOL finished) {
        
    }];
}


-(void)popToRootViewControllerDoCustomAnimation{
    [UIView transitionWithView:self.view duration:0.7 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        [self popToRootViewControllerAnimated:NO];
    } completion:^(BOOL finished) {
        
    }];
}


@end
