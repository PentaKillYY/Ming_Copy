//
//  M2SearchHUD.h
//  Ming2.0
//
//  Created by xiaoweiwu on 12/16/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kReady,
    kSearch
}SearchHUDStatus;

@interface M2SearchHUD : UIView
+(instancetype)sharedHUD;
-(void)show;
-(void)showInView:(UIView *)view status:(SearchHUDStatus)status;
-(void)dismiss;
@end
