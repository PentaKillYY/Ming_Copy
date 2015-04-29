//
//  BaseMessageViewController.m
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-11.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//
#import "BaseMessageViewController.h"
#import "Constant.h"
#import "MessageViewController.h"
#import "MessageDoneViewController.h"
#import "SystemMessageParser.h"
#import "M2SystemChooseListView.h"
#import "UserInfo.h"
#import "CommonMacro.h"
#import "PPiFlatSegmentedControl.h"
#import "NSString+FontAwesome.h"

@interface BaseMessageViewController ()<selectedIndexDelagate,UITextViewDelegate>
{
    int selectedNumber;
    int currentPage;
    UIView* titleView;
    UIView* rightView;
    UIView* leftView;
    UIButton* leftButton;
    UILabel* rightTitleLabel;
    UIImageView* titleImage;
    BOOL available;
    
    UIButton* approveButton;
    UIButton* rejectButton;
    
    M2SystemChooseListView* systemChooseList;
    MessageViewController* messageTable;
    MessageDoneViewController* messageDoneTable;

    UIView* customView;
    UITextView* textView;
    UITextField* approve;
    UITextField* refuse;
    UIButton* handleButton;
    int messageNumber;
    BOOL isHandled;
    UISegmentedControl* messageSeg;
    UIView* handleView;
    PPiFlatSegmentedControl *segmented;
}
@end

@implementation BaseMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];    
    segmented=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(15, 5, 290, 35) items:@[@{@"text":NSLocalizedString(@"待审批", @"")},
                                                                                                @{@"text":NSLocalizedString(@"已审批", @"")}]
                                                                          iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) { 
                                                                          }];
    segmented.color=[UIColor whiteColor];
    segmented.borderWidth=0.5;
    segmented.borderColor=[UIColor colorWithRed:87.0f/255.0f green:175.0f/255.0f blue:236.0f/255.0f alpha:1.0];
    segmented.selectedColor=[UIColor colorWithRed:87.0f/255.0f green:175.0f/255.0f blue:236.0f/255.0f alpha:1.0];
    segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:17],
                                NSForegroundColorAttributeName:[UIColor colorWithRed:87.0f/255.0f green:175.0f/255.0f blue:236.0f/255.0f alpha:1.0]};
    segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:17],
                                        NSForegroundColorAttributeName:[UIColor whiteColor]};
    segmented.delegate = self;
    [self.view addSubview:segmented];//审批tab

    isSystemChoose = NO;

    [self setNavigationBarView];
    
    available = YES;
    
    messageTable = [[MessageViewController alloc] initWithStyle:UITableViewStylePlain];
    messageDoneTable = [[MessageDoneViewController alloc] initWithStyle:UITableViewStylePlain];
    [self creatAllPagesForView];

    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.01;
    backView.hidden = YES;
    [self.view addSubview:backView];
    
    customView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT+110, 320, 110)];
    customView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:0.97];
    customView.alpha = 0.98;
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, 300, 60)];
    textView.delegate = self;
    textView.scrollEnabled = NO;
    textView.layer.borderWidth =1.2;
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont systemFontOfSize:16];
    textView.layer.borderColor = [UIColor colorWithRed:195.0f/255.0f green:195.0f/255.0f blue:195.0f/255.0f alpha:1.0].CGColor;
    [customView addSubview:textView];
    
    handleButton = [UIButton buttonWithType:UIButtonTypeCustom];//审批操作按钮
    [handleButton setFrame:CGRectMake(240, 10, 70, 20)];
    [handleButton setTitle:@"" forState:UIControlStateNormal];
    [handleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [handleButton addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [customView addSubview:handleButton];
    
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(10, 10, 70, 20)];
    [cancelButton setTitle:NSLocalizedString(@"cancel", @"") forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelHandleAction) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:cancelButton];
    [self.view addSubview:customView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSelectedAction) name:@"AddSelectedCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(minusSelectedAction) name:@"MinusSelectedCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(approveAction) name:@"ApproveAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rejectAction) name:@"RejectAction" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideContentView:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelBatchAction) name:@"HandleDone" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSystemChooseNotAvailable) name:@"isSystemChooseNotAvailable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSystemChooseAvailable) name:@"isSystemChooseAvailable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAllSelectedState) name:@"changeAllSelectedState" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddSelectedCount" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MinusSelectedCount" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ApproveAction" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RejectAction" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HandleDone" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BatchHandleDone" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"isSystemChooseNotAvailable" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"isSystemChooseAvailable" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeAllSelectedState" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)changeAllSelectedState
{
    rightTitleLabel.text = NSLocalizedString(@"全选", @"");
}

