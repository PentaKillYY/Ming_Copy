//
//  MessageDoneViewController.m
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-11.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "MessageDoneViewController.h"
#import "SystemMessageParser.h"
#import "EGORefreshTableHeaderView.h"
#import <FMDatabase.h>
#import <FMDatabaseAdditions.h>
#import "UserInfo.h"
#import "CommonMacro.h"
#import "Go2Util.h"
#import <QuartzCore/QuartzCore.h>

@interface MessageDoneViewController ()<EGORefreshDelegate>
{
    NSInteger _rowCount;
    
    EGORefreshTableHeaderView *_headerRefreshView;
    UIButton* _bottomRefresh;
    NSMutableArray * createdByArray;
    NSMutableArray* messageTitleArray;
    NSMutableArray* createdTimeArray;
    NSMutableArray* systemLogoArray;
    NSMutableArray* employeeLogoArray;
    NSMutableArray* sqliteArray;
    NSMutableArray* chosenSystemArray;
}

@end

@implementation MessageDoneViewController
@synthesize _isRefreshing;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _rowCount = 20;
    self.tableView.rowHeight = 64;
    
    _headerRefreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - self.tableView.frame.size.height, 320, self.tableView.bounds.size.height)];
    _headerRefreshView.delegate = self;
    [self.tableView addSubview:_headerRefreshView];
   
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldGetMessageDoneData) name:@"MessageDoneshouldGetData" object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStopLoading) name:@"SystemDoneTimeoutNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStopLoading) name:@"StstemDoneNetErrorNotification" object:nil];
    
    [super viewWillAppear:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MessageDoneshouldGetData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SystemDoneTimeoutNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"StstemDoneNetErrorNotification" object:nil];
    [super viewDidDisappear:YES];
}

/**
 *  显示列表（获取本地数据库、网络请求、主线程更新页面）
 */
- (void)shouldGetMessageDoneData
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSMutableArray* listArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [UserInfo sharedUserInfo].systemList.count; i++) {
            [listArray addObject:[[[UserInfo sharedUserInfo].systemList objectAtIndex:i] objectForKey:@"SystemID"]];
        }
        [self selectMessageFromDatabase:listArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [self.tableView reloadData];
            [self ViewFrashData];
        });
    });

    [self ViewFrashData];
}

/**
 *  触发刷新
 */
-(void)ViewFrashData{
    if (sqliteArray.count > 0 ) {
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }else{
    
        [self.tableView setContentInset:UIEdgeInsetsMake(65, 0, 0, 0)];
        
    }
    [self performSelector:@selector(messagedoneManualRefresh) withObject:nil afterDelay:0.1];

}

/**
 *  手动刷新结束
 */
-(void)messagedoneManualRefresh{
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
    if (createdByArray.count == 0) {
        _bottomRefresh.hidden = YES;
        return 0;
    }
    else if (createdByArray.count <=20 ) {
        _bottomRefresh.hidden = NO;
        
        [_bottomRefresh setTitle:NSLocalizedString(@"已加载全部数据", @"") forState:UIControlStateNormal];
        return createdByArray.count;
    }else {
        if (_rowCount < createdByArray.count ) {
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"MessageDoneCell" owner:self options:nil];
        if ([nib count] > 0) {
            cell = self.messageDonecell;
        }else{
        
        }
    }
    self.createdByLabel.text = [createdByArray objectAtIndex:indexPath.row];
    self.messageTitleLabel.text = [messageTitleArray objectAtIndex:indexPath.row];
    self.messageTitleLabel.textColor = HexColor(0X4D4D4D);
    NSString* timeString =[NSString stringWithString:[createdTimeArray objectAtIndex:indexPath.row]];
    [self.systemLogoView setImageWithURL:[NSURL URLWithString:[systemLogoArray objectAtIndex:indexPath.row]]];
    [self.employeeLogoView setImageWithURL:[NSURL URLWithString:[employeeLogoArray objectAtIndex:indexPath.row]]];
    [self.employeeLogoView.layer setMasksToBounds:YES];
    self.employeeLogoView.layer.cornerRadius = 21;
    self.timeLabel.text = [self judgeDate:timeString];
    self.timeLabel.textColor = HexColor(0X4D4D4D);
    return cell;
}

