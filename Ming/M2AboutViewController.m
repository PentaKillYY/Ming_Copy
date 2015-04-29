//
//  M2AboutViewController.m
//  Ming2.0
//
//  Created by xiaoweiwu on 12/17/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import "M2AboutViewController.h"
#import "CommonMacro.h"

@interface M2AboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@end

@implementation M2AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=NSLocalizedString(@"关于", @"");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *versionString=[[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    self.versionLabel.text=[NSString stringWithFormat:@"V %@",versionString];
    UITapGestureRecognizer* phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhone)];
    [self.phoneLabel addGestureRecognizer:phoneTap];
    
    UITapGestureRecognizer* emailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendEmail)];
    [self.emailLabel addGestureRecognizer:emailTap];
    if (SCREEN_HEIGHT > 480) {
        self.companyLabel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-44-20-15);
    }else{
        self.companyLabel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-44-20-15);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)takePhone
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://041184556771"]];
}

-(void)sendEmail
{
    NSLog(@"----sendEmail----");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://ITApp_Support@pactera.com"]];
}
@end
