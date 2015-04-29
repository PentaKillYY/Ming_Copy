//
//  M2SearchHUD.m
//  Ming2.0
//
//  Created by xiaoweiwu on 12/16/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import "M2SearchHUD.h"
@import QuartzCore;

@implementation M2SearchHUD{
    
    __weak IBOutlet UIImageView *readyImageView;
    __weak IBOutlet UIView *moveBarView;
    __weak IBOutlet UIView *progressView;
    __weak IBOutlet UIView *pathView;
    __weak IBOutlet UIImageView *magnifyImageView;
    CAKeyframeAnimation *circle;
    CABasicAnimation *translate;
}


+(instancetype)sharedHUD{
    static M2SearchHUD *sharedHUD;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHUD=[[M2SearchHUD alloc]init];
    });
    
    return sharedHUD;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)init{
    if (self=[super init]) {
        self=[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self.class) owner:self options:nil][0];
        
        [self initAnimation];
        self.layer.speed=0;
        progressView.hidden=YES;
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


-(void)initAnimation{
    UIBezierPath *circlePath=[UIBezierPath bezierPathWithOvalInRect:pathView.frame];
    
    circle=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    circle.path=circlePath.CGPath;
    circle.duration=0.5;
    circle.repeatCount=HUGE_VAL;
    circle.calculationMode=kCAAnimationPaced;
    
    
    CALayer *maskLayer=[CALayer layer];
    maskLayer.frame=progressView.bounds;
    maskLayer.contentsScale=[UIScreen mainScreen].scale;
    
    UIImage *image=[UIImage imageNamed:@"inSearch"];
    maskLayer.contents=(__bridge id)image.CGImage;
    progressView.layer.mask=maskLayer;
    
    moveBarView.layer.cornerRadius=moveBarView.height/2;
    moveBarView.layer.masksToBounds=YES;
    
    translate=[CABasicAnimation animationWithKeyPath:@"transform"];
    translate.fromValue=[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-progressView.width, 0, 0)];
    translate.toValue=[NSValue valueWithCATransform3D:CATransform3DIdentity];
    translate.duration=1;
    translate.repeatCount=HUGE_VAL;
}



-(void)show{
    self.layer.opacity=1.0;
    readyImageView.hidden=YES;
    progressView.hidden=NO;
    self.layer.speed=1.0;
    [magnifyImageView.layer addAnimation:circle forKey:@"circle"];
    [moveBarView.layer addAnimation:translate forKey:@"translate"];

}


-(void)showInView:(UIView *)view status:(SearchHUDStatus)status{
    self.center=view.center;
    [view addSubview:self];
    
    switch (status) {
        case kReady:{
            self.layer.opacity=1.0;
            self.layer.speed=0;
        }
            break;
        case kSearch:{
            [self show];
        }
            break;
        default:
            break;
    }
    
    
    
}

-(void)dismiss{
    
    
    self.layer.opacity=0;
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    scale.fromValue=[NSValue valueWithCATransform3D:CATransform3DIdentity];
    scale.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)];

    CABasicAnimation *fade=[CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.fromValue=@1.0;
    fade.toValue=@0.0;
    
    
    CAAnimationGroup *dismiss=[CAAnimationGroup animation];
    dismiss.animations=@[scale,fade];
    dismiss.duration=0.25;
    dismiss.completion=^(BOOL complete){
        readyImageView.hidden=NO;
        progressView.hidden=YES;
        self.layer.speed=0;
        [magnifyImageView.layer removeAllAnimations];
        [moveBarView.layer removeAllAnimations];
        self.alpha=0;
        
    };
    
    [self.layer addAnimation:dismiss forKey:@"dismiss"];
}
@end
