//
//  UIImage+Dynamic.m
//  iYouYueJi
//
//  Created by wu xiaowei on 13-6-22.
//  Copyright (c) 2013年 YuLing-Tech. All rights reserved.
//

#import "UIImage+Dynamic.h"

@implementation UIImage (Dynamic)
+(UIImage *)imageWithColor:(UIColor *)color withRect:(CGRect)rect{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
