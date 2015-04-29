//
//  PersonInfoViewController.m
//  Ming
//
//  Created by HuangLuyang on 14-5-5.
//  Copyright (c) 2014年 xiaowei wu. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "UserInfo.h"
#import "NSString+Date.h"
#import "M2LoginParser.h"
#import "M2AvatarView.h"
#import <UIActionSheet+Blocks.h>
@interface PersonInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *innerScrollView;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *deparmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *hireDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *managerLabel;
@property (weak, nonatomic) IBOutlet UILabel *employeeNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;
@property (weak, nonatomic) IBOutlet M2AvatarView *avatarView;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIView *avatarBackView;
@property (weak, nonatomic) IBOutlet UIView *avatarBack;

@end

@implementation PersonInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"personInfo", @"");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    _innerScrollView.contentSize =CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-40) ;
//    self.avatarBackView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"personInfo_bg.png"]];
    [self setEmployeeInfos];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  设置个人信息及头像
 */

-(void)setEmployeeInfos{
    
    UserInfo *userInfo=[UserInfo sharedUserInfo];
    self.employeeNameLabel.text=userInfo.employeeName;
    self.employeeNoLabel.text=userInfo.employeeNo;
    self.mobileLabel.text=userInfo.mobileNumber;
    self.emailLabel.text=userInfo.email;
    self.positionLabel.text=userInfo.positionName;
    self.deparmentLabel.text=userInfo.departmentName;
    self.companyLabel.text=userInfo.companyName;
    self.locationLabel.text=userInfo.workLocation;
    self.hireDateLabel.text=[userInfo.hireDate getYearString];
    self.managerLabel.text=userInfo.lineManagerName;
    
    if ([UserInfo sharedUserInfo].avatar) {
        self.avatarView.image=[UserInfo sharedUserInfo].avatar;
    }
    
    if ([UserInfo sharedUserInfo].avatarUrl&&[self checkReachability]) {
        [self.avatarView setImageWithURL:[NSURL URLWithString:[UserInfo sharedUserInfo].avatarUrl]];
    }
    
    self.avatarBack.backgroundColor = [UIColor whiteColor];
    self.avatarBack.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarBack.layer.borderWidth = 1;
    self.avatarBack.layer.cornerRadius = self.avatarBack.width/2;
    
    self.avatarView.layer.cornerRadius=_avatarView.width/2.0;

}


/**
 *  头像设置
 *
 *  @param IBAction 选取照片
 *
 *  @return sender button
 */
#pragma UIImagePickerControllerDelegate
- (IBAction)pickImageAction:(id)sender {
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.delegate=self;
    imagePicker.allowsEditing=YES;
    
    [UIActionSheet showInView:self.view withTitle:NSLocalizedString(@"selectAvatar", @"") cancelButtonTitle:NSLocalizedString(@"cancel", @"") destructiveButtonTitle:nil otherButtonTitles:@[NSLocalizedString(@"takePhoto", @""),NSLocalizedString(@"choosePhoto", @"")] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        
        switch (buttonIndex) {
            case 0:
                imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                imagePicker.showsCameraControls=YES;
                [self presentViewController:imagePicker animated:YES completion:nil];
                
                break;
            case 1:
                imagePicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:imagePicker animated:YES completion:nil];
                break;
            default:
                break;
        }
        
    }];
    
    
}

/**
 *  照片选取取消
 *
 *  @param picker  选取器Controller
 */
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  照片选取结束
 *
 *  @param picker 选取器Controller
 *  @param info   图片信息
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.avatarView.image=info[UIImagePickerControllerEditedImage];
    [UserInfo sharedUserInfo].avatar=self.avatarView.image;
    [UserInfo sharedUserInfo].avatarUrl=nil;
    [[UserInfo sharedUserInfo] synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:kAvatarChanged object:nil];
    [[M2LoginParser sharedHttpParser] upLoadAvatarImage:self.avatarView.image OnCompletion:^(NSDictionary *json) {
        NSLog(@"upload image response:%@",json);
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  检查网络
 *
 *  @return Bool
 */
-(BOOL)checkReachability{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    }
    
    return YES;
    
}

@end
