//
//  MessageViewController.m
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-11.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//
#import "MessageViewController.h"
#import "SWTableViewCell.h"
#import "EGORefreshTableHeaderView.h"
#import "UserInfo.h"
#import "SystemMessageParser.h"
#import "CommonMacro.h"
#import "Go2Util.h"
#import <SVProgressHUD.h>
#define K_cellNotBatch 0
#define K_cellBatch 1

@interface MessageViewController()<EGORefreshDelegate,SWTableViewCellDelegate>
{
    NSInteger _rowCount;
    UIButton* _bottomRefresh;
    NSMutableArray* indexArray;
    EGORefreshTableHeaderView *_headerRefreshView;
    NSInteger cellMode;
    UIView* handleView;
    UITextView* commentView;
    NSInteger handledCellIndex;
    BOOL isAllSelected ;
    NSMutableArray* array;
    int number ;
}
@end

@implementation MessageViewController

@synthesize _isRefreshing;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        if (IS_VERSION7) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
            self.navigationController.navigationBar.translucent = NO;
        }
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HandleMessage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EnterBatchMode" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ExitBatchMode" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AllCellSelected" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CancelAllSelected" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TimeoutNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NetErrorNotification" object:nil];
    [super viewWillDisappear:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBatchMode) name:@"EnterBatchMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitBatchMode) name:@"ExitBatchMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAllCell) name:@"AllCellSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelAllCell) name:@"CancelAllSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BatchHandle:) name:@"HandleMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollContentSizeBatch) name:@"EnterBatchMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollContentSizeNotBatch) name:@"ExitBatchMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollContentSizeNotBatch) name:@"CancelBatchMode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAllCellSelectionState) name:@"CellAllSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelAllSelected) name:@"CancelAllSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelAllState) name:@"CancelAllCellState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStopLoading) name:@"TimeoutNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStopLoading) name:@"NetErrorNotification" object:nil];
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellMode = K_cellNotBatch;
    handledCellIndex = 0;
    
    self.selectedCellArray = [[NSMutableArray alloc] init];
    _isRefreshing = NO;
    _rowCount = 20;
    self.tableView.allowsSelection = NO;
    self.tableView.rowHeight = 64;
    
    /******头部的下拉刷新******/
    _headerRefreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - self.tableView.frame.size.height, 320, self.tableView.bounds.size.height)];
    _headerRefreshView.delegate = self;
    [self.tableView addSubview:_headerRefreshView];
    [self setExtraCellLineHidden:self.tableView];
    [self ViewFrashData];
    
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40 )];
    
    _bottomRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomRefresh.layer setMasksToBounds:YES];
    [_bottomRefresh.layer setBorderWidth:1.0];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 254/255,254/255, 254/255, 0.2 });
    [_bottomRefresh.layer setBorderColor:colorref];
    _bottomRefresh.titleLabel.font = [UIFont systemFontOfSize:13];
    [_bottomRefresh setTitle:NSLocalizedString(@"查看更多", @"") forState:UIControlStateNormal];
    [_bottomRefresh setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_bottomRefresh addTarget:self action:@selector(loadMoreMessage) forControlEvents:UIControlEventTouchUpInside];
    _bottomRefresh.frame = CGRectMake(10, 5, 300, 30);
    //    [_bottomRefresh setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    _bottomRefresh.hidden = YES;
    [footerView addSubview:_bottomRefresh];
    
    [self.tableView setTableFooterView:footerView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ViewFrashData) name:@"MessageListNeedRefresh" object:Nil];
}

/**
 *  触发刷新
 */
-(void)ViewFrashData{
    [self.tableView setContentOffset:CGPointMake(0, -65) animated:NO];
    [self.tableView setContentInset:UIEdgeInsetsMake(66, 0, 0, 0)];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CancelAllCellState" object:nil];
    [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.1];
}

/**
 *  手动刷新结束
 */
