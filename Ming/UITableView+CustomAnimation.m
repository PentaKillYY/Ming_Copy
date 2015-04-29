//
//  UITableView+CustomAnimation.m
//  LiangShanTest
//
//  Created by wu xiaowei on 13-4-8.
//  Copyright (c) 2013年 wu xiaowei. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UITableView+CustomAnimation.h"

@implementation UITableView (CustomAnimation)
-(void)reloadDataDoAnimation:(BOOL)animated{
    [self reloadData];
    
    if (animated) {
        
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionMoveIn];
        [animation setSubtype:kCATransitionFromTop];
    //    [animation setSubtype:kCATransitionPush];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setFillMode:kCAFillModeBoth];
        [animation setDuration:0.7];
        [[self layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
        
    }
}

//-(void)reloadDataWithAnimationFromDataSourceArray:(NSArray *)dataSource{
//    [self beginUpdates];
//    for (int i=0; i<[dataSource count]; i++) {
//       NSIndexPath  *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//        [self insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//    [self endUpdates];
//}


-(void)reloadDataWithAnimationFromDataSourceArray:(NSArray *)dataSource{
    [self beginUpdates];
    for (int i=0; i<[dataSource count]; i++) {
        NSIndexPath  *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        double delayInSeconds =i*0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        });

    }
    [self beginUpdates];

}

-(void)deleteDataWithAnimationFromDataSourceArray:(NSArray*)dataSource{
    
    [self beginUpdates];
    for (NSInteger i=[dataSource count]-1; i>=0; i--) {
        NSIndexPath  *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    [self endUpdates];

}


@end
