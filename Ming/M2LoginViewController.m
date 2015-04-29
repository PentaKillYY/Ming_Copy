//
//  M2LoginViewController.m
//  Ming2.0
//
//  Created by xiaoweiwu on 12/2/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import "M2LoginViewController.h"
#import "M2LoginParser.h"
#import <AFJSONRequestOperation.h>
#import "UIImage+Dynamic.h"
#import "UserInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "M2PushNotificationParser.h"
#import "CommonMacro.h"
#define Token_key  @"key"

@interface M2LoginViewController ()<UITextFieldDelegate,MYIntroductionDelegate>

@property (weak, nonatomic) IBOutlet UIView *loginPanel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *ueserNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation M2LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}
    
    
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    NSString *versionString=[[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    
    if(![[NSUserDefaults standardUserDefaults] valueForKey:versionString]){
        [[NSUserDefaults standardUserDefaults] setValue:@"version" forKey:versionString];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"第一次启动");
        NSMutableArray* panels = [[NSMutableArray alloc] init];
        if (SCREEN_HEIGHT > 480) {
            for (int i=1; i <= 4; i++) {
                MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:nil description:nil image:[UIImage imageNamed:[NSString stringWithFormat:@"引导页%d_1136.jpg",i]]];
               
                [panels addObject:panel];
            }

            
        }else{
            for (int i=1; i <= 4; i++) {
                MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:nil description:nil image:[UIImage imageNamed:[NSString stringWithFormat:@"引导页%d.jpg",i]]];
                [panels addObject:panel];
            }
           
        }
        
        MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        introductionView.delegate = self;
        [introductionView buildIntroductionWithPanels:panels];
        [introductionView setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:introductionView];

    }else{
        NSLog(@"已经不是第一次启动了");
        if (Is_4Inch) {
            if(IS_VERSION7){
                _logoImageView.transform=CGAffineTransformMakeTranslation(0,Logo_middle_y_4inch-_logoImageView.y);
            }else{
                _logoImageView.transform=CGAffineTransformMakeTranslation(0,Logo_middle_y_4inch-_logoImageView.y-20);
            }
        }else{
            if(IS_VERSION7){
                _logoImageView.transform=CGAffineTransformMakeTranslation(0,logo_middle_y_3-_logoImageView.y);
            }else{
                _logoImageView.transform=CGAffineTransformMakeTranslation(0,logo_middle_y_3-_logoImageView.y-20);
            }
        }
        
        //    _loginPanel.transform=CGAffineTransformMakeTranslation(0,self.view.height-_loginPanel.y);
        _loginPanel.transform=CGAffineTransformMakeScale(.5, .5);
        _loginPanel.alpha=0;
        
        [_loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] withRect:_loginBtn.bounds] forState:UIControlStateNormal];
        
        [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _loginBtn.layer.cornerRadius=4;
        _loginBtn.layer.masksToBounds=YES;
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignField)];
        [self.view addGestureRecognizer:tapGesture];
        
        if (self.shouldShowUser) {
            self.ueserNameField.text=[UserInfo sharedUserInfo].account;
            self.passwordField.text=[UserInfo sharedUserInfo].password;
        }
        if (IS_VERSION7) {
            [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                _logoImageView.transform=CGAffineTransformIdentity;
                _loginPanel.transform=CGAffineTransformIdentity;
                _loginPanel.alpha=1;
            } completion:nil];
            
        }else{
            [UIView animateWithDuration:0.9 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _logoImageView.transform=CGAffineTransformIdentity;
                _loginPanel.transform=CGAffineTransformIdentity;
                _loginPanel.alpha=1;
            } completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  登陆Action
 *
 *  @param sender button
 */
- (IBAction)loginAction:(id)sender {
    
    if ([self checkField]) {
        NSDictionary *authInfo=@{@"account":_ueserNameField.text,@"password":_passwordField.text};
        
        [[M2LoginParser sharedHttpParser] loginWithUserInfoDictionary:authInfo onCompletion:^(NSDictionary *json) {
            NSLog(@"login response json %@",json);
            if ([[json objectForKey:Token_key] isEqualToString:@"0"]) {
                //密码错误
                [UIAlertView showWithTitle:nil message:NSLocalizedString(@"wrongPassword", @"") cancelButtonTitle:NSLocalizedString(@"confirm", @"") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [self.passwordField becomeFirstResponder];
                }];
            }else if([[json objectForKey:Token_key] isEqualToString:@"1"]){
                //账号不存在
                [UIAlertView showWithTitle:nil message:NSLocalizedString(@"wrongEmployeeID", @"")  cancelButtonTitle:NSLocalizedString(@"confirm", @"") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    [_ueserNameField becomeFirstResponder];
                }];
            }else{
                UserInfo *sharedUserInfo=[UserInfo sharedUserInfo];
//                [sharedUserInfo setWithDict:authInfo];
                sharedUserInfo.account=authInfo[@"account"];
                sharedUserInfo.password=authInfo[@"password"];
                sharedUserInfo.token=[json objectForKey:Token_key];
                [sharedUserInfo synchronize];
                [self httpGetEmployeeInfo];
                [Go2Util transitionToRootTabBarViewControllerFrom:self];
                
                [[M2PushNotificationParser sharedHttpParser] postUpdateClientAppInfoToken:json[Token_key] OnCompletion:nil];//设置推送设备令牌
            }
        }];
    }
}

