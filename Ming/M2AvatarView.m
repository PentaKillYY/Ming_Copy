//
//  M2AvatarView.m
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-11.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2AvatarView.h"
@import QuartzCore;

@implementation M2AvatarView

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
    self.layer.cornerRadius=self.layer.bounds.size.height/2.0;
    self.layer.masksToBounds=YES;
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