-(void)doneManualRefresh{
    [_headerRefreshView egoRefreshScrollViewDidScroll:self.tableView];
    [_headerRefreshView egoRefreshScrollViewDidEndDragging:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/**
 *  隐藏多余线条
 *
 *  @param tableView tableview
 */
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

/**
 *  section数量设置
 *
 *  @param tableView tableview
 *
 *  @return section数量
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

/**
 *  rows数量设置
 *
 *  @param tableView tableview
 *  @param section   section
 *
 *  @return rows数量
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    if (self.messageArray.count == 0) {
        _bottomRefresh.hidden = YES;
        return 0;
    }
    else if (self.messageArray.count <=20 ) {
        _bottomRefresh.hidden = NO;
        
        [_bottomRefresh setTitle:NSLocalizedString(@"已加载全部数据", @"") forState:UIControlStateNormal];
        return self.messageArray.count;
    }else {
        if (_rowCount < self.messageArray.count ) {
            [_bottomRefresh setTitle:NSLocalizedString(@"加载更多", @"") forState:UIControlStateNormal];
        }else{
            [_bottomRefresh setTitle:NSLocalizedString(@"已加载全部数据", @"") forState:UIControlStateNormal];
        }
        
        _bottomRefresh.hidden = NO;
        return _rowCount;
    }
}

/**
 *  描绘cell
 *
 *  @param tableView tableview
 *  @param indexPath 行标识
 *
 *  @return 返回cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SWTableViewCell* cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];

        [rightUtilityButtons addUtilityButtonWithColor:nil icon:LoadImageWithType(@"同意normal", @"png")];
        [rightUtilityButtons addUtilityButtonWithColor:nil icon:LoadImageWithType(@"拒绝normal", @"png")];
        
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier
                                  containingTableView:tableView // Used for row height and selection
                                   leftUtilityButtons:nil
                                  rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
    }
    if ([indexArray containsObject:indexPath]) {
        [UIView animateWithDuration:0.2 animations:^{
            [cell hideUtilityButtonsAnimated:YES];
        }];
    }
    [cell.employeeLogoView setImageWithURL:[NSURL URLWithString:[[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"employee_image"]]];
    
    cell.createdByLabel.text = [[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"CreatedBy"];
    cell.messageTitleLabel.text = [[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"MsgTitle"];
    NSString* timeString =[NSString stringWithString:[[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"CreatedTime"]];
    cell.timeLabel.text = [self judgeDate:timeString];
    [cell.systemLogoView setImageWithURL:[NSURL URLWithString:[[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"SystemLogo"]]];
   
    if ([_failIndexes containsIndex:(indexPath.row + [_successIndexes count])]) {
        cell.rightButton.frame = CGRectMake(295, 22, 20, 20);
        [cell.rightButton setBackgroundImage:[UIImage imageNamed:@"error.png"] forState:UIControlStateNormal];
        cell.cellScrollView.scrollEnabled = YES;
        cell.rightButton.tag = -1;
        
    }else
    {
        if (!_isBatchMode) {
            cell.rightButton.frame = CGRectMake(285, 12, 40, 40);
            [cell.rightButton setBackgroundImage:[UIImage imageNamed:@"right_arrow.png"] forState:UIControlStateNormal];
            cell.cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(cell.bounds) + 2*72, 64);
            cell.cellScrollView.scrollEnabled = YES;
            
            cell.rightButton.tag = 0;
        }else{
            cell.cellScrollView.scrollEnabled = NO;
            if ([self.selectedCellArray containsObject:[NSString stringWithFormat:@"%d",(int)indexPath.row ]]) {
                cell.rightButton.frame = CGRectMake(290, 22, 20, 20);
                [cell.rightButton setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
            }else{
                cell.rightButton.frame = CGRectMake(290, 22, 20, 20);
                [cell.rightButton setBackgroundImage:[UIImage imageNamed:@"notSelected.png"] forState:UIControlStateNormal];
                cell.rightButton.tag = 1;
            }
        }
    }
        return cell;
}

#pragma mark -
#pragma mark Table view delegate

/**
 *  tableview点击
 *
 *  @param tableView tableview
 *  @param indexPath 行标识
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWTableViewCell* cell = (SWTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
    if (cell.rightButton.tag == 0) {
        if (![indexArray containsObject:@""] && indexArray != nil) {
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone ];
            indexArray = [NSMutableArray arrayWithObject:@""];
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            [Go2Util go2MessageDetailForm:self responseMessage:self.messageArray IntegerNumber:indexPath.row];
        }
  
    }
    else if (cell.rightButton.tag == -1)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.tableView];
        [self.view addSubview:hud];
        hud.labelText = [NSString stringWithFormat:@"%@",_failReason];
        hud.labelFont = [UIFont systemFontOfSize:12];
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [hud removeFromSuperview];
            hud = nil;
        }];
    }
    else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAllSelectedState" object:nil];
        if (![self.selectedCellArray containsObject:[NSString stringWithFormat:@"%d",(int)indexPath.row]]) {
            [self.selectedCellArray addObject:[NSString stringWithFormat:@"%d",(int)indexPath.row ]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddSelectedCount" object:nil];
        }else
        {
            [self.selectedCellArray removeObject:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MinusSelectedCount" object:nil];
        }
        cell.isBatchMode = YES;
        [self.tableView reloadData];
    }
 }

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark -
#pragma mark SWTableViewDelegate

/**
 *  即将滑动cell
 *
 *  @param cell  cell
 *  @param state cell状态
 */
- (void)swippableTableViewCell:(SWTableViewCell *)cell WillScrollToState:(SWCellState)state{
    
    if (![indexArray containsObject:@""]) {
        [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    }
}

/**
 *  cell滑动
 *
 *  @param cell  cell
 *  @param state cell状态
 */
- (void)swippableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    NSIndexPath* path = [self.tableView indexPathForCell:cell];
    if (state == 2) {
        indexArray = [NSMutableArray arrayWithObject:path];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isSystemChooseNotAvailable" object:nil];
    }else if (state == 0)
    {
        indexArray = [NSMutableArray arrayWithObject:@""];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isSystemChooseAvailable" object:nil];
    }
}

/**
 *  左滑按钮点击
 *
 *  @param cell  cell
 *  @param index 按钮标识
 */
- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

/**
 *  右滑按钮点击
 *
 *  @param cell  cell
 *  @param index 按钮标识
 */
- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    handledCellIndex = [[indexArray objectAtIndex:0] row];
    switch (index) {
        case 0:
        {
            NSLog(@"按下同意按钮");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShouldScrollToMessageDone" object:Nil];
            if(self.getShowComment)
            {
                NSLog(@"隐藏意见输入框");
                [UIAlertView showWithTitle:NSLocalizedString(@"suggestion", @"") message:NSLocalizedString(@"Please confirm whether to approve", @"") cancelButtonTitle:NSLocalizedString(@"confirm", @"") otherButtonTitles:@[NSLocalizedString(@"cancel", @"")]  tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex==0) {
                        NSLog(@"同意");
                        NSDictionary* dic = @{@"action": @"Approve",@"comment":@"",@"mode":NSLocalizedString(@"批量操作", @"")};
                        [self executeBatchHandle:dic];
                    }else
                    {
                        NSLog(@"取消");
                    }
                }];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ApproveAction" object:nil];
            }
            
            break;
        }
        case 1:
        {
            NSLog(@"按下拒绝按钮");
            if(self.getShowComment)
            {
                NSLog(@"隐藏意见输入框");
                [UIAlertView showWithTitle:NSLocalizedString(@"suggestion", @"") message:NSLocalizedString(@"Please confirm whether to reject", @"") cancelButtonTitle:NSLocalizedString(@"拒绝", @"") otherButtonTitles:@[NSLocalizedString(@"cancel", @"")]  tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex==0) {
                        NSLog(@"拒绝");
                        NSDictionary* dic = @{@"action": @"Reject",@"comment":@"",@"mode":NSLocalizedString(@"批量操作", @"")};
                        [self executeBatchHandle:dic];
                    }else
                    {
                        NSLog(@"取消");
                    }
                }];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RejectAction" object:nil];
            }
            break;
        }
        default:
            break;
    }
}

