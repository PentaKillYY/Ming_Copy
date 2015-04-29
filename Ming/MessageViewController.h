//
//  MessageViewController.h
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-11.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
@interface MessageViewController : UITableViewController
{
    BOOL _isRefreshing;
    MBProgressHUD* hud;
}
@property (nonatomic)BOOL isCellSelected;
@property (nonatomic)BOOL isBatchMode;
@property (nonatomic,strong)NSMutableArray* messageArray;
@property (nonatomic,strong)NSString* systemIdString;
@property (nonatomic,strong)NSMutableArray* selectedCellArray;
@property BOOL _isRefreshing;
@property (nonatomic,strong)__block NSMutableIndexSet *successIndexes;
@property (nonatomic,strong)__block NSMutableIndexSet *failIndexes;
@property (nonatomic,strong)__block NSString* failReason;
-(void)ViewFrashData;
@end
