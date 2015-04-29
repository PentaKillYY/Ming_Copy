//
//  M2SystemChooseListView.m
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-12.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2SystemChooseListView.h"
#import "UserInfo.h"
//#import <UIImageView+AFNetworking.h>

@implementation M2SystemChooseListView
@synthesize systemSelected = _systemSelected;
@synthesize isChanged;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isChanged = NO;
        rowNumber = [UserInfo sharedUserInfo].systemList.count;
        
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.01;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground)];
        [backgroundView addGestureRecognizer:tap];
        [self addSubview:backgroundView];
        
        systemListView = [[UITableView alloc] initWithFrame:CGRectMake(0, -40.0f*rowNumber, frame.size.width, 40*rowNumber) style:UITableViewStylePlain];
        systemListView.rowHeight = 40;
        systemListView.scrollEnabled = NO;
        systemListView.delegate = self;
        systemListView.dataSource = self;
        [self addSubview:systemListView];
        _systemSelected = [[NSMutableArray alloc] init];
        for (NSDictionary * sysdic in [UserInfo sharedUserInfo].systemList) {
            [_systemSelected addObject:[sysdic objectForKey:@"SystemID"]];
        }
        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rowNumber;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
static NSString* Identifier = @"Identifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSString* strUrl = [[[[UserInfo sharedUserInfo].systemList objectAtIndex:indexPath.row] objectForKey:@"SystemLogo"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    

    UIImageView* sysLogoView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 26 , 26)];
    [sysLogoView setImageWithURL:[NSURL URLWithString:strUrl]];
    [cell.contentView addSubview:sysLogoView];
    
    UILabel* sysNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 7, 280, 26)];
    sysNameLabel.text = [[[UserInfo sharedUserInfo].systemList objectAtIndex:indexPath.row] objectForKey:@"SystemName"];
    [cell.contentView addSubview:sysNameLabel];
    if (isChanged == NO) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isChanged = YES;
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == 3) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_systemSelected removeObject:[[[UserInfo sharedUserInfo].systemList objectAtIndex:indexPath.row] objectForKey:@"SystemID"]];
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if (![_systemSelected containsObject:[[[UserInfo sharedUserInfo].systemList objectAtIndex:indexPath.row] objectForKey:@"SystemID"]]) {
            [_systemSelected addObject:[[[UserInfo sharedUserInfo].systemList objectAtIndex:indexPath.row] objectForKey:@"SystemID"]];
        }
    }
    [tableView reloadData];
}

- (void)tapBackground
{
    
    [UIView animateWithDuration:0.1 animations:^{
        systemListView.frame = CGRectMake(0, -40.0f*rowNumber, systemListView.frame.size.width, 40*rowNumber);
        backgroundView.alpha = 0.01;
    } completion:^(BOOL finished){
        backgroundView.hidden = YES;
        self.hidden = YES;
        [self.ConfirmSystemDelegate sysChooseDone];
    }];
}

- (void)showListView
{
    [UIView animateWithDuration:0.2 animations:^{
        systemListView.frame = CGRectMake(0, 0, systemListView.frame.size.width, systemListView.frame.size.height);
        backgroundView.hidden = NO;
        self.hidden = NO;
        backgroundView.alpha = 0.5;
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        systemListView.frame = CGRectMake(0, 0, systemListView.frame.size.width, systemListView.frame.size.height);
        backgroundView.hidden = NO;
        self.hidden = NO;
        backgroundView.alpha = 0.5;
    } completion:^(BOOL finished){
        [systemListView reloadData];
    }];
}

- (void)hideListView
{
    [UIView animateWithDuration:0.2 animations:^{
        systemListView.frame = CGRectMake(0, -40.0f*rowNumber, systemListView.frame.size.width, 40*rowNumber);
        backgroundView.alpha = 0.01;
    } completion:^(BOOL finished){
        backgroundView.hidden = YES;
        self.hidden = YES;
    }];
}
@end
