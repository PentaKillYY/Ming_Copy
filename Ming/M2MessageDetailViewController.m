//
//  M2MessageDetailViewController.m
//  Ming2.0
//
//  Created by HuangLuyang on 13-12-16.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//
#import "M2MessageDetailViewController.h"
#import "CommonMacro.h"
#import "M2AvatarView.h"
#import "SystemMessageParser.h"
#import "M2ResourceDetailController.h"

@interface M2MessageDetailViewController ()<UITextViewDelegate>
{
    UIView* customView;
    UITextView* textView;
    UITextField* approve;
    UITextField* refuse;
    UIButton* handleButton;
    int messageNumber;
    BOOL isHandled;
    UIView* backView;
    UIButton* upButton ;
    UIButton* downButton;
    UIButton* approveButton;
    UIButton* rejectButton;
}

@property (strong,nonatomic) UIView* _backView;
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
@property (strong, nonatomic) UIView *attachments_view;//附件视图
//@property (strong, nonatomic) UIView *attachments_cel;
@property (strong, nonatomic) UIImageView* attachImage;
@property (strong, nonatomic) UIImageView* rightImage;
@property (strong, nonatomic) NSMutableArray *attachmentsArray;
@property (strong, nonatomic) NSArray *fileArray;

@end

@implementation M2MessageDetailViewController

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
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];//声明标题
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:NSLocalizedString(@"审批详情", @"")];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [titleLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleLabel;
    
    upButton = [UIButton buttonWithType:UIButtonTypeCustom];//上一条
    downButton = [UIButton buttonWithType:UIButtonTypeCustom];//下一条
    if (self.responseArray.count == 1) {
        [upButton setBackgroundImage:LoadImageWithType(@"up_unavailable", @"png") forState:UIControlStateNormal];
        upButton.userInteractionEnabled = NO;
        [downButton setBackgroundImage:LoadImageWithType(@"down_unavailable", @"png") forState:UIControlStateNormal];
        downButton.userInteractionEnabled = NO;
    }else{
        //返回数据大于一条，显示数据导航按钮
        if (self.indexNumber == 0) {
            [upButton setBackgroundImage:LoadImageWithType(@"up_unavailable", @"png") forState:UIControlStateNormal];
            upButton.userInteractionEnabled = NO;
            
            [downButton setBackgroundImage:LoadImageWithType(@"down", @"png") forState:UIControlStateNormal];
            downButton.userInteractionEnabled = YES;
            
        }else if (self.indexNumber == self.responseArray.count - 1)
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
            downButton.userInteractionEnabled = YES;
        }
    }
    
    [upButton addTarget:self action:@selector(lastMessageButton) forControlEvents:UIControlEventTouchUpInside];
    [downButton addTarget:self action:@selector(nextMessageButton) forControlEvents:UIControlEventTouchUpInside];
    
    if (IS_VERSION7) {
        [upButton setFrame:CGRectMake(20, 5, 38, 38)];
        [downButton setFrame:CGRectMake(58, 5, 38, 38)];
    }else
    {
        [upButton setFrame:CGRectMake(10, 5, 38, 38)];
        [downButton setFrame:CGRectMake(48, 5, 38, 38)];
    }
    
    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
    [rightView addSubview:upButton];
    [rightView addSubview:downButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    [self createTitleView];
    [self createEmployeeView];
    [self createMessageInfoView];
    [self createInfoDetailView];
    [self createAttachmentView];
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.01;
    backView.hidden = YES;
    [self.view addSubview:backView];
    
    [self addHandleButton];
    
    customView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT+110, 320, 110)];
    customView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0];
    customView.alpha = 0.99;
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, 300, 60)];//意见输入框样式
    textView.delegate= self;
    textView.scrollEnabled = NO;
    textView.layer.borderWidth =1.2;
    textView.font = [UIFont systemFontOfSize:16];
    textView.backgroundColor = [UIColor clearColor];
    textView.layer.borderColor = [UIColor colorWithRed:195.0f/255.0f green:195.0f/255.0f blue:195.0f/255.0f alpha:1.0].CGColor;
    [customView addSubview:textView];
    
    handleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [handleButton setFrame:CGRectMake(240, 10, 70, 20)];
    [handleButton setTitle:@"" forState:UIControlStateNormal];
    [handleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [handleButton addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];//绑定操作事件
    
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(10, 10, 60, 20)];
    [cancelButton setTitle:NSLocalizedString(@"cancel", @"") forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:cancelButton];
    [customView addSubview:handleButton];
    [self.view addSubview:customView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideContentView:) name:UIKeyboardWillHideNotification object:nil];
    [super viewWillAppear:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (isHandled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageListNeedRefresh" object:Nil];//网路请求刷新
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            isList = YES;
        }
        else{
            UILabel* value1Label = [[UILabel alloc] initWithFrame:CGRectMake(105, valueNumber*20, 220, 20)];
            value1Label.numberOfLines = 0;
            
            value1Label.lineBreakMode = NSLineBreakByWordWrapping;
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
            value1Label.backgroundColor = [UIColor clearColor];
            value1Label.text = [NSString stringWithFormat:@"%@",[contentDic objectForKey:@"Field1"]];//内容
            value1Label.textColor = HexColor(0X4D4D4D);
            value1Label.font = [UIFont systemFontOfSize:14];
            CGSize size = CGSizeMake(187,2000);
            CGSize labelsize = [value1Label.text sizeWithFont:font constrainedToSize:size lineBreakMode:value1Label.lineBreakMode];
            
            UILabel* value0Label = [[UILabel alloc] initWithFrame:CGRectMake(14, height+5, 81, 20)];
            value0Label.numberOfLines = 0;
            value0Label.backgroundColor = [UIColor clearColor];
            value0Label.text = [NSString stringWithFormat:@"%@:",[contentDic objectForKey:@"Field0"]];//属性名
            value0Label.font = [UIFont systemFontOfSize:14];
            value0Label.lineBreakMode = NSLineBreakByWordWrapping;
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
    self.contentScrollView.contentSize=CGSizeMake(320, self.messageInfo.frame.origin.y+self.messageInfo.frame.size.height+60);
}

/**
 *  添加infoView
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
                    rowheight += maxLabelSize+5;
                }
                listHeight += 15;
                listNumber += 1;
            }
        }
        self.infoDetail_view.frame = CGRectMake(0, self.messageInfo.frame.origin.y+self.messageInfo.frame.size.height, 320, listHeight+rowheight+10+5+5);
        UILabel* seperateLine = [[UILabel alloc] initWithFrame:CGRectMake(0, listHeight+rowheight+5+5+10-1, 320, 1)];
        seperateLine.backgroundColor = [UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0];
        [self.infoDetail_view addSubview:seperateLine];
        self.contentScrollView.contentSize = CGSizeMake(320, self.infoDetail_view.frame.origin.y+self.infoDetail_view.frame.size.height+68);
        [self.contentScrollView addSubview:self.infoDetail_view];
    }
}

-(void)createAttachmentView
{
    BOOL IsExistFile = [[[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"IsExistFile"] boolValue];
    NSString* FileJson = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"FileJson"];
    if(IsExistFile)
    {
        self.attachments_view = [[UIView alloc] initWithFrame:CGRectMake(0, 100+self.infoDetail_view.frame.size.height+self.messageInfo.frame.size.height, 320, 60)];
//        self.attachments_view.layer.borderWidth = 1.0f;
//        self.attachments_view.layer.borderColor  = [UIColor blueColor].CGColor;
        //self.attachments_view.userInteractionEnabled = YES;
        
        UILabel* attachtTitle = [[UILabel alloc] initWithFrame:CGRectMake(150, 16, 20, 20)];
        attachtTitle.numberOfLines = 0;
        attachtTitle.lineBreakMode = NSLineBreakByWordWrapping;
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
        attachtTitle.backgroundColor = [UIColor clearColor];
        attachtTitle.text = NSLocalizedString(@"AttachmentTitle", @"");
        attachtTitle.font = [UIFont systemFontOfSize:14];
        CGSize size = CGSizeMake(200,2000);
        CGSize labelsize = [attachtTitle.text sizeWithFont:font constrainedToSize:size lineBreakMode:attachtTitle.lineBreakMode];
        attachtTitle.frame = CGRectMake(14, 0, 288, 20);
        [self.attachments_view addSubview:attachtTitle];
        
        //解析json的代码
        NSData *jsonData = [FileJson dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        //通过KEY找到value
        self.fileArray = [dic objectForKey:@"FileJSON"];
        if (self.fileArray != nil) {
            NSInteger valueNumber = 0;
            for (NSDictionary* contentDic in self.fileArray)
            {
                //NSString *fileURL=[contentDic objectForKey:@"FileURL"];
                BOOL isFileView=[[contentDic objectForKey:@"IsFileView"] isEqualToString:@"0"]? YES: NO;
                
                UIView *attachments_cel = [[UIView alloc] initWithFrame:CGRectMake(0, valueNumber*51+25, 320, 50)];
//                attachments_cel.backgroundColor = [UIColor whiteColor];
//                attachments_cel.layer.borderColor = [UIColor redColor].CGColor;
//                attachments_cel.layer.borderWidth = 1.0f;

                attachments_cel.tag = valueNumber;
                attachments_cel.userInteractionEnabled = YES;
                
                UILabel* value1Label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 20, 20)];
                value1Label.numberOfLines = 0;
                
                //value1Label.lineBreakMode = NSLineBreakByWordWrapping;//择行
                value1Label.lineBreakMode=NSLineBreakByTruncatingTail;
                UIFont *font = [UIFont fontWithName:@"Helvetica" size:14];
                value1Label.backgroundColor = [UIColor clearColor];
                
                self.attachImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
                value1Label.text = [NSString stringWithFormat:@"%@",[contentDic objectForKey:@"FileName"]];//内容
                
                if(isFileView)
                {
                    NSString *extension=[contentDic objectForKey:@"Extension"];
                    NSRange range = [extension rangeOfString:@"(.JPEG|.jpeg|.JPG|.jpg|.GIF|.gif|.BMP|.bmp|.PNG|.png)$" options:NSRegularExpressionSearch];
                    if (range.location == NSNotFound) {
                        [self.attachImage setImage:[UIImage imageNamed:@"file_pdf_icon.png"]];
                    }
                    else
                    {
                        [self.attachImage setImage:[UIImage imageNamed:@"file_images_normal.png"]];
                    }
                    //可以预览
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
                    [attachments_cel addGestureRecognizer:tapGesture];
                    NSLog(@"绑定可预览方法");
                }
                else
                {
                    [self.attachImage setImage:[UIImage imageNamed:@"file_unknown_icon.png"]];
                    
                    //不可预览，提示消息
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toastMessage:)];
                    [attachments_cel addGestureRecognizer:tapGesture];
                    NSLog(@"绑定不可预览方法");
                }
                
                self.rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(280, 5, 40, 40)];
                [self.rightImage setImage:[UIImage imageNamed:@"right_arrow.png"]];
                [attachments_cel addSubview:self.rightImage];
                
                value1Label.textColor = HexColor(0X4D4D4D);
                value1Label.font = [UIFont systemFontOfSize:14];
                CGSize size = CGSizeMake(187,2000);
                CGSize labelsize = [value1Label.text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingTail];
                //CGSize labelsize = [countString sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
                value1Label.frame = CGRectMake(50, 16, 187, labelsize.height+3);
                [attachments_cel addSubview:value1Label];
                [attachments_cel addSubview:self.attachImage];
                
                UILabel* seperateLine = [[UILabel alloc] initWithFrame:CGRectMake(14, 50, 290, 1)];
                seperateLine.backgroundColor = [UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0];
                [attachments_cel addSubview:seperateLine];
                
                [self.attachments_view addSubview:attachments_cel];
                valueNumber+=1;
                
                self.contentScrollView.contentSize=CGSizeMake(320, attachments_cel.frame.origin.y+attachments_cel.frame.size.height+400);
            }
            
        }
        CGRect rect = self.attachments_view.frame;
        rect.size.height = [self.fileArray count] * 51+31;
        self.attachments_view.frame = rect;
        [self.contentScrollView addSubview:self.attachments_view];
        //self.contentScrollView.contentSize=CGSizeMake(320, self.attachments_cel.frame.origin.y+self.attachments_cel.frame.size.height+60);
    }
}

#pragma mark -
#pragma mark 界面事件

-(void)Actiondo:(UITapGestureRecognizer*)tapGestureRecognizer{
    
    NSLog(@"============= 查看附件 ==============");
    UIView *view=(UIView *)tapGestureRecognizer.view;
    
    NSDictionary *fileDic=self.fileArray[view.tag];
    NSDictionary *myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:@"true", @"is_file",[fileDic objectForKey:@"FileURL"], @"url", [fileDic objectForKey:@"Extension"], @"ext", nil];
    self.attachmentsArray=[[NSMutableArray alloc] init];
    [self.attachmentsArray addObject:myClassDict];
    
    M2ResourceDetailController *resourceDetail=[[M2ResourceDetailController alloc]init];
    resourceDetail.fileInfo=self.attachmentsArray[0];
    [self.navigationController pushViewController:resourceDetail animated:YES];
}

-(void)toastMessage:(UITapGestureRecognizer*)tapGestureRecognizer{
    NSLog(@"============= Toast提示 ==============");
    NSString* Message = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"Message"];
    if(Message!=nil)
    {
        //解析json的代码
        NSData *jsonData = [Message dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if([NSLocalizedString(@"lang", @"") isEqualToString:@"en-us"])
        {
            NSArray *messageList=[dic objectForKey:@"Message"];
            for (NSDictionary* contentDic in messageList)
            {
                NSString *lan=[contentDic objectForKey:@"Language"];
                if ([lan intValue]==1) {
                    //value1Label.text = [contentDic objectForKey:@"Content"];//内容
                    [self.view makeToast:[contentDic objectForKey:@"Content"] duration:3.0 position:@"center"];
                    break;
                }
            }
        }
        else
        {
            NSArray *messageList=[dic objectForKey:@"Message"];
            for (NSDictionary* contentDic in messageList)
            {
                NSString *lan=[contentDic objectForKey:@"Language"];
                if ([lan intValue]==2) {
                    //value1Label.text = [contentDic objectForKey:@"Content"];//内容
                    [self.view makeToast:[contentDic objectForKey:@"Content"] duration:3.0 position:@"center"];
                    break;
                }
            }
        }
    }
}

/**
 *  上一条message按钮
 */
-(void)lastMessageButton
{
    [downButton setBackgroundImage:LoadImageWithType(@"down", @"png") forState:UIControlStateNormal];
    downButton.userInteractionEnabled = YES;
    if (self.indexNumber <= 0) {
        
    }else{
        self.indexNumber -= 1;
        [self.attachments_view removeFromSuperview];
        [self.messageInfo removeFromSuperview];
        [self.infoDetail_view removeFromSuperview];
        [self createTitleView];
        [self createEmployeeView];
        [self createMessageInfoView];
        [self createInfoDetailView];
        [self createAttachmentView];
        if (self.indexNumber == 0) {
            [upButton setBackgroundImage:LoadImageWithType(@"up_unavailable", @"png") forState:UIControlStateNormal];
            upButton.userInteractionEnabled = NO;
        }
    }
}

/**
 *  下一条message按钮
 */
-(void)nextMessageButton
{
    [upButton setBackgroundImage:LoadImageWithType(@"up", @"png") forState:UIControlStateNormal];
    upButton.userInteractionEnabled = YES;
    if (self.indexNumber >= _responseArray.count-1) {
    }else{
        self.indexNumber += 1;
        [self.attachments_view removeFromSuperview];
        [self.messageInfo removeFromSuperview];
        [self.infoDetail_view removeFromSuperview];
        [self createTitleView];
        [self createEmployeeView];
        [self createMessageInfoView];
        [self createInfoDetailView];
        [self createAttachmentView];
        
        if (self.indexNumber == _responseArray.count-1 ) {
            [downButton setBackgroundImage:LoadImageWithType(@"down_unavailable", @"png") forState:UIControlStateNormal];
            downButton.userInteractionEnabled = NO;
        }
    }
}

#pragma mark-
#pragma mark HandleAction

/**
 *  增加审批操作按钮
 */
-(void)addHandleButton
{
    approveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView* handleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,SCREEN_HEIGHT-20-44 - 54.0f, 320.0f, 54.0f)];
    [handleView setBackgroundColor:[UIColor colorWithRed:219.0f/255.0f  green:218.0f/255.0f  blue:221.0f/255.0f alpha:1.0]];
    approveButton.frame = CGRectMake(65, 7 , 30.0f, 30);
    
    rejectButton.frame = CGRectMake(160+65, 7 , 30, 30);
    
    [approveButton setBackgroundImage:LoadImageWithType(@"approve_2", @"png") forState:UIControlStateNormal];
    [approveButton setBackgroundImage:LoadImageWithType(@"approve_3", @"png") forState:UIControlStateHighlighted];
    [approveButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [approveButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [approveButton addTarget:self action:@selector(detailApproveAction) forControlEvents:UIControlEventTouchUpInside];//绑定通过事件
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
    [rejectButton addTarget:self action:@selector(detailRejectAction) forControlEvents:UIControlEventTouchUpInside];//绑定拒绝事件
    [rejectButton setTitle:NSLocalizedString(@"拒绝", @"") forState:UIControlStateNormal];
    [rejectButton setTitleEdgeInsets:UIEdgeInsetsMake(48, 0, 0, 0)];
    rejectButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:7];
    [rejectButton setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [rejectButton setTitleColor:[UIColor colorWithRed:88.0f/255.0f green:161.0f/255.0f blue:245.0f/255.0f alpha:1.0] forState:UIControlStateHighlighted];
    [handleView addSubview:rejectButton];
    [self.view addSubview:handleView];
}

/**
 *  改变输入内容框坐标
 *
 *  @param notification notification
 */
- (void)changeContentViewPoint:(NSNotification *)notification
{
    backView.hidden = NO;
    [UIView animateWithDuration:0.1 animations:^{
        backView.alpha = 0.20;
    }];
    
    NSString* title = [[NSString alloc] init];
    if (!textView.tag ) {
        
    }else{
        if (textView.tag == 1) {
            title = NSLocalizedString(@"同意", @"");
        }
        else{
            title = NSLocalizedString(@"拒绝", @"");
        }
        textView.text = @"";
        [handleButton setTitle:title forState:UIControlStateNormal];
    }
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        customView.center = CGPointMake(customView.center.x, keyBoardEndY-20-44 - customView.bounds.size.height/2.0);//keyBoardEndY的坐标包括了状态栏的高度，要减去
    }];
}