-(void) executeBatchHandle:(NSDictionary*) userinfo
{
    NSString *action=[userinfo objectForKey:@"action"];
    NSString* sysId = [[self.messageArray objectAtIndex:handledCellIndex] objectForKey:@"SystemID"];
    NSString* msgId = [[self.messageArray objectAtIndex:handledCellIndex] objectForKey:@"MsgID"];
    [[SystemMessageParser sharedHttpParser] handleSystemMessageSystemId:sysId  MsgID:msgId Action:action Comment:@"" OnCompletion:^(NSArray* json){
        NSString* responseResult = [[json objectAtIndex:0] objectForKey:@"key"];
        if ([responseResult isEqualToString:@"-1"]) {
            
        }else{
            if ([responseResult isEqualToString:@"1"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HandleDone" object:Nil];
                number = number - 1;
                
                NSString* countString = nil;
                countString = [NSString stringWithFormat:@"%d",number];
                NSDictionary* countDic = @{@"count": countString};
                [[NSNotificationCenter defaultCenter] postNotificationName:kSysCountChanged object:self userInfo:countDic];
                
                [self.messageArray removeObjectAtIndex:[[indexArray objectAtIndex:0] row]];
                //[self.tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView reloadData];
                hud = [[MBProgressHUD alloc] initWithView:self.tableView];
                [self.view addSubview:hud];
                hud.mode = MBProgressHUDModeText;
                hud.labelFont = [UIFont systemFontOfSize:12];
                hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"审批成功", @"")];
                [hud showAnimated:YES whileExecutingBlock:^{
                    sleep(2);
                } completionBlock:^{
                    [hud removeFromSuperview];
                    hud = nil;
                }];
                
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HandleDone" object:Nil];
                hud = [[MBProgressHUD alloc] initWithView:self.tableView];
                [self.view addSubview:hud];
                hud.mode = MBProgressHUDModeText;
                hud.labelFont = [UIFont systemFontOfSize:12];
                hud.detailsLabelFont = [UIFont systemFontOfSize:12];
                hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"审批失败", @"")];
                hud.detailsLabelText = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"失败原因", @""),responseResult];
                [hud showAnimated:YES whileExecutingBlock:^{
                    sleep(2);
                } completionBlock:^{
                    [hud removeFromSuperview];
                    hud = nil;
                }];
            }
        }
    }];
}

