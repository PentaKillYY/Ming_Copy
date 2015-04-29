//
//  M2CustomButton.m
//  Ming2.0
//
//  Created by xiaoweiwu on 12/16/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import "M2CustomButton.h"

@implementation M2CustomButton

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
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=self.tag;
    
    [self setBackgroundImage:[UIImage imageWithColor:self.backgroundColor withRect:self.bounds] forState:UIControlStateNormal];
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