/**
 *  tableview点击
 *
 *  @param tableView tableview
 *  @param indexPath 行标识
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [Go2Util go2MessageDoneDetailFrom:self responseMessage:sqliteArray IntegerNumber:indexPath.row Count:createdByArray.count];
    NSLog(@"!!!!!%f",self.tableView.frame.size.height);
    
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
	
	[self reloadTableViewDataSource];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.refreshTime = [formatter stringFromDate:[UserInfo sharedUserInfo].msgDoneFreshTime];
    if (self.refreshTime == nil) {
        self.refreshTime = @"";
    }
    
    [[SystemMessageParser sharedHttpParser] postSystemMessageDonestartTime:self.refreshTime OnCompletion:^(NSArray* json){
        if (self.messageDoneArray == nil ) {
            self.messageDoneArray = [NSMutableArray arrayWithArray:json];
        }else{
            NSRange range = NSMakeRange(0, [json count]);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.messageDoneArray insertObjects:json atIndexes:indexSet];
            NSSet* tempSet = [NSSet setWithArray:self.messageDoneArray];
            NSSortDescriptor* descripor2=[NSSortDescriptor sortDescriptorWithKey:@"CreatedTime" ascending:NO];
            self.messageDoneArray = [NSMutableArray arrayWithArray:[tempSet sortedArrayUsingDescriptors:@[descripor2]]];
        }
        NSDate* now = [NSDate date];
        now = [now dateByAddingTimeInterval:-(60*30)];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.refreshTime = [formatter stringFromDate:now];
        [UserInfo sharedUserInfo].msgDoneFreshTime = [formatter dateFromString:self.refreshTime];
        [[UserInfo sharedUserInfo] synchronize];
        [self insertMessageIntoDatabase];
       
        NSMutableArray* listArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [UserInfo sharedUserInfo].systemList.count; i++) {
            [listArray addObject:[[[UserInfo sharedUserInfo].systemList objectAtIndex:i] objectForKey:@"SystemID"]];
        }
        if (chosenSystemArray == nil) {
            chosenSystemArray = [NSMutableArray arrayWithArray:listArray];
        }
        [self selectMessageFromDatabase:chosenSystemArray];
        dispatch_async(dispatch_get_main_queue(), ^{
 
            [self performSelector:@selector(doneLoadingTableViewData)];
        });
    }] ;
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
	[_headerRefreshView egoRefreshScrollViewDidScroll:scrollView];
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, 320, SCREEN_HEIGHT-45-44-20);
}

/**
 *  scrollview滑动结束
 *
 *  @param scrollView scrollview
 *  @param decelerate decelerate
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_headerRefreshView egoRefreshScrollViewDidEndDragging:scrollView];
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
 *  结束加载
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

#pragma -
#pragma mark 界面事件

/**
 *  加载更多操作
 */
- (void)loadMoreMessage
{
    if (_rowCount < createdByArray.count && (createdByArray.count - _rowCount) >= 20) {
        _rowCount += 20;
        self.tableView.contentSize = CGSizeMake(320, _rowCount*64+30);
    }
    else if ((createdByArray.count - _rowCount)<20)
    {
        _rowCount = createdByArray.count;
    }

     [self.tableView reloadData];

}

#pragma -
#pragma mark FMDB

/**
 *  创建数据库表
 */
- (void)createMessageDoneTable
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",[UserInfo sharedUserInfo].employeeNo]];
    
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;  
    }else{
        [db open];
        [db setShouldCacheStatements:YES];
        
        if ([db tableExists:@"MessageDoneTable"]) {
            NSLog(@"table exists");
        }else{
            [db executeUpdate:@"CREATE TABLE MessageDoneTable(MsgID text,MsgTitle text,Action text,ActionBy text,ActionTime text,CreatedBy text,CreatedTime text,SystemID text,SystemName text,SystemLogo text,ActionComment text,employee_image text,MsgContent BLOB)"];
        }
        [db close];
    }
}

/**
 *  从数据库中读取数据
 *
 *  @param selectedSystemArray 选中的系统
 */
