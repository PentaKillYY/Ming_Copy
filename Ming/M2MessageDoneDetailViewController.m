//
//  M2MessageDoneDetailViewController.m
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-17.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2MessageDoneDetailViewController.h"
#import "M2AvatarView.h"
#import "M2BoderedView.h"
#import "CommonMacro.h"

@interface M2MessageDoneDetailViewController ()
{
    UIButton* upButton;
    UIButton* downButton;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) UIView *messageInfo;

@property (weak, nonatomic) IBOutlet UIView *employee_view;
@property (weak, nonatomic) IBOutlet UIView *title_View;
@property (weak, nonatomic) IBOutlet UILabel *message_title;
@property (weak, nonatomic) IBOutlet M2AvatarView *employee_logo;
@property (weak, nonatomic) IBOutlet UILabel *employee_name;

@property (weak, nonatomic) IBOutlet UILabel *created_time;
@property (weak, nonatomic) IBOutlet UIImageView *system_logo;

@property (strong, nonatomic) UIView *infoDetail_view;
@property (weak, nonatomic) IBOutlet UILabel *approveInfoLabel;
@property (weak, nonatomic) IBOutlet M2BoderedView *approve_view;
@property (weak, nonatomic) IBOutlet UILabel *actionBy_label;
@property (weak, nonatomic) IBOutlet UILabel *actionTime_label;
@property (weak, nonatomic) IBOutlet UILabel *action_label;
@property (weak, nonatomic) IBOutlet UILabel *actioncComment_label;
@property (weak, nonatomic) IBOutlet UIView *rightBarView;

@end

@implementation M2MessageDoneDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.responseArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:NSLocalizedString(@"审批详情", @"")];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [titleLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleLabel;
    [self updateRightBar];
    [self createTitleView];
    [self createEmployeeView];
    [self createMessageInfoView];
    [self createInfoDetailView];
    [self createApproveView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  更新下一条、上一条按钮状态
 */
-(void)updateRightBar
{
    upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.responseArray.count == 1) {
        [upButton setBackgroundImage:LoadImageWithType(@"up_unavailable", @"png") forState:UIControlStateNormal];
        upButton.userInteractionEnabled = NO;
        [downButton setBackgroundImage:LoadImageWithType(@"down_unavailable", @"png") forState:UIControlStateNormal];
        downButton.userInteractionEnabled = NO;
        
    }else{
        if (self.indexNumber == 0) {
            [upButton setBackgroundImage:LoadImageWithType(@"up_unavailable", @"png") forState:UIControlStateNormal];
            upButton.userInteractionEnabled = NO;
            [downButton setBackgroundImage:LoadImageWithType(@"down", @"png") forState:UIControlStateNormal];
            
        }else if (self.indexNumber == self.responseArray.count -1)
        {
            [upButton setBackgroundImage:LoadImageWithType(@"up", @"png") forState:UIControlStateNormal];
            upButton.userInteractionEnabled = YES;
            
            [downButton setBackgroundImage:LoadImageWithType(@"down_unavailable", @"png") forState:UIControlStateNormal];
            downButton.userInteractionEnabled = NO;
        }
        else{
            [upButton setBackgroundImage:LoadImageWithType(@"up", @"png") forState:UIControlStateNormal];
            upButton.userInteractionEnabled = YES;
            [downButton setBackgroundImage:LoadImageWithType(@"down", @"png") forState:UIControlStateNormal];
        }
    }
    
    [upButton addTarget:self action:@selector(lastMessageButton) forControlEvents:UIControlEventTouchUpInside];

    [downButton addTarget:self action:@selector(nextMessageButton) forControlEvents:UIControlEventTouchUpInside];
    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(00, 0, 91, 49)];
    if (IS_VERSION7) {
        [upButton setFrame:CGRectMake(20, 5, 38, 38)];
        [downButton setFrame:CGRectMake(58, 5, 38, 38)];
    }else
    {
        [upButton setFrame:CGRectMake(10, 5, 38, 38)];
        [downButton setFrame:CGRectMake(48, 5, 38, 38)];
    }

    [rightView addSubview:upButton];
    [rightView addSubview:downButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
}

/**
 *  添加标题view
 */
-(void) createTitleView
{
    self.message_title.text = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"MsgTitle"];
}

