//
//  Go2Util.m
//  Ming
//
//  Created by xiaoweiwu on 4/28/14.
//  Copyright (c) 2014 xiaowei wu. All rights reserved.
//

#import "Go2Util.h"
#import "M2LoginViewController.h"
#import "M3NewsViewController.h"
#import "M3UtilityViewController.h"
#import "M3DocumentViewController.h"
#import "M2ResourcesLibraryController.h"
#import "M3SettingsViewController.h"
#import "UIView+ScreenShot.h"
#import "M2AboutViewController.h"
#import "M2HelpViewController.h"
#import "PersonInfoViewController.h"
#import "M2MailSearchViewController.h"
#import "M2AttendanceViewContorller.h"
#import "M2AssetsViewController.h"
#import "M2TimeSheetViewController.h"
#import "M2PHSViewController.h"
#import "M2MessageDetailViewController.h"
#import "M2MessageDoneDetailViewController.h"
#import "BaseMessageViewController.h"
#import "M3TravelViewController.h"
#import "M2LeaveViewController.h"
@implementation Go2Util
+(void)transitionToRootTabBarViewControllerFrom:(UIViewController *)fromController{
    UIImageView *screenShotView=[fromController.view getScreenShotImageView];
    UITabBarController *tabBarController=[[UITabBarController alloc]init];
    UINavigationController *utilNav=[[UINavigationController alloc]initWithRootViewController:[[M3UtilityViewController alloc] init]];
    UINavigationController *setNav = [[UINavigationController alloc] initWithRootViewController:[[M3SettingsViewController alloc] init]];
    UINavigationController *newsNav = [[UINavigationController alloc] initWithRootViewController:[[M3NewsViewController alloc] init]];
    UINavigationController *docNav=[[UINavigationController alloc]initWithRootViewController:[[M2ResourcesLibraryController alloc]init]];
    
//    UINavigationController *newsNav=[[UINavigationController alloc]initWithRootViewController:[[M3NewsViewController alloc] init]];
//    M3NewsViewController*news = [[M3NewsViewController alloc] initWithNibName:@"M3NewsViewController" bundle:nil];
    
    tabBarController.viewControllers=@[utilNav,newsNav,docNav,setNav];
    
    
    fromController.view.window.rootViewController=tabBarController;
    
    //    UIImageView *bgView=[[UIImageView alloc]initWithFrame:tabBarController.view.frame];
    //    bgView.image=[UIImage imageNamed:@"login_bg"];
    //    [tabBarController.view.superview insertSubview:bgView atIndex:0];
    
    [tabBarController.view.superview addSubview:screenShotView];
    screenShotView.layer.transform=CATransform3DMakeTranslation(0, -screenShotView.height, 0);
    CABasicAnimation *disappear=[CABasicAnimation animationWithKeyPath:@"transform"];
    disappear.fromValue=[NSValue valueWithCATransform3D:CATransform3DIdentity];
    disappear.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -screenShotView.height, 0)];
    disappear.duration=1;
    disappear.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    disappear.completion=^(BOOL completed){
        [screenShotView removeFromSuperview];
    };
    
    CABasicAnimation *fade=[CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.fromValue=@1.0;
    fade.toValue=@0.0;
    fade.duration=1;
    fade.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    [screenShotView.layer addAnimation:disappear forKey:@"disappear"];
    [screenShotView.layer addAnimation:fade forKey:@"fade"];
    
    CATransform3D perspective=CATransform3DIdentity;
    perspective.m34=-0.002;
    tabBarController.view.superview.layer.sublayerTransform=perspective;
    
    
    CABasicAnimation *appear=[CABasicAnimation animationWithKeyPath:@"transform"];
    appear.fromValue=[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, -200)];
    appear.toValue=[NSValue valueWithCATransform3D:CATransform3DIdentity];
    appear.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    appear.duration=1;
    appear.completion=^(BOOL completed){
        tabBarController.view.superview.layer.sublayerTransform=CATransform3DIdentity;
    };
    [tabBarController.view.layer addAnimation:appear forKey:@"appear"];
    
    [tabBarController.view.superview setBackgroundColor:[UIColor colorWithHexValue:0xfafafa andAlpha:0.5]];
    
    
}






+(void)gotoLoginFrom:(UIViewController *)fromController{
    
//    if ([fromController isMemberOfClass:[M2SettingsViewController class]]) {
//        CATransition *transition=[CATransition animation];
//        transition.duration=0.5;
//        transition.type=kCATransitionMoveIn;
//        transition.subtype=kCATransitionFromBottom;
//        transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        [fromController.view.window.layer addAnimation:transition forKey:@"ToTabBarTransition"];
//    }
    
    fromController.view.window.rootViewController=[[M2LoginViewController alloc]init];
}

+(void)gotoLoginFrom:(UIViewController *)fromController shouldShowUser:(BOOL)shouldShow{
    M2LoginViewController *loginViewController=[[M2LoginViewController alloc] init];
    loginViewController.shouldShowUser=shouldShow;
    fromController.view.window.rootViewController=loginViewController;
}
/**
 *  跳转关于
 *
 *  @param fromController 原controller
 */
+(void)go2AboutFrom:(UIViewController *)fromController{
    M2AboutViewController *aboutViewController=[[M2AboutViewController alloc]init];
    aboutViewController.hidesBottomBarWhenPushed=YES;
    [fromController.navigationController  pushViewController:aboutViewController animated:YES];
}
/**
 *  跳转帮助
 *
 *  @param fromController 原controller
 */
