//
//  M2ResourceDetailController.m
//  Ming2.0
//
//  Created by xiaoweiwu on 12/20/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import "M2ResourceDetailController.h"
#import "M2UtilityParser.h"
#import "M2PopOverView.h"
#import <UIActionSheet+Blocks.h>

@interface M2ResourceDetailController ()<UIDocumentInteractionControllerDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic,strong) UIDocumentInteractionController *documentInteractionController;
@property (weak, nonatomic) IBOutlet UIButton *preViewButton;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *quickLookView;
@property (strong, nonatomic) IBOutlet UIView *infoItemView;
@property (strong, nonatomic) IBOutlet M2PopOverView *popOverView;
@property (weak, nonatomic) IBOutlet UIView *sendItem;
@property (weak, nonatomic) IBOutlet UIView *deleteItem;
@property (strong,nonatomic) NSString *filePath;

@end

@implementation M2ResourceDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=NSLocalizedString(@"资料详情", @"");
    }
    return self;
}

/**
 *  导航右上按钮
 */
-(void)updateAppreance{
    [super updateAppreance];
    if(_fileInfo[@"upload_time"]!=nil)
    {
        UIBarButtonItem *infoBarItem=[[UIBarButtonItem alloc]initWithCustomView:self.infoItemView];
        
        UIBarButtonItem *negativeSpacer2 = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
        
        negativeSpacer2.width=-16;
        self.navigationItem.rightBarButtonItems=@[negativeSpacer2,infoBarItem];
    }
}

-(void)updateToolBar{
    //    UIBarButtonItem *actionItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    UIBarButtonItem *actionItem=[[UIBarButtonItem alloc]initWithCustomView:_sendItem];
    
    actionItem.tintColor=[UIColor whiteColor];
    actionItem.enabled=NO;
    
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *space1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *quickLookItem=[[UIBarButtonItem alloc]initWithCustomView:self.quickLookView];
    quickLookItem.enabled=NO;
    
    //    UIBarButtonItem *deleteItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete)];
    UIBarButtonItem *deleteItem=[[UIBarButtonItem alloc]initWithCustomView:self.deleteItem];
    deleteItem.tintColor=[UIColor whiteColor];
    self.toolbarItems=@[actionItem,space,quickLookItem,space1,deleteItem];
    
    _activityIndicator.hidden=YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateToolBar];
    
    NSLog(@"saved document info:%@",[[[NSUserDefaults standardUserDefaults] objectForKey:kSavedDocumentInfo] objectForKey:_fileInfo[@"url"]]);
    
    NSDictionary *savedDoumentInfo=[[[NSUserDefaults standardUserDefaults] objectForKey:kSavedDocumentInfo] objectForKey:_fileInfo[@"url"]];
    if(savedDoumentInfo && [savedDoumentInfo[@"upload_time"] isEqualToString:_fileInfo[@"upload_time"]]){
        NSLog(@"cached");
        //        [self loadSavedFile];
        [self performSelector:@selector(loadSavedFile) withObject:nil afterDelay:0.1];
    }else{
        [self downloadFile];
    }
    
    NSString *extention=[[_fileInfo objectForKey:@"ext"] lowercaseString];
    
    if ([extention isEqualToString:@".png"]||[extention isEqualToString:@".jpg"]||[extention isEqualToString:@".gif"]) {
        _typeImageView.image=[UIImage imageNamed:@"preview_pic_icon@2x"];
    }else if ([extention isEqualToString:@".txt"]){
        _typeImageView.image=[UIImage imageNamed:@"preview_txt_icon@2x"];
    }else if ([extention isEqualToString:@".pdf"]){
        _typeImageView.image=[UIImage imageNamed:@"preview_pdf_icon@2x"];
    }else if([extention isEqualToString:@".xls"]||[extention isEqualToString:@".xlsx"]){
        _typeImageView.image=[UIImage imageNamed:@"preview_xls_icon@2x"];
    }else if ([extention isEqualToString:@".docx"]||[extention isEqualToString:@".doc"]){
        _typeImageView.image=[UIImage imageNamed:@"preview_doc_icon@2x"];
    }else if([extention isEqualToString:@".pptx"]||[extention isEqualToString:@".ppt"]){
        _typeImageView.image=[UIImage imageNamed:@"preview_ppt_icon@2x"];
    }else if([extention isEqualToString:@".zip"]||[extention isEqualToString:@".rar"]){
        _typeImageView.image=[UIImage imageNamed:@"preview_rar_icon@2x"];
    }else{
        _typeImageView.image=[UIImage imageNamed:@"preview_blank_icon@2x"];
    }
    
    double delayInSeconds = 0.05;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    });
}

