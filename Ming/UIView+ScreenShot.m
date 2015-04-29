//
//  UIView+ScreenShot.m
//  iYouYueJi
//
//  Created by xiaowei wu on 9/26/13.
//  Copyright (c) 2013 YuLing-Tech. All rights reserved.
//

#import "UIView+ScreenShot.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIView (ScreenShot)
-(UIImage *)getBitmap{

    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIImageView *)getScreenShotImageView{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *screenshotView=[[UIImageView alloc]initWithImage:image];
    screenshotView.frame=self.frame;
    UIGraphicsEndImageContext();
    return screenshotView;
}
@end