/**
 *  是否显示审批意见
 *
 *  @return 返回布尔值
 */
-(BOOL)getShowComment
{
    NSString* commentFlag = [[self.messageArray objectAtIndex:handledCellIndex] objectForKey:@"SystemName"];
    if(commentFlag != nil && [allTrim(commentFlag) length] > 0 && [[commentFlag lowercaseString] containsString:@"atten"])
    {
        return true;
    }
    else
    {
        return false;
    }
}

#pragma mark -
#pragma mark EGORefresh Delegate

/**
 *  正在刷新
 *
 *  @param view view
 *
 *  @return 是否正在刷新标识
 */
- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView *)view
{
    return _isRefreshing;
}

/**
 *  update刷新时间
 *
 *  @param view view
 *
 *  @return 刷新时间
 */
- (NSDate *)egoRefreshTableDataSourceLastUpdated:(UIView *)view
{
    return [NSDate date];
}

/**
 *  触发刷新操作
 *
 *  @param view view
 */
- (void)egoRefreshTableDidTriggerRefresh:(UIView*)view{
	[self.successIndexes removeAllIndexes];
    [self.failIndexes removeAllIndexes];
	[self reloadTableViewDataSource];
    self.tableView.userInteractionEnabled = NO;
    
    if (self.systemIdString == nil) {
        self.systemIdString = @"";
    }
    //获取未审批数据
    [[SystemMessageParser sharedHttpParser] postSystemMessagesystemId:self.systemIdString startTime:@"" OnCompletion:^(NSArray* json){
        self.messageArray = [NSMutableArray arrayWithArray:json];
        if ([self.systemIdString isEqualToString:@""]) {
            number = (int)self.messageArray.count;
        }
            NSRange range = NSMakeRange(0, [json count]);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.messageArray insertObjects:json atIndexes:indexSet];
            NSSet* tempSet = [NSSet setWithArray:self.messageArray];
            NSSortDescriptor* descripor2=[NSSortDescriptor sortDescriptorWithKey:@"CreatedTime" ascending:NO];
            self.messageArray = [NSMutableArray arrayWithArray:[tempSet sortedArrayUsingDescriptors:@[descripor2]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(doneLoadingTableViewData)];
            self.tableView.userInteractionEnabled = YES;
            NSString* countString = nil;
            countString = [NSString stringWithFormat:@"%d",number];
            NSDictionary* countDic = @{@"count": countString};
            [[NSNotificationCenter defaultCenter] postNotificationName:kSysCountChanged object:self userInfo:countDic];
        });
    }];
}