/**
 *  加载缓存文件
 */
-(void)loadSavedFile{
    NSDictionary *savedDoumentInfo=[[[NSUserDefaults standardUserDefaults] objectForKey:kSavedDocumentInfo] objectForKey:_fileInfo[@"url"]];
    
    NSURL *url=[NSURL fileURLWithPath:savedDoumentInfo[@"filePath"]];
    self.filePath=savedDoumentInfo[@"filePath"];
    if (url) {
        // Initialize Document Interaction Controller
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        // Configure Document Interaction Controller
        [self.documentInteractionController setDelegate:self];
        // Preview PDF
        [_preViewButton setTitle:NSLocalizedString(@"点击预览", @"") forState:UIControlStateNormal];
        _preViewButton.backgroundColor=[UIColor clearColor];
        _preViewButton.enabled=YES;
        [_progressView setHidden:YES];
        
        UIBarButtonItem *actionBtn=(UIBarButtonItem *)self.toolbarItems[0];
        actionBtn.enabled=YES;
        UIBarButtonItem *quickLookItem=(UIBarButtonItem *)self.toolbarItems[2];
        quickLookItem.enabled=YES;
        
        if([_fileInfo[@"ext"] isEqualToString:@".zip"]||[_fileInfo[@"ext"] isEqualToString:@".rar"]){
            [UIAlertView showWithTitle:NSLocalizedString(@"suggestion", @"") message:NSLocalizedString(@"格式", @"") cancelButtonTitle:NSLocalizedString(@"confirm", @"") otherButtonTitles:@[] tapBlock:nil];
            [_preViewButton setTitle:@"" forState:UIControlStateNormal];
            [_preViewButton removeTarget:self action:@selector(preView:) forControlEvents:UIControlEventTouchUpInside];
            [_preViewButton addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
            quickLookItem.enabled=NO;
        }else{
            if ([_fileInfo[@"ext"] isEqualToString:@".txt"]) {
                NSData *data=[NSData dataWithContentsOfFile:self.filePath];
                [self.webView loadData:data MIMEType:@"text/plain" textEncodingName:@"GBK" baseURL:nil];
            }else{
                NSURLRequest *fileRequest=[NSURLRequest requestWithURL:url];
                [self.webView loadRequest:fileRequest];
            }
            
            _activityIndicator.hidden=NO;
            [_activityIndicator startAnimating];
        }
    }
}

/**
 *  提示框
 */
-(void)showAlert{
    [UIAlertView showWithTitle:NSLocalizedString(@"suggestion", @"") message:NSLocalizedString(@"格式", @"") cancelButtonTitle:NSLocalizedString(@"confirm", @"") otherButtonTitles:@[] tapBlock:nil];
}

/**
 *  下载文件
 */
-(void)downloadFile{
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //
    //    NSArray *stringArray=[@"ftp://172.16.254.132/6c701363-2811-44f4-8036-2858e822e03d/IMG_1504171557506247.jpg" componentsSeparatedByString:@"/"];
    //
    //    //    NSString *fileNameString=[url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    //    NSString *fileNameString=[stringArray lastObject];
    //    //    NSLog(@"filenameStrng length:%d",fileNameString.length);
    //
    //    if (fileNameString.length>100) {
    //        fileNameString=[fileNameString substringFromIndex:fileNameString.length-100];
    //    }
    //
    //    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileNameString];
    //
    //    FMServer* server =[FMServer serverWithDestination:@"172.16.254.132/6c701363-2811-44f4-8036-2858e822e03d" username:@"FtpTest" password:@"Ming@123"];
    //    FTPManager* man = [[FTPManager alloc] init];
    //    BOOL succeeded = [man downloadFile:fileNameString toDirectory:[paths objectAtIndex:0] fromServer:server];
    
    [[M2UtilityParser sharedParser] getFileFromUrl:_fileInfo[@"url"] onCompletion:^(NSString *filePath) {
        
        NSURL *url=[NSURL fileURLWithPath:filePath];
        self.filePath=filePath;
        
        [self saveDocumentInfo];
        if (url) {
            // Initialize Document Interaction Controller
            self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
            // Configure Document Interaction Controller
            [self.documentInteractionController setDelegate:self];
            // Preview PDF
            
            [_preViewButton setTitle:NSLocalizedString(@"点击预览", @"") forState:UIControlStateNormal];
            _preViewButton.backgroundColor=[UIColor clearColor];
            _preViewButton.enabled=YES;
            [_progressView setHidden:YES];
            
            UIBarButtonItem *actionBtn=(UIBarButtonItem *)self.toolbarItems[0];
            actionBtn.enabled=YES;
            UIBarButtonItem *quickLookItem=(UIBarButtonItem *)self.toolbarItems[2];
            quickLookItem.enabled=YES;
            
            if([_fileInfo[@"ext"] isEqualToString:@".zip"]||[_fileInfo[@"ext"] isEqualToString:@".rar"]){
                [UIAlertView showWithTitle:NSLocalizedString(@"suggestion", @"") message:NSLocalizedString(@"格式", @"") cancelButtonTitle:NSLocalizedString(@"confirm", @"") otherButtonTitles:@[] tapBlock:nil];
                [_preViewButton setTitle:@"" forState:UIControlStateNormal];
                [_preViewButton removeTarget:self action:@selector(preView:) forControlEvents:UIControlEventTouchUpInside];
                [_preViewButton addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
                quickLookItem.enabled=NO;
            }else{
                if ([_fileInfo[@"ext"] isEqualToString:@".txt"]) {
                    NSData *data=[NSData dataWithContentsOfFile:filePath];
                    [self.webView loadData:data MIMEType:@"text/plain" textEncodingName:@"GBK" baseURL:nil];
                }else{
                    NSURLRequest *fileRequest=[NSURLRequest requestWithURL:url];
                    [self.webView loadRequest:fileRequest];
                }
                _activityIndicator.hidden=NO;
                [_activityIndicator startAnimating];
            }
        }
        
    } andProgressBlock:^(double progress){
        _progressView.progress=progress;
    } andfailureBlock:^{
        [_preViewButton setTitle:@"download Failed" forState:UIControlStateNormal];
        _progressView.progressTintColor=[UIColor redColor];
    }];
}

/**
 *  保存文档数据
 */
-(void)saveDocumentInfo{
    NSMutableDictionary *fileInfoDict=[_fileInfo mutableCopy];
    [fileInfoDict setObject:_filePath forKey:@"filePath"];
    NSDictionary *savedDocumentInfo=[[NSUserDefaults standardUserDefaults] objectForKey:kSavedDocumentInfo];
    NSMutableDictionary *savedDocument;
    
    if(savedDocumentInfo){
        savedDocument=[savedDocumentInfo mutableCopy];
    }else{
        savedDocument=[NSMutableDictionary dictionary];
    }
    
    [savedDocument setObject:fileInfoDict forKey:fileInfoDict[@"url"]];
    
    [[NSUserDefaults standardUserDefaults] setObject:savedDocument forKey:kSavedDocumentInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  显示文档信息
 *
 *  @param sender button
 */
- (IBAction)showInfo:(id)sender {
    [_popOverView setPopOverWithInfo:_fileInfo];
    [_popOverView showInView:self.view.window];
}

/**
 *  分享
 */
-(IBAction)share{
    [self.documentInteractionController presentOptionsMenuFromBarButtonItem:self.toolbarItems[0] animated:YES];
}

/**
 *  删除
 */
-(IBAction)delete{
    [UIActionSheet showFromBarButtonItem:self.toolbarItems[4] animated:YES withTitle:NSLocalizedString(@"删除本地文件", @"") cancelButtonTitle:NSLocalizedString(@"cancel", @"") destructiveButtonTitle:NSLocalizedString(@"删除", @"") otherButtonTitles:nil tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex==0) {
            NSDictionary *savedDocumentInfo=[[NSUserDefaults standardUserDefaults] objectForKey:kSavedDocumentInfo];
            NSMutableDictionary *savedDocument;
            
            if(savedDocumentInfo){
                savedDocument=[savedDocumentInfo mutableCopy];
            }else{
                savedDocument=[NSMutableDictionary dictionary];
            }
            
            [savedDocument removeObjectForKey:_fileInfo[@"url"]];
            
            [[NSUserDefaults standardUserDefaults] setObject:savedDocument forKey:kSavedDocumentInfo];
            
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:_filePath error:&error];
            
            [self.view makeToast:NSLocalizedString(@"deleted", @"") duration:1.0 position:@"center"];
        }
    }];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}

-(CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller{
    return self.view.frame;
}

/**
 *  预览Action
 *
 *  @param sender button
 */
- (IBAction)preView:(id)sender {
    [self.documentInteractionController presentPreviewAnimated:YES];
}

#pragma mark ======web view delegate========
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    _progressView.superview.hidden=YES;
}

@end
