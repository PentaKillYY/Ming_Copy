//
//  UITableView+CustomAnimation.h
//  LiangShanTest
//
//  Created by wu xiaowei on 13-4-8.
//  Copyright (c) 2013年 wu xiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (CustomAnimation)
-(void)reloadDataDoAnimation:(BOOL)animated;

-(void)reloadDataWithAnimationFromDataSourceArray:(NSArray *)dataSource;

-(void)deleteDataWithAnimationFromDataSourceArray:(NSArray*)dataSource;

@end