-(void)changeSystemChooseNotAvailable
{
    available = NO;
}

-(void)changeSystemChooseAvailable
{
    available = YES;
}

-(void)approveAction
{
    if ([rightTitleLabel.text isEqualToString:NSLocalizedString(@"批量操作", @"")]) {
        textView.tag = 1;
        [textView becomeFirstResponder];
    }else{
        if (selectedNumber == 0) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"没有选中任何消息", @"") message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"confirm", @"") otherButtonTitles:nil, nil];
            [alert show];
            
        }else{
            textView.tag = 1;
            [textView becomeFirstResponder];
        }
    }
}

-(void)rejectAction
{
    if ([rightTitleLabel.text isEqualToString:NSLocalizedString(@"批量操作", @"")]) {
        textView.tag = 2;
        [textView becomeFirstResponder];
    }else
    {
        if (selectedNumber == 0) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"没有选中任何消息", @"") message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"confirm", @"") otherButtonTitles:nil, nil];
            [alert show];
        }else{
            textView.tag = 2;
            [textView becomeFirstResponder];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationBarView
{
    /*************导航栏标题文字****************/
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:NSLocalizedString(@"审批列表", @"")];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [titleLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    /************导航栏下拉箭头************/
    titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(92, 17, 10, 10)];
    [titleImage setImage:[UIImage imageNamed:@"title_drop down IOS 1.png"]];
    /*************导航栏标题视图**************/
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    [titleView addSubview:titleLabel];
    [titleView addSubview:titleImage];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(systemChooseAction)];
    [titleView addGestureRecognizer:tap];
    self.navigationItem.titleView = titleView;
    /*************批量操作**************/
    if (IS_VERSION7) {
        rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 44)];
    }else
    {
        rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 60, 44)];
    }
    rightTitleLabel.tag = 0;
    [rightTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [rightTitleLabel setText:NSLocalizedString(@"批量操作", @"")];
    [rightTitleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [rightTitleLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
    [rightTitleLabel setBackgroundColor:[UIColor clearColor]];
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [rightView addSubview:rightTitleLabel];
    
    UITapGestureRecognizer* batchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(batchAction)];
    [rightView addGestureRecognizer:batchTap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
}

- (void)creatAllPagesForView
{
    currentPage = 0;
    
    messageTable.tableView.frame = CGRectMake(320*0,45, 320, self.view.frame.size.height -45.0f );
    [self addChildViewController:messageTable];
    [self.view addSubview:messageTable.tableView];
    
    messageDoneTable.tableView.frame = CGRectMake(320*1, 45, 320, self.view.frame.size.height -45.0f );
    [self addChildViewController:messageDoneTable];
    [self.view addSubview:messageDoneTable.tableView];
}

#pragma mark-
#pragma mark 界面按钮事件
- (void) btnActionShow
{
    if (currentPage == 1) {
        [self messageButtonAction];
    }
    else{
        [self messageDoneButtonAction];
    }
}

- (void)messageButtonAction
{
    NSLog(@"messageButtonAction");
    currentPage = 0;
    systemChooseList.systemSelected = [[NSMutableArray alloc] init];
    for (NSDictionary * sysdic in [UserInfo sharedUserInfo].systemList) {
        [systemChooseList.systemSelected addObject:[sysdic objectForKey:@"SystemID"]];
    }
    systemChooseList.isChanged = NO;
    [rightTitleLabel setText:NSLocalizedString(@"批量操作", @"")];
    [rightTitleLabel setFrame:CGRectMake(16, 0, 75, 44)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    [UIView animateWithDuration:0.1 animations:^{
        messageTable.tableView.hidden = NO;
        messageDoneTable.tableView.hidden = YES;
    }];
}

- (void)messageDoneButtonAction
{
    NSLog(@"---startpress----");
    currentPage = 1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageDoneshouldGetData" object:Nil];
    systemChooseList.systemSelected = [[NSMutableArray alloc] init];
    for (NSDictionary * sysdic in [UserInfo sharedUserInfo].systemList) {
        [systemChooseList.systemSelected addObject:[sysdic objectForKey:@"SystemID"]];
    }
    systemChooseList.isChanged = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(-20, 0, 44, 44);
    [leftButton setTitle:@"" forState:UIControlStateNormal];

    [UIView animateWithDuration:0.01 animations:^{
        messageTable.tableView.hidden = YES;
        messageDoneTable.tableView.hidden = NO;
        messageDoneTable.tableView.center = CGPointMake(320.0f/2, messageDoneTable.tableView.center.y);
    }];
    NSLog(@"---stoppress----");
}

- (void)systemChooseAction
{
    if (available) {
        if (isSystemChoose == YES) {
            isSystemChoose = NO;
            [systemChooseList hideListView];
            [self sysChooseDone];
        }else{
            if (currentPage == 0)
            {
                if (messageTable._isRefreshing == NO) {
                    isSystemChoose = YES;
                    rightView.userInteractionEnabled = NO;
                    [UIView animateWithDuration:0.1 animations:^{
                        titleImage.layer.transform =  CATransform3DMakeRotation(M_PI, 0, 0, 1);
                    } completion:^(BOOL finished){
                        if (systemChooseList == nil) {
                            systemChooseList = [[M2SystemChooseListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                            systemChooseList.ConfirmSystemDelegate = self;
                            [self.view addSubview:systemChooseList];
                        }
                        [systemChooseList showListView];
                    }];
                }
            }else
            {
                if (messageDoneTable._isRefreshing == NO) {
                    isSystemChoose = YES;
                    [UIView animateWithDuration:0.1 animations:^{
                        titleImage.layer.transform =  CATransform3DMakeRotation(M_PI, 0, 0, 1);
                    } completion:^(BOOL finished){
                        if (systemChooseList == nil) {
                            systemChooseList = [[M2SystemChooseListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                            systemChooseList.ConfirmSystemDelegate = self;
                            [self.view addSubview:systemChooseList];
                        }
                        [systemChooseList showListView];
                    }];
                }
            }
        }
    }
}

- (void)sysChooseDone
{
    rightView.userInteractionEnabled = YES;
    NSMutableString* sysIDString  = [[NSMutableString alloc] init];

    [UIView animateWithDuration:0.1 animations:^{
        titleImage.layer.transform =  CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    } completion:^(BOOL finished){
        if (currentPage == 0) {
            if ([systemChooseList.systemSelected count] > 0) {
                if ([systemChooseList.systemSelected count] == [UserInfo sharedUserInfo].systemList.count) {
                    [sysIDString appendString:@""];
                }else{
                    for (int i = 0; i < [systemChooseList.systemSelected count]; i++) {
                        [sysIDString appendString:[NSString stringWithFormat:@"%@;",[systemChooseList.systemSelected objectAtIndex:i]]];
                    }
                    [sysIDString replaceCharactersInRange:NSMakeRange([sysIDString length]-1, 1) withString:@""];
                }
               
            }else{
                [sysIDString appendString:@"-1"];
            }
            messageTable.systemIdString = [[NSString alloc] initWithString:sysIDString];
            messageTable.messageArray = nil;
            [messageTable ViewFrashData];
        }
        else{
            [messageDoneTable selectMessageFromDatabase:systemChooseList.systemSelected];
            [messageDoneTable.tableView reloadData];
        
        }
    }];
    isSystemChoose = NO;
}

- (void)batchAction
{
    if ([rightTitleLabel.text isEqualToString:NSLocalizedString(@"全选", @"")]) {
        
        if (rightTitleLabel.tag == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CellAllSelected" object:nil];
            selectedNumber = (int)[messageTable.messageArray count];
            [numberLabel setText:[NSString stringWithFormat:@"%d%@",selectedNumber,NSLocalizedString(@"选择", @"")]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AllCellSelected" object:Nil];
            [messageTable.tableView reloadData];
            
            rightTitleLabel.tag = 1;
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CancelAllSelected" object:nil];
            
            rightTitleLabel.text = NSLocalizedString(@"全选", @"");
            selectedNumber = 0;
            [numberLabel setText:[NSString stringWithFormat:@"%d%@",selectedNumber,NSLocalizedString(@"选择", @"")]];
            
            [messageTable.tableView reloadData];
            rightTitleLabel.tag = 0;
        }
    }
    else{
        
        if (messageTable._isRefreshing == NO){
            [rightTitleLabel setText:NSLocalizedString(@"全选", @"")];
//          [rightTitleLabel setFrame:CGRectMake(20, 0, 75, 44)];
            segmented.userInteractionEnabled = NO;
            UILabel* leftItem = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 60, 44)];
            
            leftItem.text = NSLocalizedString(@"cancel", @"");
            leftItem.backgroundColor = [UIColor clearColor];
            leftItem.textColor = [UIColor whiteColor];
            leftItem.font = [UIFont systemFontOfSize:14.0];
            leftItem.userInteractionEnabled = YES;
            UITapGestureRecognizer* cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBatchAction)];
            [leftItem addGestureRecognizer:cancelTap];
            
            UIBarButtonItem*leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
            
            
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                               target:nil action:nil];
            
            negativeSpacer.width=6;

            self.navigationItem.leftBarButtonItems = @[negativeSpacer,leftBarButtonItem];

            [self addHandleButton];
            
            numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
            [numberLabel setTextAlignment:NSTextAlignmentCenter];
            [numberLabel setText:[NSString stringWithFormat:@"%d%@",selectedNumber,NSLocalizedString(@"选择", @"")]];
            [numberLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
            [numberLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
            [numberLabel setBackgroundColor:[UIColor clearColor]];
            
            UIView* numberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
            
            [numberView addSubview:numberLabel];
            self.navigationItem.titleView = numberView;

            [[NSNotificationCenter defaultCenter] postNotificationName:@"EnterBatchMode" object:nil];
            [messageTable.successIndexes removeAllIndexes];
            [messageTable.failIndexes removeAllIndexes];
            [messageTable.tableView reloadData];
        }
    }
}

- (void)cancelBatchAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitBatchMode" object:nil];
    selectedNumber = 0;
//    [numberLabel setText:[NSString stringWithFormat:@"已选择%d项",selectedNumber]];
    [rightTitleLabel setText:NSLocalizedString(@"批量操作", @"")];
//    [rightTitleLabel setFrame:CGRectMake(16, 0, 75, 44)];
    rightTitleLabel.tag = 0;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(systemChooseAction)];
    [titleView addGestureRecognizer:tap];
    self.navigationItem.titleView = titleView;
    if ([super respondsToSelector:@selector(updateNavBarItem)]) {
        [super updateNavBarItem];
    }
    [approveButton removeFromSuperview];
    [rejectButton removeFromSuperview];
    [handleView removeFromSuperview];
    segmented.userInteractionEnabled = YES;
    
    [messageTable.tableView reloadData];
}

-(void)addSelectedAction
{
    if (selectedNumber < messageTable.messageArray.count) {
        selectedNumber += 1 ;
        rightTitleLabel.tag = 1;
    }
    
    [numberLabel setText:[NSString stringWithFormat:@"%d%@",selectedNumber,NSLocalizedString(@"选择", @"")]];

}

-(void)minusSelectedAction
{
    
    if (selectedNumber > 0) {
        selectedNumber -= 1;
        rightTitleLabel.tag = 1;
    }
    [numberLabel setText:[NSString stringWithFormat:@"%d%@",selectedNumber,NSLocalizedString(@"选择", @"")]];
}

#pragma mark-
#pragma mark HandleAction
-(void)addHandleButton
{
    approveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    handleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 54.0f, 320.0f, 54.0f)];
    [handleView setBackgroundColor:[UIColor colorWithRed:219.0f/255.0f  green:218.0f/255.0f  blue:221.0f/255.0f alpha:1.0]];
        approveButton.frame = CGRectMake(65, 7 , 30.0f, 30);
        
        rejectButton.frame = CGRectMake(160+65, 7 , 30, 30);
    
    [approveButton setBackgroundImage:LoadImageWithType(@"approve_2", @"png") forState:UIControlStateNormal];
    [approveButton setBackgroundImage:LoadImageWithType(@"approve_3", @"png") forState:UIControlStateHighlighted];
    [approveButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [approveButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [approveButton addTarget:self action:@selector(approveAction) forControlEvents:UIControlEventTouchUpInside];
    [approveButton setTitle:NSLocalizedString(@"同意", @"") forState:UIControlStateNormal];
    [approveButton setTitleEdgeInsets:UIEdgeInsetsMake(48, 0, 0, 0)];
    approveButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:7];
    [approveButton setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [approveButton setTitleColor:[UIColor colorWithRed:88.0f/255.0f green:161.0f/255.0f blue:245.0f/255.0f alpha:1.0] forState:UIControlStateHighlighted];
    [handleView addSubview:approveButton];

    [rejectButton setBackgroundImage:LoadImageWithType(@"reject_2", @"png") forState:UIControlStateNormal];
    [rejectButton setBackgroundImage:LoadImageWithType(@"reject_3", @"png") forState:UIControlStateHighlighted];
    [rejectButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [rejectButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [rejectButton addTarget:self action:@selector(rejectAction) forControlEvents:UIControlEventTouchUpInside];
    [rejectButton setTitle:NSLocalizedString(@"拒绝", @"") forState:UIControlStateNormal];
    [rejectButton setTitleEdgeInsets:UIEdgeInsetsMake(48, 0, 0, 0)];
    
    rejectButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:7];
    [rejectButton setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [rejectButton setTitleColor:[UIColor colorWithRed:88.0f/255.0f green:161.0f/255.0f blue:245.0f/255.0f alpha:1.0] forState:UIControlStateHighlighted];
    [handleView addSubview:rejectButton];
    [self.view addSubview:handleView];
}

- (void)changeContentViewPoint:(NSNotification *)notification
{
    if (!backView.hidden) {
        return;
    }
    
    backView.hidden = NO;
    [UIView animateWithDuration:0.1 animations:^{
        backView.alpha = 0.20;
        
    }];
    
    NSString* title = [[NSString alloc] init];

        if (!textView.tag) {
            
        }else{
            if (textView.tag == 1) {
                title = NSLocalizedString(@"同意", @"");
            }else if (textView.tag == 2)
            {
                title = NSLocalizedString(@"拒绝", @"");
            }
            textView.text = @"";
            [handleButton setTitle:title forState:UIControlStateNormal];
        }
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;//得到键盘弹出后的键盘视图所在y坐标
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        if (IOS_VERSION>=7) {
            customView.center = CGPointMake(customView.center.x, keyBoardEndY - customView.bounds.size.height/2.0-44-20);//keyBoardEndY的坐标包括了状态栏的高度，要减去
        }else{
        customView.center = CGPointMake(customView.center.x, keyBoardEndY-20-44 - customView.bounds.size.height/2.0);//keyBoardEndY的坐标包括了状态栏的高度，要减去
        }
    }];
//    [textView becomeFirstResponder];
}

-(void)hideContentView:(NSNotification*)notification
{
    backView.hidden = YES;
    [UIView animateWithDuration:0.1 animations:^{
        backView.alpha = 0.01;
        
    }];
    
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        customView.center = CGPointMake(customView.center.x, SCREEN_HEIGHT+55);//keyBoardEndY的坐标包括了状态栏的高度，要减去
    }];
}

-(void)cancelHandleAction
{
    [textView resignFirstResponder];
}

-(void)handleAction:(id)sender
{
    [self cancelHandleAction];
    UIButton* button = (UIButton*)sender;
    NSDictionary* dic = @{@"action": button.titleLabel.text,@"comment":textView.text,@"mode":rightTitleLabel.text};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HandleMessage" object:self userInfo:dic];
}

#pragma CustomSegmentDelegate
-(void)currentIndex:(NSUInteger)currentIndex
{
    if (currentIndex == 0) {
        [self messageButtonAction];
    }
    else
    {
        [self messageDoneButtonAction];
    }
}

- (void)textViewDidChange:(UITextView *)atextView{
    NSInteger number = [atextView.text length];
    if (number > 15) {
        atextView.text = [atextView.text substringToIndex:15];
        number = 15;
    }
}
@end
