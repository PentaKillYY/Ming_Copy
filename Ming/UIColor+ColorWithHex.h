//
//  UIColor+ColorWithHex.h
//  iYouYueJi
//
//  Created by wu xiaowei on 13-6-22.
//  Copyright (c) 2013年 YuLing-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorWithHex)
+(UIColor*)colorWithHexValue:(uint)hexValue andAlpha:(float)alpha;
+(UIColor*)colorWithHexString:(NSString *)hexString andAlpha:(float)alpha;
@end
