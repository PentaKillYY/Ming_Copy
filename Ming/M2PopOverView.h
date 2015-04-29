//
//  M2PopOverView.h
//  Ming2.0
//
//  Created by xiaoweiwu on 12/23/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M2PopOverView : UIView
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
-(void)setPopOverWithInfo:(NSDictionary *)info;
-(void)showInView:(UIView *)view;
@end