+(void)go2HelpFrom:(UIViewController*)fromController{

    M2HelpViewController *helpViewController=[[M2HelpViewController alloc]init];
    helpViewController.hidesBottomBarWhenPushed=YES;
    [fromController.navigationController  pushViewController:helpViewController animated:YES];
}

/**
 *  跳转个人信息
 *
 *  @param fromController 原controller
 */
+(void)go2PersonInfoFrom:(UIViewController*)fromController{
    PersonInfoViewController* personInfoViewController = [[PersonInfoViewController alloc] init];
    personInfoViewController.hidesBottomBarWhenPushed = YES;
    [fromController.navigationController pushViewController:personInfoViewController animated:YES];
}

/**
 *  跳转考勤
 *
 *  @param fromController 原controller
 *  @param countStr       考勤数字
 */
+(void)go2AttendanceFrom:(UIViewController *)fromController withCountStr:(NSString *)countStr
{
    M2AttendanceViewContorller *attendanceViewController=[[M2AttendanceViewContorller alloc]init];
    attendanceViewController.hidesBottomBarWhenPushed=YES;
    attendanceViewController.attendaceCount=countStr;
    [fromController.navigationController pushViewController:attendanceViewController animated:YES];
}

/**
 *  跳转请假
 *
 *  @param fromController 原controller
 */
+(void)go2LeaveFrom:(UIViewController *)fromController
{
    M2LeaveViewController *leaveViewController=[[M2LeaveViewController alloc]init];
    leaveViewController.hidesBottomBarWhenPushed=YES;
    [fromController.navigationController pushViewController:leaveViewController animated:YES];
}
/**
 *  跳转工时
 *
 *  @param fromController 原controller
 *  @param countStr       工时数字
 */
+(void)go2TimeSheetFrom:(UIViewController *)fromController withCountStr:(NSString *)countStr{
    M2TimeSheetViewController *timeSheetViewController=[[M2TimeSheetViewController alloc] init];
    timeSheetViewController.hidesBottomBarWhenPushed=YES;
    timeSheetViewController.timeSheetCount=countStr;
    [fromController.navigationController pushViewController:timeSheetViewController animated:YES];
}


+(void)go2MailSearchFrom:(UIViewController *)fromController{
    M2MailSearchViewController *mailSearchViewController=[[M2MailSearchViewController alloc]init];
    mailSearchViewController.hidesBottomBarWhenPushed=YES;
    [fromController.navigationController pushViewController:mailSearchViewController animated:YES];
}


+(void)go2AssetsFrom:(UIViewController *)fromController{
    M2AssetsViewController *assetsViewController=[[M2AssetsViewController alloc]init];
    assetsViewController.hidesBottomBarWhenPushed=YES;
    [fromController.navigationController pushViewController:assetsViewController animated:YES];
    
}
/**
 *  跳转PHS
 *
 *  @param fromController 原controller
 */
+(void)go2PHSfrom:(UIViewController*)fromController{
    M2PHSViewController* phsViewController = [[M2PHSViewController alloc] init];
    phsViewController.hidesBottomBarWhenPushed = YES;
    [fromController.navigationController pushViewController:phsViewController animated:YES];
}

/**
 *  跳转消息详情
 *
 *  @param fromController 原controller
 *  @param response       选中的数量
 *  @param integerNumber  序号
 */
+(void)go2MessageDetailForm:(UIViewController*)fromController responseMessage:(NSMutableArray*)response IntegerNumber:(NSInteger)integerNumber{
    M2MessageDetailViewController* messageDetailViewController = [[M2MessageDetailViewController alloc] init];
    messageDetailViewController.hidesBottomBarWhenPushed = YES;
    messageDetailViewController.responseArray = response;
    messageDetailViewController.indexNumber = integerNumber;
    [fromController.navigationController pushViewController:messageDetailViewController animated:YES];
}
/**
 *  跳转已审批
 *
 *  @param fromController 原controller
 *  @param response       选中的数量
 *  @param IntegerNumber  序号
 *  @param count          数量
 */
+(void)go2MessageDoneDetailFrom:(UIViewController *)fromController responseMessage:(NSMutableArray *)response IntegerNumber:(NSInteger)IntegerNumber Count:(NSInteger)count
{
    M2MessageDoneDetailViewController* messageDoneDetailViewController = [[M2MessageDoneDetailViewController alloc] init];
    messageDoneDetailViewController.hidesBottomBarWhenPushed = YES;
    messageDoneDetailViewController.responseArray = response;
    messageDoneDetailViewController.indexNumber = IntegerNumber;
    messageDoneDetailViewController.responseCount = count;
    
    [fromController.navigationController pushViewController:messageDoneDetailViewController animated:YES];
}
/**
 *  跳转审批
 *
 *  @param fromController 原controller
 */

+(void)go2MessageInfoForm:(UIViewController *)fromController{
    BaseMessageViewController* baseMessageViewController = [[BaseMessageViewController alloc] init];
    baseMessageViewController.hidesBottomBarWhenPushed = YES;
    [fromController.navigationController pushViewController:baseMessageViewController animated:YES];
}

/**
 *  跳转Travel
 *
 *  @param fromController 原controller
 */
+(void)go2TravelFrom:(UIViewController*)fromController{

    M3TravelViewController* travelViewController = [[M3TravelViewController alloc] init];
    travelViewController.hidesBottomBarWhenPushed = YES;
    [fromController.navigationController pushViewController:travelViewController animated:YES];
}
@end