/**
 *  添加员工信息view
 */
- (void)createEmployeeView
{
    [self.employee_logo setImageWithURL:[NSURL URLWithString:[[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"employee_image"]]];

    self.employee_name.text = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"CreatedBy"];

    self.employee_name.frame = CGRectMake(71, 3, 190, 21);
    
    [self.system_logo setImageWithURL:[NSURL URLWithString:[[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"SystemLogo"]]];
    self.created_time.text = [[[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"CreatedTime"] substringToIndex:10];
    self.created_time.textColor = HexColor(0X4D4D4D);
}

/**
 *  添加messageview
 */
-(void)createMessageInfoView
{
    BOOL isList = NO;
    self.messageInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 144, 320, 60)];
    self.messageInfo.backgroundColor = [UIColor whiteColor];
    NSInteger valueNumber = 0;
    CGFloat height= 0.0;
    NSArray* contentArray = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"MsgContent"];
    for (NSDictionary* contentDic in contentArray) {
        if ([[contentDic objectForKey:@"Field1"] isKindOfClass:[NSArray class]]) {
            NSLog(@"is Array");
            isList = YES;
        }
        else{
            UILabel* value1Label = [[UILabel alloc] initWithFrame:CGRectMake(100, valueNumber*20, 200, 20)];
            value1Label.numberOfLines = 0;
            value1Label.lineBreakMode = NSLineBreakByWordWrapping;
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
            value1Label.backgroundColor = [UIColor clearColor];
            value1Label.text = [NSString stringWithFormat:@"%@",[contentDic objectForKey:@"Field1"]];
            value1Label.font = [UIFont systemFontOfSize:14];
            CGSize size = CGSizeMake(187,2000);
            CGSize labelsize = [value1Label.text sizeWithFont:font constrainedToSize:size lineBreakMode:value1Label.lineBreakMode];
            value1Label.textColor = HexColor(0X4D4D4D);

            UILabel* value0Label = [[UILabel alloc] initWithFrame:CGRectMake(14, height+5, 100, 20)];
            value0Label.numberOfLines = 0;

            value0Label.backgroundColor = [UIColor clearColor];
            value0Label.text = [NSString stringWithFormat:@"%@:",[contentDic objectForKey:@"Field0"]];
            value0Label.font = [UIFont systemFontOfSize:14];
            CGSize size2 = CGSizeMake(100, 2000);
            CGSize labelsize2 = [value0Label.text sizeWithFont:font constrainedToSize:size2 lineBreakMode:value0Label.lineBreakMode];
            if (labelsize.height >= labelsize2.height) {
                value1Label.frame = CGRectMake(119, height+5, 187, labelsize.height+3);
                value0Label.frame = CGRectMake(14, height+5, 100, labelsize2.height+3);
            }else{
                value1Label.frame = CGRectMake(119, height+5, 187, labelsize.height+3);
                value0Label.frame = CGRectMake(14, height+5, 100, labelsize2.height+3);
            }
            
            [self.messageInfo addSubview:value1Label];
            [self.messageInfo addSubview:value0Label];
            
            if (labelsize.height == 0) {
                labelsize.height = 18;
            }
            if (labelsize.height >= labelsize2.height) {
                height += labelsize.height+8;
            }else{
                height += labelsize2.height+8;
            }

            valueNumber += 1;
        }
    }
    self.messageInfo.frame = CGRectMake(0, 96, 320, height+10);
    
    if (isList) {
        UILabel* seperateLine = [[UILabel alloc] initWithFrame:CGRectMake(14, height-1+10, 320-28, 1)];
        seperateLine.backgroundColor = [UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0];
        [self.messageInfo addSubview:seperateLine];
    }else
    {
        UILabel* seperateLine = [[UILabel alloc] initWithFrame:CGRectMake(0, height-1+10, 320, 1)];
        seperateLine.backgroundColor = [UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0];
        [self.messageInfo addSubview:seperateLine];
    }

    [self.contentScrollView addSubview:self.messageInfo];
}

/**
 *  添加infoview
 */