#pragma mark -
#pragma mark ScrollView Delegate

/**
 *  scrollview触发滑动
 *
 *  @param scrollView scrollview
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (cellMode == K_cellBatch) {
        
    }else{
        [_headerRefreshView egoRefreshScrollViewDidScroll:scrollView];
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, SCREEN_HEIGHT-45-44-20);
    }
}

/**
 *  scrollview滑动结束
 *
 *  @param scrollView scrollview
 *  @param decelerate decelerate
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (cellMode == K_cellBatch) {
        
    }else
    {
        [_headerRefreshView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark -
#pragma mark Actions

/**
 *  重新加载数据
 */
- (void)reloadTableViewDataSource
{
    _isRefreshing = YES;
}

/**
 *  数据加载完成
 */
- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	_isRefreshing = NO;
    [self.tableView reloadData];
	[_headerRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    //header
    _headerRefreshView.frame = CGRectMake(0, 0-self.tableView.bounds.size.height-40-44, self.tableView.frame.size.width, self.tableView.bounds.size.height+40+44 );
}

/**
 *  加载更多信息
 */
- (void)loadMoreMessage
{
    if (_rowCount < self.messageArray.count && (self.messageArray.count - _rowCount) >= 20) {
        _rowCount += 20;
    }
    else if ((self.messageArray.count - _rowCount)<20)
    {
        _rowCount = self.messageArray.count;
    }
    else{
    }
    [self.tableView reloadData];
}

#pragma -
#pragma mark TimeCalculate

/**
 *  判断日期
 *
 *  @param messageString 原始日期
 *
 *  @return 最终日期
 */
- (NSString*)judgeDate:(NSString*)messageString
{
    NSDate* today = [NSDate date];
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];

    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString* refstring=[messageString substringToIndex:10];
    if ([refstring isEqualToString:todayString]) {
        return NSLocalizedString(@"今天", @"");
    }else if ([refstring isEqualToString:yesterdayString]){
    return NSLocalizedString(@"昨天", @"");
    }else{
        return refstring;
    }
}

/**
 *  进入批量模式
 */
- (void)enterBatchMode
{
    cellMode = K_cellBatch;
    _headerRefreshView.hidden = YES;
    [self.selectedCellArray removeAllObjects];
}

/**
 *  退出批量模式
 */
- (void)exitBatchMode
{
    _headerRefreshView.hidden = NO;
    cellMode = K_cellNotBatch;
}

/**
 *  批量审批
 *
 *  @param notification 接收到的审批操作通知
 */