/**
 *  隐藏输入内容框
 *
 *  @param notification notification
 */
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

/**
 *  取消操作
 */
-(void)cancelAction
{
    [textView resignFirstResponder];
}

/**
 *  审批操作
 *
 *  @param sender sender button
 */
-(void)handleAction:(id)sender
{
    isHandled = YES;
    UIButton* button = (UIButton*)sender;
    NSString* systemId = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"SystemID"];
    NSString* msgId = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"MsgID"];
    if ([button.titleLabel.text isEqualToString:NSLocalizedString(@"同意", @"")]) {
        [[SystemMessageParser sharedHttpParser] handleSystemMessageSystemId:systemId MsgID:msgId Action:@"Approve" Comment:textView.text OnCompletion:^(NSArray* json){
            textView.text = @"";
            NSString* responseResult = [[json objectAtIndex:0] objectForKey:@"key"];
            if ([responseResult isEqualToString:@"-1"]) {
                NSLog(@"token失效");
            }else{
                if ([responseResult isEqualToString:@"1"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        hud = [[MBProgressHUD alloc] initWithView:self.view];
                        [self.view addSubview:hud];
                        hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"审批成功", @"")];
                        hud.mode = MBProgressHUDModeText;
                        [hud showAnimated:YES whileExecutingBlock:^{
                            sleep(2);
                        } completionBlock:^{
                            [hud removeFromSuperview];
                            hud = nil;
                        }];
                        [self moveToNextMessageHandled];
                    });
                }else{
                    hud = [[MBProgressHUD alloc] initWithView:self.view];
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
        [[SystemMessageParser sharedHttpParser] handleSystemMessageSystemId:systemId MsgID:msgId Action:@"Reject" Comment:textView.text OnCompletion:^(NSArray* json){
            textView.text = @"";
            NSString* responseResult = [[json objectAtIndex:0] objectForKey:@"key"];
            if ([responseResult isEqualToString:@"-1"]) {
                NSLog(@"token失效");
            }else{
                if ([responseResult isEqualToString:@"1"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        hud = [[MBProgressHUD alloc] initWithView:self.view];
                        [self.view addSubview:hud];
                        hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"审批成功", @"")];
                        hud.mode = MBProgressHUDModeText;
                        [hud showAnimated:YES whileExecutingBlock:^{
                            sleep(2);
                        } completionBlock:^{
                            [hud removeFromSuperview];
                            hud = nil;
                        }];
                        
                        [self moveToNextMessageHandled];
                    });
                }else{
                    hud = [[MBProgressHUD alloc] initWithView:self.view];
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
    [self cancelAction];
}

/**
 *  移动到下一条未审批
 */
-(void)moveToNextMessageHandled
{
    if (self.responseArray.count == 1) {
        [self.responseArray removeAllObjects];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.responseArray removeObjectAtIndex:self.indexNumber];
        if (self.indexNumber == self.responseArray.count) {
            self.indexNumber = 0;
        }
        [self.attachments_view removeFromSuperview];
        [self.messageInfo removeFromSuperview];
        [self.infoDetail_view removeFromSuperview];
        [self createTitleView];
        [self createEmployeeView];
        [self createMessageInfoView];
        [self createInfoDetailView];
        [self createAttachmentView];
    }
}

/**
 *  同意操作按钮点击
 */
-(void)detailApproveAction
{
    if([self getShowComment])
    {
        NSLog(@"显示意见输入框");
        textView.tag = 1;
        [textView becomeFirstResponder];
    }
    else
    {
        NSLog(@"隐藏意见输入框");
        [UIAlertView showWithTitle:NSLocalizedString(@"suggestion", @"") message:NSLocalizedString(@"Please confirm whether to approve", @"") cancelButtonTitle:NSLocalizedString(@"confirm", @"") otherButtonTitles:@[NSLocalizedString(@"cancel", @"")]  tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==0) {
                NSLog(@"同意");
                isHandled = YES;
                NSString* systemId = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"SystemID"];
                NSString* msgId = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"MsgID"];
                [[SystemMessageParser sharedHttpParser] handleSystemMessageSystemId:systemId MsgID:msgId Action:@"Approve" Comment:textView.text OnCompletion:^(NSArray* json){
                    textView.text = @"";
                    NSString* responseResult = [[json objectAtIndex:0] objectForKey:@"key"];
                    if ([responseResult isEqualToString:@"-1"]) {
                        NSLog(@"token失效");
                    }else{
                        if ([responseResult isEqualToString:@"1"]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                hud = [[MBProgressHUD alloc] initWithView:self.view];
                                [self.view addSubview:hud];
                                hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"审批成功", @"")];
                                hud.mode = MBProgressHUDModeText;
                                [hud showAnimated:YES whileExecutingBlock:^{
                                    sleep(2);
                                } completionBlock:^{
                                    [hud removeFromSuperview];
                                    hud = nil;
                                }];
                                
                                [self moveToNextMessageHandled];
                            });
                        }else{
                            hud = [[MBProgressHUD alloc] initWithView:self.view];
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
            }else
            {
                NSLog(@"取消");
            }
        }];
    }
}