- (void)selectMessageFromDatabase:(NSMutableArray*)selectedSystemArray
{
    NSLog(@"startSelect");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"Message.db"];
    createdByArray = [NSMutableArray new];
    messageTitleArray = [NSMutableArray new];
    createdTimeArray = [NSMutableArray new];
    systemLogoArray = [NSMutableArray new];
    employeeLogoArray = [NSMutableArray new];
    sqliteArray = [NSMutableArray new];
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    chosenSystemArray = [NSMutableArray arrayWithArray:selectedSystemArray];
    if (![db open]) {
        NSLog(@"Could not open db.");
    }else{
        [db open];
        [db setShouldCacheStatements:YES];

            FMResultSet* rs = [db executeQuery:@"SELECT * FROM  MessageDoneTable order by  ActionTime desc"];
            while ([rs next]) {
                if ([selectedSystemArray containsObject:[rs stringForColumn:@"SystemID"]]){
                    [createdByArray addObject:[rs stringForColumn:@"CreatedBy"]];
                    [messageTitleArray addObject:[rs stringForColumn:@"MsgTitle"]];
                    [createdTimeArray addObject:[rs stringForColumn:@"ActionTime"]];
                    [systemLogoArray addObject:[rs stringForColumn:@"SystemLogo"]];
                    [employeeLogoArray addObject:[rs stringForColumn:@"employee_image"]];
                    NSDictionary* dic = @{@"MsgID":[rs stringForColumn:@"MsgID"],
                                          @"MsgTitle":[rs stringForColumn:@"MsgTitle"],
                                          @"MsgContent":[NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"MsgContent"]],
                                          @"Action":[rs stringForColumn:@"Action"],
                                          @"ActionBy":[rs stringForColumn:@"ActionBy"],
                                          @"ActionTime":[rs stringForColumn:@"ActionTime"],
                                          @"CreatedBy":[rs stringForColumn:@"CreatedBy"],
                                          @"CreatedTime":[rs stringForColumn:@"CreatedTime"],
                                          @"SystemID":[rs stringForColumn:@"SystemID"],
                                          @"SystemName":[rs stringForColumn:@"SystemName"],
                                          @"SystemLogo":[rs stringForColumn:@"SystemLogo"],
                                          @"ActionComment":[rs stringForColumn:@"ActionComment"],
                                          @"employee_image":[rs stringForColumn:@"employee_image"]
                                          };
                    [sqliteArray addObject:dic];

                }
                
            }
            [db close];
    }
    NSLog(@"finishSelect");
}

/**
 *  插入数据库操作
 */
-(void)insertMessageIntoDatabase
{
    NSLog(@"startInsert");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"Message.db"];
    
    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }else{
        [db open];
        [db setShouldCacheStatements:YES];
        
        for (int j = 0; j < self.messageDoneArray.count; j++) {
            [db executeUpdate:@"INSERT INTO MessageDoneTable(MsgID,MsgTitle,Action,ActionBy,ActionTime,CreatedBy,CreatedTime,SystemID,SystemName,SystemLogo,ActionComment,employee_image,MsgContent) SELECT ?,?,?,?,?,?,?,?,?,?,?,?,? where not exists (SELECT * From MessageDoneTable where MsgID=?)",
             [[self.messageDoneArray objectAtIndex:j] objectForKey:@"MsgID"],
             [[self.messageDoneArray objectAtIndex:j] objectForKey:@"MsgTitle"],
             [[self.messageDoneArray objectAtIndex:j] objectForKey:@"Action"],
             [[self.messageDoneArray objectAtIndex:j] objectForKey:@"ActionBy"],
             [[self.messageDoneArray objectAtIndex:j] objectForKey:@"ActionTime"],
             [[self.messageDoneArray objectAtIndex:j] objectForKey:@"CreatedBy"],
             [[self.messageDoneArray objectAtIndex:j] objectForKey:@"CreatedTime"],
             [[self.messageDoneArray objectAtIndex:j] objectForKey:@"SystemID"],
             [[self.messageDoneArray objectAtIndex:j] objectForKey:@"SystemName"],
             [[self.messageDoneArray objectAtIndex:j] objectForKey:@"SystemLogo"],
             [[self.messageDoneArray objectAtIndex:j] objectForKey:@"ActionComment"],
             [[self.messageDoneArray objectAtIndex:j] objectForKey:@"employee_image"],
             [NSKeyedArchiver archivedDataWithRootObject:[[self.messageDoneArray objectAtIndex:j] objectForKey:@"MsgContent"]],
             [[self.messageDoneArray objectAtIndex:j] objectForKey:@"MsgID"]
             ];
        }
    }
    [db close];
    
    NSLog(@"finishInsert");
}

#pragma Timeout

/**
 *  网络异常停止加载
 */

- (void)networkStopLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(doneLoadingTableViewData)];
    });
}
@end