-(void)BatchHandle:(NSNotification*)notification{
    NSString *action = [notification.userInfo objectForKey:@"action"];
    NSString* actionString = nil;
    if ([action isEqualToString:NSLocalizedString(@"同意", @"")]) {
        actionString = @"Approve";
    }else
    {
        actionString = @"Reject";
    }
    
    NSString* comment = [notification.userInfo objectForKey:@"comment"];
    _successIndexes = [[NSMutableIndexSet alloc] init];
    _failIndexes = [[NSMutableIndexSet alloc] init];

    _failReason = [[NSString alloc] init];
    if ([[notification.userInfo objectForKey:@"mode"] isEqualToString:NSLocalizedString(@"批量操作", @"")]) {
        NSString* sysId = [[self.messageArray objectAtIndex:handledCellIndex] objectForKey:@"SystemID"];
        NSString* msgId = [[self.messageArray objectAtIndex:handledCellIndex] objectForKey:@"MsgID"];
        [[SystemMessageParser sharedHttpParser] handleSystemMessageSystemId:sysId  MsgID:msgId Action:actionString Comment:comment OnCompletion:^(NSArray* json){
            NSString* responseResult = [[json objectAtIndex:0] objectForKey:@"key"];
            if ([responseResult isEqualToString:@"-1"]) {
                
            }else{
                if ([responseResult isEqualToString:@"1"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"HandleDone" object:Nil];
                    number = number - 1;
                    
                    NSString* countString = nil;
                    countString = [NSString stringWithFormat:@"%d",number];
                    NSDictionary* countDic = @{@"count": countString};
                    [[NSNotificationCenter defaultCenter] postNotificationName:kSysCountChanged object:self userInfo:countDic];

                    [self.messageArray removeObjectAtIndex:[[indexArray objectAtIndex:0] row]];
                    //[self.tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView reloadData];
                    hud = [[MBProgressHUD alloc] initWithView:self.tableView];
                    [self.view addSubview:hud];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelFont = [UIFont systemFontOfSize:12];
                    hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"审批成功", @"")];
                    [hud showAnimated:YES whileExecutingBlock:^{
                        sleep(2);
                    } completionBlock:^{
                        [hud removeFromSuperview];
                        hud = nil;
                    }];
                    
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"HandleDone" object:Nil];
                    hud = [[MBProgressHUD alloc] initWithView:self.tableView];
                    [self.view addSubview:hud];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelFont = [UIFont systemFontOfSize:12];
                    hud.detailsLabelFont = [UIFont systemFontOfSize:12];
                    hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"审批失败", @"")];
                    hud.detailsLabelText = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"失败原因", @""),responseResult];
                     [hud showAnimated:YES whileExecutingBlock:^{
                        sleep(2);
                    } completionBlock:^{
                        [hud removeFromSuperview];
                        hud = nil;
                    }];
                }
            }
        }];
    }else{
        [[M2LoadHUD sharedHUD] show];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            for (int i = 0; i < self.selectedCellArray.count; i++) {
                NSString* sysId = [[self.messageArray objectAtIndex:[[self.selectedCellArray objectAtIndex:i] intValue]] objectForKey:@"SystemID"];
                NSString* msgId = [[self.messageArray objectAtIndex:[[self.selectedCellArray objectAtIndex:i] intValue]] objectForKey:@"MsgID"];
                //第一步，创建URL
                NSError* error;
                NSURL *url = [NSURL URLWithString:[kHttpBaseUrlString stringByAppendingString:@"/HandleSystemMessage"]];
                //第二步，创建请求
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
                NSString* bodyString = [NSString stringWithFormat:@"token=%@&employeeNO=%@&systemId=%@&msgID=%@&action=%@&comment=%@",[UserInfo sharedUserInfo].token,[UserInfo sharedUserInfo].employeeNo,sysId,msgId,actionString,comment];
                NSData * bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
                [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:bodyData];
                
                NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
               
                if(error.code == -1001){
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"timeout", @"")];
                    break;
                }else if (error.code == -1009){
                
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"检查网络连接", @"")];
                    break;
                }
                else{
                    NSArray *json = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingAllowFragments error:&error];
                    NSString* response = [[json objectAtIndex:0] objectForKey:@"key"];
                    _failReason = [[json objectAtIndex:0] objectForKey:@"key"];
                    if ([response isEqualToString:@"-1"]) {
                    }else{
                        if ([response isEqualToString:@"1"]) {
                            [_successIndexes addIndex:[[self.selectedCellArray objectAtIndex:i] intValue]];
                            
                        }else{
                            [_failIndexes addIndex:[[self.selectedCellArray objectAtIndex:i] intValue]];
                            break;
                        }
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                NSLog(@"操作完成");
                [[M2LoadHUD sharedHUD] dismiss];
                if ([_failIndexes count] == 0) {
                    hud = [[MBProgressHUD alloc] initWithView:self.tableView];
                    [self.view addSubview:hud];
                    hud.labelText = [NSString stringWithFormat:@"%ld %@",[_successIndexes count],NSLocalizedString(@"审批成功", @"")];
                    hud.mode = MBProgressHUDModeText;
                    [hud showAnimated:YES whileExecutingBlock:^{
                        sleep(2);
                    } completionBlock:^{
                        [hud removeFromSuperview];
                        hud = nil;
                    }];
                }else{

                    hud = [[MBProgressHUD alloc] initWithView:self.tableView];
                    [self.view addSubview:hud];
                    hud.labelFont = [UIFont systemFontOfSize:12];
                    hud.detailsLabelFont = [UIFont systemFontOfSize:12];
                    hud.labelText = [NSString stringWithFormat:@"%lu %@,%lu %@",(unsigned long)[_successIndexes count],NSLocalizedString(@"条审批成功", @""),(unsigned long)[_failIndexes count],NSLocalizedString(@"条审批失败", @"")];
                    hud.detailsLabelText = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"失败原因", @""),_failReason];
                    hud.mode = MBProgressHUDModeText;
                    [hud showAnimated:YES whileExecutingBlock:^{
                        sleep(2);
                    } completionBlock:^{
                        [hud removeFromSuperview];
                        hud = nil;
                    }];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HandleDone" object:Nil];
                number = number-(int)[_successIndexes count];
                indexArray = [NSMutableArray arrayWithObject:@""];
                [self.messageArray removeObjectsAtIndexes:_successIndexes];
                [self.tableView reloadData];
                self.tableView.userInteractionEnabled = YES;
                NSString* countString = nil;
                countString = [NSString stringWithFormat:@"%d",number];
                NSDictionary* countDic = @{@"count": countString};
                [[NSNotificationCenter defaultCenter] postNotificationName:kSysCountChanged object:self userInfo:countDic];
            });
        });
    }
}