/**
 *  拒绝操作按钮点击
 */
-(void)detailRejectAction
{
    if([self getShowComment])
    {
        NSLog(@"显示意见输入框");
        textView.tag = 2;
        [textView becomeFirstResponder];
    }
    else
    {
        NSLog(@"隐藏意见输入框");
        [UIAlertView showWithTitle:NSLocalizedString(@"suggestion", @"") message:NSLocalizedString(@"Please confirm whether to reject", @"") cancelButtonTitle:NSLocalizedString(@"拒绝", @"") otherButtonTitles:@[NSLocalizedString(@"cancel", @"")]  tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==0) {
                NSLog(@"拒绝");
                isHandled = YES;
                NSString* systemId = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"SystemID"];
                NSString* msgId = [[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"MsgID"];
                [[SystemMessageParser sharedHttpParser] handleSystemMessageSystemId:systemId MsgID:msgId Action:@"Reject" Comment:textView.text OnCompletion:^(NSArray* json){
                    textView.text = @"";
                    NSString* responseResult = [[json objectAtIndex:0] objectForKey:@"key"];
                    if ([responseResult isEqualToString:@"-1"]) {
                        NSLog(@"token失效");
                    }else{
                        if ([responseResult isEqualToString:@"1"]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                hud = [[MBProgressHUD alloc] initWithView:self.view];
                                [self.view addSubview:hud];
                                hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"审批成功", @"")];
                                hud.mode = MBProgressHUDModeText;
                                [hud showAnimated:YES whileExecutingBlock:^{
                                    sleep(2);
                                } completionBlock:^{
                                    [hud removeFromSuperview];
                                    hud = nil;
                                }];
                                
                                [self moveToNextMessageHandled];
                            });
                        }else{
                            hud = [[MBProgressHUD alloc] initWithView:self.view];
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
            }else
            {
                NSLog(@"取消");
            }
        }];
    }
}

/**
 *  审批内容框文字输入触发方法
 *
 *  @param atextView textview
 */
- (void)textViewDidChange:(UITextView *)atextView{
    NSInteger number = [atextView.text length];
    if (number > 15) {
        atextView.text =  [atextView.text substringToIndex:15];
        number = 15;
    }
}

/**
 *  是否显示审批意见
 *
 *  @return 返回布尔值
 */
-(BOOL)getShowComment
{
    NSString* commentFlag=[[self.responseArray objectAtIndex:self.indexNumber] objectForKey:@"RemarkFlag"];
    if(commentFlag != nil&&[allTrim(commentFlag) length] > 0&&[commentFlag isEqualToString:@"True"])
    {
        return true;
    }
    else
    {
        return false;
    }
}
@end
