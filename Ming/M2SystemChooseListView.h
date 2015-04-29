//
//  M2SystemChooseListView.h
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-12.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ConfirmSystemDelegate <NSObject>
-(void)sysChooseDone;
@end

@interface M2SystemChooseListView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* systemListView;
    UIView* backgroundView;
    UITapGestureRecognizer* tap;
    NSInteger rowNumber;
    BOOL isChanged;
    NSMutableArray* systemSelected;
}
@property(nonatomic,assign)id ConfirmSystemDelegate;
@property(nonatomic,strong)NSMutableArray* systemSelected;
@property BOOL isChanged;
- (void)showListView;
- (void)hideListView;
@end
