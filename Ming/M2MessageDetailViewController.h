//
//  M2MessageDetailViewController.h
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-16.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M3BackViewController.h"
#import <MBProgressHUD.h>

@interface M2MessageDetailViewController : M3BackViewController
{
    MBProgressHUD* hud;
}
@property(nonatomic,strong)NSMutableArray* responseArray;
@property(nonatomic)NSInteger indexNumber;

@end

