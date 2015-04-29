//
//  AppDelegate.m
//  Ming
//
//  Created by xiaoweiwu on 4/24/14.
//  Copyright (c) 2014 xiaowei wu. All rights reserved.
//
#import "AppDelegate.h"

#import "M3NewsViewController.h"
#import "M3UtilityViewController.h"
#import "M3DocumentViewController.h"
#import "M3SettingsViewController.h"
#import "M2LoginViewController.h"
#import "M2WelcomeViewcontroller.h"
#import <SVProgressHUD.h>

@implementation AppDelegate

/**
 *  统一定制界面UI，tabbar，navigation bar
 */
-(void)updateAppreance{
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexValue:0x0098f2 andAlpha:1.0] withRect:CGRectMake(0, 0,320,50)]];
    
    [[UITabBarItem appearance]setTitlePositionAdjustment:UIOffsetMake(0, 0)];
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{
                                                       UITextAttributeTextColor:[UIColor whiteColor],
                                                       UITextAttributeFont:[UIFont boldSystemFontOfSize:11]
                                                       }
                                            forState:UIControlStateNormal];

    [[UITabBarItem appearance]setTitleTextAttributes:@{
                                                       UITextAttributeTextColor:[UIColor whiteColor],
                                                       UITextAttributeFont:[UIFont boldSystemFontOfSize:11]
                                                       }
                                            forState:UIControlStateSelected];

    [[UITabBar appearance]setTintColor:[UIColor clearColor]];
    
    [[UITabBar appearance]setSelectionIndicatorImage:[UIImage imageWithColor:[UIColor clearColor] withRect:CGRectMake(0, 0,80,50)]];
    
    if(IS_VERSION7){
        [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithHexValue:0x469ae9 andAlpha:1.0]];
    }else{
        
        [[UINavigationBar appearance]setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexValue:0x55acee andAlpha:1.0] withRect:CGRectMake(0, 0, 320, 44)] forBarMetrics:UIBarMetricsDefault];
        
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor],
                                                           UITextAttributeFont:[UIFont fontWithName:@"AmericanTypewriter" size:17.0]
                                                           }];
    
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    if (IS_VERSION7) {
        [[UIToolbar appearance]setBarTintColor:[UIColor colorWithHexValue:0xdedbde andAlpha:1.0]];
    }else{
        [[UIToolbar appearance]setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexValue:0xdedbde andAlpha:1.0] withRect:CGRectMake(0, 0, 320, 44)] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self updateAppreance];
    
    NSLog(@"Saved User Info:%@",[UserInfo sharedUserInfo].token);
    
    if ([UserInfo sharedUserInfo].token) {
        M2WelcomeViewcontroller *welcomeViewController=[[M2WelcomeViewcontroller alloc]init];
        self.window.rootViewController=welcomeViewController;
    }else{
        M2LoginViewController *loginViewController=[[M2LoginViewController alloc]init];
        self.window.rootViewController=loginViewController;
    }

    //注册推送
//    if (IS_VERSION8) {
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
//                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
//                                                                             categories:nil]];
//        
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }else
//    {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    }
    
    [self checkDataBaseVersion];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
//{
//    NSString *myDeviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    myDeviceToken = [myDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    NSLog(@"device token %@",myDeviceToken);
//    [UserInfo sharedUserInfo].deviceToken = myDeviceToken;
//}
//
//- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
//{
//    NSLog(@"get device token failed:%@",error);
//}
//
//- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    NSLog(@"Received Notification： %@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
//    
//    NSString *message=[[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//    UIAlertView *alter=[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alter show];
//    
//    if (application.applicationState == UIApplicationStateInactive) {
//        [self tabbarSelectIndex:1];
//    }
//}

/**
 *  检查数据库版本
 */
-(void)checkDataBaseVersion
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *userPath = [documentsDir stringByAppendingPathComponent:@"Message.db"];
    
    NSString *srcPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Message.db"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:userPath];
    BOOL copySuccess = FALSE;
    
    NSError *error;
    
    if (!find) {
        NSLog(@"don't have writable copy, need to create one");
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [UserInfo sharedUserInfo].msgDoneFreshTime = [formatter dateFromString:@""];
        [UserInfo sharedUserInfo].publicFreshTime = [formatter dateFromString:@""];
        [[UserInfo sharedUserInfo] synchronize];
        copySuccess = [fileManager copyItemAtPath:srcPath toPath:userPath error:&error];
    }
    if (!copySuccess) {
        
        NSLog(@"Failed with message: '%@'.",[error localizedDescription]);
    }
}

/**
 *  下面tabbar选中
 *
 *  @param index 选中索引
 */
- (void)tabbarSelectIndex:(NSInteger)index {
    
}

@end
