//
//  M2InfoBannerView.m
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-6.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2InfoBannerView.h"
@import QuartzCore;
#import "CAAnimation+Blocks.h"
#import "UIView+ScreenShot.h"
#import "NSDate+CurrentDate.h"
#import "Message.h"
#import "NSDate+CurrentDate.h"

@implementation M2InfoBannerView{
    CATransform3D topTransform;
    CATransform3D bottomTransform;
    UILabel *frontInfoLabel;
    UILabel *frontDateLabel;
    NSTimer *timer;
    NSInteger currentIndex;
}

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
    CATransform3D perspective=CATransform3DIdentity;
    perspective.m34=-1.0/500.0;
    self.layer.sublayerTransform=perspective;
    
    topTransform=CATransform3DMakeTranslation(0, 0, -self.height/2);
    topTransform=CATransform3DRotate(topTransform,Deg_To_Radius(90.0), 1, 0, 0);
    topTransform=CATransform3DTranslate(topTransform, 0, 0, self.height/2);
    
    
    bottomTransform=CATransform3DMakeTranslation(0, 0, -self.height/2);
    bottomTransform=CATransform3DRotate(bottomTransform,Deg_To_Radius(-90.0), 1, 0, 0);
    bottomTransform=CATransform3DTranslate(bottomTransform, 0, 0, self.height/2);
    
    frontInfoLabel=(UILabel *)[self viewWithTag:1];
    frontDateLabel=(UILabel *)[self viewWithTag:2];

    
    
    
}

-(void)setMessageArray:(NSArray *)messageArray{
    _messageArray=messageArray;
    currentIndex=0;
    if (timer) {
        [timer invalidate];
    }
    timer=[NSTimer timerWithTimeInterval:5 target:self selector:@selector(tickInfo) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];

    
}

-(void)tickInfo{
    if (currentIndex>=[_messageArray count]) {
        currentIndex=0;
    }
    Message *message=_messageArray[currentIndex];
    _currentMessage=message;
    [self showNewInfo:message.MsgTitle WithDateString:[[NSDate dateFromString:message.CreatedTime] getCurrentDateString]];
    currentIndex++;
}


-(void)showNewInfo:(NSString *)newInfo WithDateString:(NSString *)dateString{
    UIImageView *screenshotView=[frontInfoLabel getScreenShotImageView];
    [self addSubview:screenshotView];
    frontInfoLabel.text=newInfo;
    
    
    UIImageView *dateScreenshotView=[frontDateLabel getScreenShotImageView];
    [self addSubview:dateScreenshotView];
//    frontDateLabel.text=[[NSDate date] getCurrentDateString];
    frontDateLabel.text=dateString;
//    NSLog(@"current date:%@",frontDateLabel.text);
    

    CABasicAnimation *fromTop=[CABasicAnimation animationWithKeyPath:@"transform"];
    fromTop.duration=1;
    fromTop.fromValue=[NSValue valueWithCATransform3D:topTransform];
    fromTop.toValue=[NSValue valueWithCATransform3D:CATransform3DIdentity];
    [frontInfoLabel.layer addAnimation:fromTop forKey:@"fromTop"];
    
    
    screenshotView.layer.transform=bottomTransform;
    CABasicAnimation *toBottom=[CABasicAnimation animationWithKeyPath:@"transform"];
    toBottom.duration=0.8;
    toBottom.fromValue=[NSValue valueWithCATransform3D:CATransform3DIdentity];
    toBottom.toValue=[NSValue valueWithCATransform3D:bottomTransform];
    toBottom.completion=^(BOOL finished){
        [screenshotView removeFromSuperview];
    };
    
    [screenshotView.layer addAnimation:toBottom forKey:@"toBottom"];
    
    
    CABasicAnimation *fromTop1=[CABasicAnimation animationWithKeyPath:@"transform"];
    fromTop1.duration=1;
    fromTop1.beginTime=CACurrentMediaTime()+0.2;
    fromTop1.fillMode=kCAFillModeBackwards;
    fromTop1.fromValue=[NSValue valueWithCATransform3D:topTransform];
    fromTop1.toValue=[NSValue valueWithCATransform3D:CATransform3DIdentity];
    [frontDateLabel.layer addAnimation:fromTop1 forKey:@"fromTop1"];
    
    
    dateScreenshotView.layer.transform=bottomTransform;
    CABasicAnimation *toBottom1=[CABasicAnimation animationWithKeyPath:@"transform"];
    toBottom1.duration=1;
    
    toBottom1.beginTime=CACurrentMediaTime()+0.2;
    toBottom1.fillMode=kCAFillModeBackwards;
    toBottom1.fromValue=[NSValue valueWithCATransform3D:CATransform3DIdentity];
    toBottom1.toValue=[NSValue valueWithCATransform3D:bottomTransform];
    toBottom1.completion=^(BOOL finished){
        dateScreenshotView.alpha=0;
        [dateScreenshotView removeFromSuperview];
    };
    
    [dateScreenshotView.layer addAnimation:toBottom1 forKey:@"toBottom1"];
    
    
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
