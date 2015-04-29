//
//  M2PHSViewController.m
//  Ming2.0
//
//  Created by HuangLuyang on 14-4-2.
//  Copyright (c) 2014年 xiaowei wu. All rights reserved.
//

#import "M2PHSViewController.h"
#import <Reachability.h>
#import "M2NetworkEngine.h"
#import <SVProgressHUD.h>
#import "NSString+UTF8.h"
#import "Constant.h"
@interface M2PHSViewController ()<UIWebViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@property(nonatomic,retain) UILabel* reloadLabel;
@property(nonatomic,retain) NSString* urlStirng;
@end

@implementation M2PHSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"项目健康度", @"");
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    [self loadErrorView];
    
    if ([kHttpBaseUrlString isEqualToString:@"http://ming.pactera.com/uat/webservice"]) {
        _urlStirng =[NSString stringWithFormat:@"%@?LoginName=%@&Token=%@",PHSUATUrl,[UserInfo sharedUserInfo].employeeNo,[UserInfo sharedUserInfo].token];
        
    }else{
        _urlStirng =[NSString stringWithFormat:@"%@?LoginName=%@&Token=%@",PHSUrl,[UserInfo sharedUserInfo].employeeNo,[UserInfo sharedUserInfo].token];
        
    }
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_urlStirng]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [request setTimeoutInterval:30];
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = YES;
    [self.webView loadRequest:request];
    
}



-(void)viewWillDisappear:(BOOL)animated
{
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
    self.webView.hidden = NO;
    self.errorView.hidden = YES;
    [[M2LoadHUD sharedHUD] dismiss];
    self.webView.userInteractionEnabled = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
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
    NSLog(@"%@",tempUrl);
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
                    [self performSelector:@selector(dismissHUD) withObject:@"dismissHUD" afterDelay:30];
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

-(void)dismissHUD
{
    if ([M2LoadHUD sharedHUD].isShow) {
        [[M2LoadHUD sharedHUD] dismiss];
        self.webView.userInteractionEnabled = YES;
    }
}

@end