-(void)createInfoDetailView
{
    NSArray* contentArray = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"MsgContent"];

    BOOL isList = NO;
    for (NSDictionary* contentDic in contentArray)
    {
        if ([[contentDic objectForKey:@"Field1"] isKindOfClass:[NSArray class]])
        {
            isList = YES;
        }
        
    }
    if (isList == YES) {
        self.infoDetail_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        self.infoDetail_view.backgroundColor = [UIColor whiteColor];
        NSInteger columnNumber = 0;
        CGFloat rowheight = 0;
        CGFloat listHeight = 0;
        int listNumber = 0;
        for (NSDictionary* contentDic in contentArray) {
            
            if ([[contentDic objectForKey:@"Field1"] isKindOfClass:[NSArray class]]) {
                NSLog(@"is Array");
                
                UILabel* listName = [[UILabel alloc] initWithFrame:CGRectMake(14, listHeight+rowheight+5+listNumber*5, 306, 20)];
                listName.text =[NSString stringWithFormat:@"%@:",[contentDic objectForKey:@"Field0"]] ;
                listName.font = [UIFont systemFontOfSize:14];
                [self.infoDetail_view addSubview:listName];
                
                NSArray* listArray = [contentDic objectForKey:@"Field1"];
                for (NSDictionary* rowDic in listArray) {
                    columnNumber = [rowDic allKeys].count;
                    CGSize labelsize;
                    CGFloat maxLabelSize = 0.0;
                    for (int j = 0; j < columnNumber; j++) {
                        
                        UILabel* rowLabel = [[UILabel alloc] initWithFrame:CGRectMake(j*288/columnNumber+2, 0, 288/columnNumber, 20)];
                        rowLabel.numberOfLines = 0;
                        
                        rowLabel.lineBreakMode = NSLineBreakByWordWrapping;
                        UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
                        rowLabel.backgroundColor = [UIColor clearColor];
                        rowLabel.text = [rowDic objectForKey:[NSString stringWithFormat:@"Field%d",j]];
                        rowLabel.font = [UIFont systemFontOfSize:12];
                        rowLabel.textColor = HexColor(0X4D4D4D);
                        CGSize size = CGSizeMake(282/columnNumber,2000);
                        labelsize = [rowLabel.text sizeWithFont:font constrainedToSize:size lineBreakMode:rowLabel.lineBreakMode];
                        
                        if (labelsize.height >= maxLabelSize) {
                            maxLabelSize = labelsize.height;
                        }
                        
                        rowLabel.frame = CGRectMake(j*282/columnNumber+14+j*5, rowheight+listHeight+15+listNumber*5+9, 282/columnNumber, labelsize.height+8);
                        
                        [self.infoDetail_view addSubview:rowLabel];
                    }
                    rowheight += maxLabelSize +5;
                    
                }
                listHeight += 15;
                listNumber += 1;
            }
        }
        self.infoDetail_view.frame = CGRectMake(0, self.messageInfo.frame.origin.y+self.messageInfo.frame.size.height, 320, listHeight+rowheight+10+5+5);
        UILabel* seperateLine = [[UILabel alloc] initWithFrame:CGRectMake(0, listHeight+rowheight+5+5+10-1, 320, 1)];
        seperateLine.backgroundColor = [UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0];
        [self.infoDetail_view addSubview:seperateLine];
        self.contentScrollView.contentSize = CGSizeMake(320, 10+21+136+10+15+self.infoDetail_view.frame.origin.y+self.infoDetail_view.frame.size.height);
        [self.contentScrollView addSubview:self.infoDetail_view];

    }else{
        self.contentScrollView.contentSize=CGSizeMake(320, self.approve_view.height+self.approve_view.y+50);
    }
}

/**
 *  添加审批内容view
 */
