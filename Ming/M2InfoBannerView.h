//
//  M2InfoBannerView.h
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-6.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface M2InfoBannerView : UIView
@property (nonatomic,strong) NSArray *messageArray;
@property (nonatomic,strong) Message *currentMessage;
//-(void)showNewInfo:(NSString *)newInfo;
@end
