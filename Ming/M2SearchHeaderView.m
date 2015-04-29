//
//  M2SearchHeaderView.m
//  Ming2.0
//
//  Created by xiaoweiwu on 12/19/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import "M2SearchHeaderView.h"

@implementation M2SearchHeaderView

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


-(void)layoutSubviews{
    [super layoutSubviews];    
    if (_isNavHidden) {
        self.seachBarView.frame=CGRectMake(43,8,272,27);
        self.fakeNavView.transform=CGAffineTransformIdentity;
        self.seachBarView.layer.borderWidth=0;
        self.seachBarView.layer.cornerRadius=0;
    }else{
        self.seachBarView.frame=CGRectMake(8,8, 304, 27);
        self.seachBarView.layer.borderWidth=1;
        self.seachBarView.layer.cornerRadius=4;
        self.fakeNavView.transform=CGAffineTransformMakeTranslation(0, -44);
    }

}

@end