/**
 *  选中所有cell
 */
-(void)selectAllCell
{
    for (int i = 0; i < self.messageArray.count; i++) {
        [self.selectedCellArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
}

/**
 *  取消所有cell选中
 */
-(void)cancelAllCell
{
    [self.selectedCellArray removeAllObjects];
}

/**
 *  减少审批数字
 */
-(void)minusMessageNumber
{
    number -= 1;
}

/**
 *  修改批量标识
 */
- (void)changeScrollContentSizeBatch
{
    _isBatchMode = YES;
}

/**
 *  修改取消批量标识
 */
- (void)changeScrollContentSizeNotBatch
{
    _isBatchMode = NO;
    _isCellSelected = NO;
}

/**
 *  改变cell选中状态
 */
- (void)changeAllCellSelectionState
{
    _isCellSelected = YES;
}

/**
 *  取消cell选中状态
 */
-(void)cancelAllSelected
{
    _isCellSelected = NO;
}

/**
 *  取消所有状态
 */
-(void)cancelAllState
{
    _isCellSelected = NO;
    self.isBatchMode = NO;
}

/**
 *  网络异常取消刷新
 *
 *  @return void
 */
#pragma Timeout
- (void)networkStopLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(doneLoadingTableViewData)];
        self.tableView.userInteractionEnabled = YES;
    });
}

@end
