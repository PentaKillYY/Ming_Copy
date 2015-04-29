//
//  Constant.h
//  Ming2.0
//
//  Created by xiaoweiwu on 12/3/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#pragma mark =======system======
#define IS_VERSION7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7
#define IS_VERSION8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8

#define Is_4Inch  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

#define Logo_middle_y_4inch 162.0
#define logo_middle_y_3 134.0

#pragma mark ======http request=====
#define kKey @"key"

/**
 *  接口正式环境
 */
#define kHttpBaseUrlString  @"http://ming.pactera.com/online/webservice"

/**
 *  接口测试环境
 */
//#define kHttpBaseUrlString  @"http://ming.pactera.com/uat/webservice"

/**
 *  PHS正式环境
 */
#define PHSUrl @"http://phs.pactera.com/phs/sites/all/webapp/WeekProject.html"

/**
 *  PHS测试环境
 */
#define PHSUATUrl @"http://phs.pactera.com/phsuat/sites/all/webapp/WeekProject.html"

/**
 *  考勤正式环境
 */
#define AttendanceUrl @"http://ming.pactera.com/MingMobile/Attendance_online/MobileWeb/"

/**
 *  考勤测试环境
 */
//#define AttendanceUrl @"http://ming.pactera.com/mingmobile/attendance/"

/**
 *  新闻正式环境
 */
#define NewsUrl @"http://ios.pactera.com/index.php?m=content&c=index&a=lists&"

/**
 *  工时正式环境
 */
#define TimesheetUrl @"http://ming.pactera.com/mingmobile/timesheet_online/index.html?"

/**
 *  工时测试环境
 */
//#define TimesheetUrl @"http://ming.pactera.com/MingMobile/timesheet/index.html?"

/**
 *  Travel正式环境
 */
#define TravelUrl @"http://travel.pactera.com/h5/MyTravel.aspx?"

/**
 *  Travel测试环境
 */
//#define TravelUrl @"http://travel.pactera.com/H/h5/MyTravel.aspx?"

/**
 *  请假正式环境
 */
#define AskForLeaveUrl @"http://ming.pactera.com/MingMobile/Attendance_online/MobileWeb/"

/**
 *  请假测试环境
 */
//#define AskForLeaveUrl @"http://ming.pactera.com/mingmobile/attendance/"

/**
 *  帮助地址
 */
#define kHelpUrl @"http://ming.pactera.com/qa.htm"

#pragma mark====httpRequestUrl====

#define kLoginUrl @"login"
#define kTokenUrl @"ValidateToken"
#define kEmployeeInfo @"GetEmployeeInfo"
#define kUploadImage @"UploadUserImage"

#define kGetSystemList @"GetSystemList"

#define kEmployeeInfoQuery @"EmployeeInfoQuery"

#define kGetEmployeeAsset @"GetEmployeeAsset"

#define kGetSharedFile @"GetSharedFile"
#define kSearchFile @"SearchFile"
#define kAddFileLog @"AddFileLog"

#define kGetVersionInfo @"GetVersionInfo"

#pragma mark  ====math=====
#define Deg_To_Radius(x) (M_PI * (x) / 180.0)

#pragma mark =====notification====
#define kAvatarChanged  @"AvatorDidChange"

#define kSysCountChanged @"SysCountChanged"

#pragma mark=====User default=====
#define kSavedDocumentInfo @"SavedDocumentInfo"
#define kSavedVersionInfo @"SavedVersionInfo"

#pragma mark =====version count===

extern  int const versionCount;

