//
//  M3SettingsViewController.m
//  Ming
//
//  Created by xiaoweiwu on 4/29/14.
//  Copyright (c) 2014 xiaowei wu. All rights reserved.
//

#import "M3SettingsViewController.h"
#import "M2LoginParser.h"
#import "HandleDataBase.h"
#import <SVProgressHUD.h>
@interface M3SettingsViewController (){
   
   
}
@end

@implementation M3SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=NSLocalizedString(@"setting", @"");
        
        self.view.backgroundColor = [UIColor colorWithHexValue:0Xebeff2 andAlpha:1.0];
        [self setTabBarItemWithImage:[UIImage imageNamed:@"set_icon"] withSelectedImage:[UIImage imageNamed:@"set_icon_sel"]];
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)PersonInfoAction:(id)sender {
    [Go2Util go2PersonInfoFrom:self];
}

- (IBAction)VersionInfoAction:(id)sender {
    [[M2LoginParser sharedHttpParser]getVersionInfoOnCompletion:^(id json) {
        NSLog(@"version info :%@",json);
        if (versionCount>=[json[@"VersionCount"] integerValue]){
            
            [UIAlertView showWithTitle:NSLocalizedString(@"suggestion", @"") message:NSLocalizedString(@"当前版本为最新", @"") cancelButtonTitle:NSLocalizedString(@"confirm", @"") otherButtonTitles:nil tapBlock:nil];
        }else{
            [UIAlertView showWithTitle:NSLocalizedString(@"suggestion", @"") message:NSLocalizedString(@"有新版本，是否更新", @"") cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:@[NSLocalizedString(@"更新", @"")]  tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex==1) {
                    NSString *urlString=[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",json[@"appUrl"]];
                    NSURL *url=[NSURL URLWithString:urlString];
                    [[UIApplication sharedApplication] openURL:url];
                    [[NSUserDefaults standardUserDefaults] setObject:json forKey:kSavedVersionInfo];
                    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kSavedDocumentInfo];
                }
            }];
            
        }
    }];

}

- (IBAction)HelpAction:(id)sender {
    [Go2Util go2HelpFrom:self];
}

- (IBAction)AboutAction:(id)sender {
    [Go2Util go2AboutFrom:self];
}

- (IBAction)ClearCacheAction:(id)sender {
    NSLog(@"cached image size:%d count:%d",(int)[SDImageCache sharedImageCache].getSize,[SDImageCache sharedImageCache].getDiskCount);
    
    [UIAlertView showWithTitle:NSLocalizedString(@"suggestion", @"") message:NSLocalizedString(@"清除本地缓存", @"") cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:@[NSLocalizedString(@"confirm", @"")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            NSLog(@"confirm clear cache");
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache]clearMemory];
            [HandleDataBase cleanDataBaseCache];
            
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"清除成功", @"")];
        }
    }];

}

- (IBAction)LogoutAction:(id)sender {
    [UIAlertView showWithTitle:NSLocalizedString(@"suggestion", @"") message:NSLocalizedString(@"确定退出登录", @"") cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:@[NSLocalizedString(@"confirm", @"")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            NSLog(@"confirm log out");
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache]clearMemory];
            [HandleDataBase cleanDataBaseCache];
            [[UserInfo sharedUserInfo] logout];
            [Go2Util gotoLoginFrom:self];
            
        }
    }];

}







@end
