//
//  M2CornorMarkLabel.m
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-6.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2CornorMarkLabel.h"
@import QuartzCore;

@implementation M2CornorMarkLabel

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
    self.layer.cornerRadius=self.width/2.0;
}

-(void)setCountString:(NSString *)countString{
    _countString=countString;
    if (countString.integerValue>0) {
        self.hidden = NO;
        if(countString.integerValue>99)
        {
            //100条以上的审批显示99+
            countString=@"99+";
            UIFont *font = [UIFont fontWithName:@"Arial" size:12];
            CGSize size = CGSizeMake(100,100);
            CGSize labelsize = [countString sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
            self.size = labelsize;
        }
    }else
    {
        self.hidden = YES;
    }
    
    self.text=countString;
    CATransform3D scaleSmall=CATransform3DMakeScale(0.7, 0.7, 1);
    CATransform3D scaleLarge=CATransform3DMakeScale(1.5, 1.5, 1);
    CAKeyframeAnimation *showAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform"];
    showAnimation.values=@[[NSValue valueWithCATransform3D:scaleSmall],[NSValue valueWithCATransform3D:scaleLarge],[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    showAnimation.keyTimes=@[@0.0,@0.5,@1.0];
    
    CABasicAnimation *fade=[CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.fromValue=@0.0;
    fade.toValue=@1.0;
    
    CAAnimationGroup *showGroup=[CAAnimationGroup animation];
    showGroup.animations=@[fade,showAnimation];
    showGroup.duration=0.25;
    
    [self.layer addAnimation:showGroup forKey:@"show"];
}

@end