/**
 *  输入框检查
 *
 *  @return 验证结果yes,no
 */
-(BOOL)checkField{
    if (!_ueserNameField.text||[self.ueserNameField.text isEqualToString:@""]) {
        [UIAlertView showWithTitle:NSLocalizedString(@"suggestion", @"") message:NSLocalizedString(@"noEmployeeID", @"") cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:@[NSLocalizedString(@"confirm", @"")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==0) {
                [self resignField];
            }else{
                [self.ueserNameField becomeFirstResponder];
            }
        }];
        return NO;
    }else if(!_passwordField||[_passwordField.text isEqualToString:@""]){
        [UIAlertView showWithTitle:NSLocalizedString(@"suggestion", @"") message:NSLocalizedString(@"noPassword", @"") cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:@[NSLocalizedString(@"confirm", @"")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==0) {
                [self resignField];
            }else{
                [self.passwordField becomeFirstResponder];
            }
        }];
        return NO;
    }
    return YES;
}

#pragma mark ========text Field delegate========
-(void)textFieldDidBeginEditing:(UITextField *)textField{
        [UIView animateWithDuration:0.5 animations:^{
            _loginPanel.transform=CGAffineTransformMakeTranslation(0, -80);
            
            CGAffineTransform tranlation=CGAffineTransformMakeTranslation(0,-30);
            CGAffineTransform scale=CGAffineTransformScale(tranlation, 0.7, 0.7);
            _logoImageView.transform=scale;
        }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        _loginPanel.transform=CGAffineTransformIdentity;
        _logoImageView.transform=CGAffineTransformIdentity;
    
    }];
    return YES;
}

/**
 *  取消焦点
 */
-(void)resignField{
    [_ueserNameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        _loginPanel.transform=CGAffineTransformIdentity;
        _logoImageView.transform=CGAffineTransformIdentity;
        
    }];
}

/**
 *  获取用户信息
 */
-(void)httpGetEmployeeInfo
{
    [[M2LoginParser sharedHttpParser] getEmployeeInfoOnCompletion:^(NSDictionary *json) {
        if (json) {
            
        }
    }];
}

/**
 *  介绍页面结束回调
 *
 *  @param introductionView 介绍页面
 *  @param finishType      finishType
 */
-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType
{
    NSLog(@"已经不是第一次启动了");

    _loginPanel.alpha=1;
    
    [_loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] withRect:_loginBtn.bounds] forState:UIControlStateNormal];
    
    [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _loginBtn.layer.cornerRadius=4;
    _loginBtn.layer.masksToBounds=YES;
    
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignField)];
    [self.view addGestureRecognizer:tapGesture];
    
    if (self.shouldShowUser) {
        self.ueserNameField.text=[UserInfo sharedUserInfo].account;
        self.passwordField.text=[UserInfo sharedUserInfo].password;
    }

}

-(void)introduction:(MYBlurIntroductionView *)introductionView didChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    if (panelIndex == 3) {
        introductionView.RightSkipButton.hidden = NO;
    }else{
        introductionView.RightSkipButton.hidden = YES;
    }
}
@end
