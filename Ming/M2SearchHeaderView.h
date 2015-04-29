//
//  M2SearchHeaderView.h
//  Ming2.0
//
//  Created by xiaoweiwu on 12/19/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M2SeachBarView.h"

@interface M2SearchHeaderView : UIView
@property (nonatomic,assign) BOOL isNavHidden;
@property (nonatomic,weak) IBOutlet UIView *fakeNavView;
@property (nonatomic,weak) IBOutlet M2SeachBarView *seachBarView;
@end

