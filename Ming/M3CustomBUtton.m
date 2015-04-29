//
//  M3CustomBUtton.m
//  Ming
//
//  Created by HuangLuyang on 14-4-30.
//  Copyright (c) 2014年 xiaowei wu. All rights reserved.
//

#import "M3CustomBUtton.h"

@implementation M3CustomBUtton

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
    self.layer.cornerRadius=0;
    
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
