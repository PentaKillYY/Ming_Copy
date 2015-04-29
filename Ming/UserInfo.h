//
//  M2UserInfo.h
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-4.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2BaseModel.h"

@interface UserInfo : M2BaseModel
@property (nonatomic,strong) NSString *account;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *employeeNo;
@property (nonatomic,strong) NSString *employeeName;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *hireDate;
@property (nonatomic,strong) NSString *departmentName;
@property (nonatomic,strong) NSString *positionName;
@property (nonatomic,strong) NSString *lineManagerName;
@property (nonatomic,strong) NSString *workLocation;
@property (nonatomic,strong) NSString *mobileNumber;
@property (nonatomic,strong) UIImage *avatar;
@property (nonatomic,strong) NSString *avatarUrl;
@property (nonatomic,strong) NSArray *systemList;
@property (nonatomic,strong) NSDate *msgDoneFreshTime;
@property (nonatomic,strong) NSDate *publicFreshTime;
@property (nonatomic,strong) NSString* deviceToken;
@property (nonatomic,strong) NSString *companyName;
+(instancetype)sharedUserInfo;
-(void)logout;
@end
