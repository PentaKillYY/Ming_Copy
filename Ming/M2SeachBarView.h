//
//  M2SeachBarView.h
//  Ming2.0
//
//  Created by xiaoweiwu on 12/18/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M2BoderedView.h"

@interface M2SeachBarView :M2BoderedView
@property (nonatomic,assign) BOOL expanded;
@property (nonatomic,weak) IBOutlet UITextField *searchField;
@property (nonatomic,weak) IBOutlet UIButton *searchButton;
@property (nonatomic,weak) IBOutlet UIView *lineView;
@property (nonatomic,weak) IBOutlet UIImageView *magnifyView;

@end
