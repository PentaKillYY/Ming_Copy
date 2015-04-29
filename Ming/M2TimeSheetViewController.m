//
//  M2TimeSheetViewController.m
//  Ming2.0
//
//  Created by xiaoweiwu on 1/20/14.
//  Copyright (c) 2014 xiaowei wu. All rights reserved.
//

#import "M2TimeSheetViewController.h"
#import <SVProgressHUD.h>
#import "NSString+UTF8.h"
#import "Constant.h"
#import <Reachability.h>
#import "M2NetworkEngine.h"
@interface M2TimeSheetViewController ()<UIWebViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@property(nonatomic,retain) UILabel* reloadLabel;
@property(nonatomic,retain) NSString* urlStirng;
@property (assign, nonatomic) BOOL bTimeOutFlag;

@end

@implementation M2TimeSheetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    self.title=NSLocalizedString(@"未填工时", "");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    [self loadErrorView];
    _urlStirng=[[NSString stringWithFormat:@"%@employeeNo=%@&name=%@&token=%@&lan=%@",TimesheetUrl,[UserInfo sharedUserInfo].employeeNo,[UserInfo sharedUserInfo].employeeName,[UserInfo sharedUserInfo].token,NSLocalizedString(@"lan", @"")] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_urlStirng]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [request setTimeoutInterval:30];
    self.webView.delegate = self;
    [self.webView loadRequest:request];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    self.bTimeOutFlag = YES;
    [self performSelector:@selector(showTimeOutView) withObject:@"showTimeOutView" afterDelay:30];
    NSLog(@"set time out proterty");
}

-(void)viewWillAppear:(BOOL)animated
{
    if (IS_VERSION7) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    if (IS_VERSION7) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    
    
    [self updateNavBarItem];
    [[M2LoadHUD sharedHUD] dismiss];
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.bTimeOutFlag = NO;
    self.webView.hidden = NO;
    self.errorView.hidden = YES;
    [[M2LoadHUD sharedHUD] dismiss];
    self.webView.userInteractionEnabled = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.bTimeOutFlag = NO;
    [[M2LoadHUD sharedHUD] dismiss];
    self.webView.userInteractionEnabled = YES;
    if (error.code == -999) {
        return;
    }
    
    self.webView.hidden = YES;
    self.errorView.hidden = NO;
    if(error.code == -1009){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"检查网络连接", @"")];
    }
    else{
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"timeout", @"")];
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:
(NSURLRequest*)request navigationType:
(UIWebViewNavigationType)navigationType //这个方法是网页中的每一个请求都会被触发的
{
    NSString *tempUrl = [[request URL] absoluteString];
    NSArray *urlComps = [tempUrl
                         componentsSeparatedByString:@"://"];
    
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps
                                                       objectAtIndex:1] componentsSeparatedByString:@"/"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        if (1 == [arrFucnameAndParameter count])
        {
            if([funcStr isEqualToString:@"goBack"])
            {
                // navigation返回
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([funcStr isEqualToString:@"showLoading"]){
                //  显示loading效果
                if (![self checkReachability]) {
                    self.webView.hidden = YES;
                    self.errorView.hidden = NO;
                    self.webView.userInteractionEnabled = YES;
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"检查网络连接", @"")];
                }else{
                    [[M2LoadHUD sharedHUD] show];
                    self.webView.userInteractionEnabled = NO;
                    //[self performSelector:@selector(dismissHUD) withObject:@"dismissHUD" afterDelay:30];
                }
            }else if ([funcStr isEqualToString:@"hideLoading"]){
                //  隐藏loading效果
                [[M2LoadHUD sharedHUD] dismiss];
                self.webView.userInteractionEnabled = YES;
            }
        }else if (2 == [arrFucnameAndParameter count]){
            if ([funcStr isEqualToString:@"showAlert"]) {
                //   显示tips提示
                if ([arrFucnameAndParameter objectAtIndex:1]) {
                    NSLog(@"%@",[arrFucnameAndParameter objectAtIndex:1]);
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[[arrFucnameAndParameter objectAtIndex:1] URLDecodedString] message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"confirm", @""), nil];
                    [alert show];
                }
            }
        }
        return NO;
    }else{
        BOOL shouldLoadFirstPage = [tempUrl isEqualToString:self.urlStirng];
        if (shouldLoadFirstPage){
            [[M2LoadHUD sharedHUD] show];
            self.webView.userInteractionEnabled = NO;
        }
        return YES;
    }
}

-(NSString*)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}

-(void)loadErrorView{
    _errorLabel.text = NSLocalizedString(@"数据加载失败", @"");
    _checkLabel.text = NSLocalizedString(@"检查网络", @"");
    [_reloadButton setTitle:NSLocalizedString(@"返回首页", @"") forState:UIControlStateNormal];
    _errorView.hidden = YES;
}

- (IBAction)reloadWebView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"confirmAlert('cancel')"];
    }else{
        [self.webView stringByEvaluatingJavaScriptFromString:@"confirmAlert('confirm')"];
    }
}

-(BOOL)checkReachability{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    }
    return YES;
}

-(void)showTimeOutView
{
    NSLog(@"show time out view");
    if (self.bTimeOutFlag) {
        NSLog(@"set view display");
        [[M2LoadHUD sharedHUD] dismiss];
        self.webView.userInteractionEnabled = YES;
        self.webView.hidden = YES;
        self.errorView.hidden = NO;
    }
}

@end
