//
//  MessageDoneViewController.h
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-11.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDoneViewController : UITableViewController
@property BOOL _isRefreshing;
@property (nonatomic,strong)NSMutableArray* messageDoneArray;
@property (nonatomic, weak)IBOutlet UITableViewCell* messageDonecell;
@property (nonatomic, weak)IBOutlet UIImageView* employeeLogoView;
@property (nonatomic, weak)IBOutlet UILabel* createdByLabel;
@property (nonatomic, weak)IBOutlet UILabel* messageTitleLabel;
@property (nonatomic, weak)IBOutlet UILabel* timeLabel;
@property (nonatomic, weak)IBOutlet UIImageView* systemLogoView;
@property (nonatomic,strong)NSString* refreshTime;

- (void)selectMessageFromDatabase:(NSMutableArray*)selectedSystemArray;
@end