-(void)createApproveView
{
    NSArray* contentArray = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"MsgContent"];

    BOOL isList = NO;
    for (NSDictionary* contentDic in contentArray)
    {
        if ([[contentDic objectForKey:@"Field1"] isKindOfClass:[NSArray class]])
        {
            isList = YES;
        }
    }
    NSLog(@"获取内容，形式是否为数组，%@",isList?@"YES":@"NO");
    
    if (isList == YES) {
        self.approveInfoLabel.frame = CGRectMake(20, self.infoDetail_view.frame.origin.y+self.infoDetail_view.frame.size.height+15, 280, 21);
        self.approve_view.frame = CGRectMake(20, self.approveInfoLabel.frame.origin.y+self.approveInfoLabel.frame.size.height+5, 280, 136);
        self.actionBy_label.text = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"ActionBy"];
        self.actionBy_label.textColor = HexColor(0X4D4D4D);
        self.actionTime_label.text = [[[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"ActionTime"] substringToIndex:10];
        self.actionTime_label.textColor = HexColor(0X4D4D4D);
        self.action_label.text = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"Action"];
        self.action_label.textColor = HexColor(0X4D4D4D);
        self.actioncComment_label.text = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"ActionComment"];
        self.actioncComment_label.textColor = HexColor(0X4D4D4D);
    }else
    {
        self.approveInfoLabel.frame = CGRectMake(20, self.messageInfo.frame.origin.y+self.messageInfo.frame.size.height+15, 280, 21);
        if([self getShowComment])
        {
            self.approve_view.frame = CGRectMake(20, self.approveInfoLabel.frame.origin.y+self.approveInfoLabel.frame.size.height+5, 280, 100);
        }
        else
        {
            self.approve_view.frame = CGRectMake(20, self.approveInfoLabel.frame.origin.y+self.approveInfoLabel.frame.size.height+5, 280, 136);
        }
        self.actionBy_label.text = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"ActionBy"];
        self.actionBy_label.textColor = HexColor(0X4D4D4D);
        self.actionTime_label.text = [[[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"ActionTime"] substringToIndex:10];
        self.actionTime_label.textColor = HexColor(0X4D4D4D);
        self.action_label.text = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"Action"];
        self.action_label.textColor = HexColor(0X4D4D4D);
        self.actioncComment_label.text = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"ActionComment"];
        self.actioncComment_label.textColor = HexColor(0X4D4D4D);
    }
    
    if([self getShowComment])
    {
        for (UIView *eachView in [self.approve_view subviews])
        {
            if([eachView.restorationIdentifier isEqualToString:@"commentView"])
            {
                [eachView removeFromSuperview];
            }
        }
    }
}

/**
 *  上一条message
 */
-(void)lastMessageButton
{
    [downButton setBackgroundImage:LoadImageWithType(@"down", @"png") forState:UIControlStateNormal];
    downButton.userInteractionEnabled = YES;

    if (self.indexNumber <= 0) {
    }else{
        self.indexNumber -= 1;
        [self.messageInfo removeFromSuperview];
        [self.infoDetail_view removeFromSuperview];
        [self createTitleView];
        [self createEmployeeView];
        [self createMessageInfoView];
        [self createInfoDetailView];
        [self createApproveView];
        if (self.indexNumber == 0) {
            [upButton setBackgroundImage:LoadImageWithType(@"up_unavailable", @"png") forState:UIControlStateNormal];
            upButton.userInteractionEnabled = NO;
        }
    }
}

/**
 *  下一条message
 */
-(void)nextMessageButton
{
    [upButton setBackgroundImage:LoadImageWithType(@"up", @"png") forState:UIControlStateNormal];
    upButton.userInteractionEnabled = YES;
    
    if (self.indexNumber >= self.responseCount-1) {
    }else{
        self.indexNumber += 1;
        [self.messageInfo removeFromSuperview];
        [self.infoDetail_view removeFromSuperview];
        [self createTitleView];
        [self createEmployeeView];
        [self createMessageInfoView];
        [self createInfoDetailView];
        [self createApproveView];
        if (self.indexNumber == _responseArray.count-1) {
            [downButton setBackgroundImage:LoadImageWithType(@"down_unavailable", @"png") forState:UIControlStateNormal];
            downButton.userInteractionEnabled = NO;
        }
    }
}

/**
 *  是否显示审批意见
 *
 *  @return 返回布尔值
 */
-(BOOL)getShowComment
{
    NSString *commentFlag=[[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"SystemName"];
    commentFlag=[commentFlag lowercaseString];
    //NSLog(@"获取长度%d",[[commentFlag lowercaseString] rangeOfString:@"atten"].length);
    if(commentFlag != nil && [allTrim(commentFlag) length] > 0 && [[commentFlag lowercaseString] rangeOfString:@"atten"].length>0)
    {
        return true;
    }
    else
    {
        return false;
    }
}
@end
