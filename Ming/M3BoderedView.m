//
//  M3BoderedView.m
//  Ming
//
//  Created by HuangLuyang on 14-4-30.
//  Copyright (c) 2014年 xiaowei wu. All rights reserved.
//

#import "M3BoderedView.h"
#import <QuartzCore/QuartzCore.h>
@implementation M3BoderedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius=2;
    self.layer.masksToBounds=YES;
}
@end
