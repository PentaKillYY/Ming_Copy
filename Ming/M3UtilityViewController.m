//
//  M3YUtilityViewController.m
//  Ming
//
//  Created by xiaoweiwu on 4/29/14.
//  Copyright (c) 2014 xiaowei wu. All rights reserved.
//

#import "M3UtilityViewController.h"
#import "M2CornorMarkLabel.h"
#import "M2PublicMessageParser.h"
#import "M2LoginParser.h"
@interface M3UtilityViewController ()
@property (weak, nonatomic) IBOutlet M2CornorMarkLabel *sysCountLabel;
@property (weak, nonatomic) IBOutlet M2CornorMarkLabel *attendanceCount;
@property (weak, nonatomic) IBOutlet UIScrollView *innerScrollView;
@property (weak, nonatomic) IBOutlet M2CornorMarkLabel *workHoursCount;
@end

@implementation M3UtilityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=NSLocalizedString(@"应用", @"");
        [self setTabBarItemWithImage:[UIImage imageNamed:@"util_icon"] withSelectedImage:[UIImage imageNamed:@"util_icon_sel"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[M2PublicMessageParser sharedHttpParser] getMySummaryCountOnCompletion:^(NSDictionary *json) {
        _sysCountLabel.countString=json[@"systemMessageCount"];
        double delayInSeconds = 0.25;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            _attendanceCount.countString=json[@"abnormalAttendance"];
        });

        double delayIn2Seconds = 0.5;
        dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayIn2Seconds * NSEC_PER_SEC));
        dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
            _workHoursCount.countString=json[@"missingWorkingHours"];
        });
    }];

    [[M2LoginParser sharedHttpParser] getSystemListOnCompletion:^(NSArray *json) {
        NSLog(@"system list:%@",json);
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sysCountChanged:) name:kSysCountChanged object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)timeSheetAction:(id)sender {
}

- (IBAction)attendanceAction:(id)sender {
}

/**
 *  导航Action
 *
 *  @param sender button
 */
- (IBAction)assetsAction:(id)sender {
    [Go2Util go2AssetsFrom:self];
}

/**
 *  导航Action
 *
 *  @param sender button
 */
- (IBAction)mailSearchAction:(id)sender {
    [Go2Util go2MailSearchFrom:self];
}

/**
 *  导航Action
 *
 *  @param sender button
 */
- (IBAction)timeSheet:(id)sender {
    [Go2Util go2TimeSheetFrom:self withCountStr:_workHoursCount.text];
    //    [M2Go2Util go2TimeSheetFrom:self withCountStr:@"15"];
}

/**
 *  导航Action
 *
 *  @param sender button
 */
- (IBAction)abnormalAttend:(id)sender {
    [Go2Util go2AttendanceFrom:self withCountStr:_attendanceCount.text];
    //    [M2Go2Util go2AttendanceFrom:self withCountStr:@"5"];
}

/**
 *  导航Action
 *
 *  @param sender button
 */
- (IBAction)askForLeave:(id)sender {
    [Go2Util go2LeaveFrom:self];
    //    [M2Go2Util go2AttendanceFrom:self withCountStr:@"5"];
}

/**
 *  导航Action
 *
 *  @param sender button
 */
- (IBAction)phsAction:(id)sender {
    [Go2Util go2PHSfrom:self];
}

/**
 *  导航Action
 *
 *  @param sender button
 */

- (IBAction)approveAction:(id)sender {
    [Go2Util go2MessageInfoForm:self];
}

/**
 *  导航Action
 *
 *  @param sender button
 */
- (IBAction)travelAction:(id)sender {
    [Go2Util go2TravelFrom:self];
}

-(void)sysCountChanged:(NSNotification *)notification{
    NSDictionary *userInfo=notification.userInfo;
    [_sysCountLabel setCountString:userInfo[@"count"]];
//        _sysCountLabel.countString=userInfo[@"count"];
}
@end
