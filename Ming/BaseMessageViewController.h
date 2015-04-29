//
//  BaseMessageViewController.h
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-11.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M3BackViewController.h"
#import "M2SystemChooseListView.h"
#import "M2CommentView.h"

@interface BaseMessageViewController : M3BackViewController<UIScrollViewDelegate,ConfirmSystemDelegate,UIKeyboardCoViewDelegate>
{
    BOOL isSystemChoose;
    UILabel* numberLabel;
    UILabel* titleLabel;
    UIView* backView;
}
@end
