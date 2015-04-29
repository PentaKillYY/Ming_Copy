//
//  M2BoderedView.m
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-5.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2BoderedView.h"
#import <QuartzCore/QuartzCore.h>

@implementation M2BoderedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.borderWidth=1;
    self.layer.borderColor=[UIColor colorWithHexValue:0xe1e1e1 andAlpha:1.0].CGColor;
    
    if (self.tag==11) {
        self.layer.cornerRadius=4;
        self.layer.masksToBounds=YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
