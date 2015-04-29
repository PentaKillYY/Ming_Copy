 //
//  M2WelcomeViewcontrollerViewController.m
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-5.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2WelcomeViewcontroller.h"
#import "M2LoginParser.h"
#import "AppDelegate.h"
#import "CommonMacro.h"
@interface M2WelcomeViewcontroller ()<MYIntroductionDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *welcomeImageView;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation M2WelcomeViewcontroller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
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
        if (Is_4Inch) {
            _welcomeImageView.image=[UIImage imageNamed:@"welcome7_1136"];
        }else{
            _welcomeImageView.image=[UIImage imageNamed:@"welcome7_960"];
        }

        [self checkUpdate];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

/**
 *  验证token
 */
-(void)validateToke{
    [[M2LoginParser sharedHttpParser]validateTokeOnCompletion:^(NSDictionary *json) {
        switch ([[json objectForKey:kKey] integerValue]) {
            case 0:
                [Go2Util gotoLoginFrom:self];
                break;
                
            case 1:
                [Go2Util transitionToRootTabBarViewControllerFrom:self];
                
            default:
                break;
        }
    }onFailure:^(id json) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            [appDelegate.window makeToast:NSLocalizedString(@"timeout", @"") duration:3 position:@"center"];
        });
        [Go2Util gotoLoginFrom:self shouldShowUser:YES];

    }onNoConnect:^(id json) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [Go2Util gotoLoginFrom:self shouldShowUser:YES];
        });
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  检查更新
 */
- (void)checkUpdate{
    [[M2LoginParser sharedHttpParser]getVersionInfoOnCompletion:^(id json) {
        NSLog(@"version info :%@",json);
        if (versionCount>=[json[@"VersionCount"] integerValue]) {
                [self validateToke];
            }else{
                [UIAlertView showWithTitle:NSLocalizedString(@"suggestion", @"") message:NSLocalizedString(@"有新版本，是否更新", @"")  cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:@[NSLocalizedString(@"更新", @"")]  tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex==1) {
                        NSString *urlString=[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",json[@"appUrl"]];
                        NSURL *url=[NSURL URLWithString:urlString];
                        [[UIApplication sharedApplication] openURL:url];
                        [[NSUserDefaults standardUserDefaults] setObject:json forKey:kSavedVersionInfo];
                        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kSavedDocumentInfo];
                    }else if(buttonIndex==0){
                        [self validateToke];
                    }
                }];
            }
    } onFailure:^(id json) {
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            [appDelegate.window makeToast:NSLocalizedString(@"timeout", @"") duration:3 position:@"center"];

        });

        [Go2Util gotoLoginFrom:self shouldShowUser:YES];

    }onNoConnect:^(id json) {
        
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [Go2Util gotoLoginFrom:self shouldShowUser:YES];
                });
    }];
}

-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType
{
    if (Is_4Inch) {
        _welcomeImageView.image=[UIImage imageNamed:@"welcome7_1136"];
    }else{
        _welcomeImageView.image=[UIImage imageNamed:@"welcome7_960"];
    }
    [self checkUpdate];
}

-(void)introduction:(MYBlurIntroductionView *)introductionView didChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    if (panelIndex == 3) {
        introductionView.RightSkipButton.hidden = NO;
    }else{
        introductionView.RightSkipButton.hidden = YES;
    }
}
@end
