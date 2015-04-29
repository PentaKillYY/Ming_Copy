//
//  M2UserInfo.m
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-4.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//
#import "UserInfo.h"
#import "NSDictionary+EmployeeInfo.h"

@implementation UserInfo

+(instancetype)sharedUserInfo{
    static UserInfo *sharedUserInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
        if (data) {
            sharedUserInfo=(UserInfo *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        }else{
            sharedUserInfo=[[UserInfo alloc]init];
        }
    });
    
    return sharedUserInfo;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        decodeObject(account);
        decodeObject(password);
        decodeObject(token);
        decodeObject(employeeNo);
        decodeObject(employeeName);
        decodeObject(email);
        decodeObject(hireDate);
        decodeObject(departmentName);
        decodeObject(positionName);
        decodeObject(lineManagerName);
        decodeObject(workLocation);
        decodeObject(mobileNumber);
        decodeObject(avatarUrl);
        decodeObject(systemList);
        decodeObject(msgDoneFreshTime);
        decodeObject(publicFreshTime);
        decodeObject(deviceToken);
        decodeObject(companyName);
        self.avatar=[UIImage imageWithData:[aDecoder decodeObjectForKey:@"avatar"]];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    encodeObject(account);
    encodeObject(password);
    encodeObject(token);
    encodeObject(employeeNo);
    encodeObject(employeeName);
    encodeObject(email);
    encodeObject(hireDate);
    encodeObject(departmentName);
    encodeObject(positionName);
    encodeObject(lineManagerName);
    encodeObject(workLocation);
    encodeObject(mobileNumber);
    encodeObject(avatarUrl);
    encodeObject(systemList);
    encodeObject(msgDoneFreshTime);
    encodeObject(publicFreshTime);
    encodeObject(deviceToken);
    encodeObject(companyName);
    [aCoder encodeObject:UIImageJPEGRepresentation(self.avatar, 0.7) forKey:@"avatar"];
}

-(void)setWithDict:(NSDictionary *)dict{
//    [super setWithDict:dict];
    self.employeeNo=dict[@"employee_no"];
    self.employeeName=dict.name;
    self.email=dict.mail;
    self.hireDate=dict[@"hire_date"];
    self.departmentName=dict[@"department_name"];
    self.positionName=dict[@"position_name"];
    self.lineManagerName=dict[@"line_manager_name"];
    self.workLocation=dict[@"work_location"];
    self.mobileNumber=dict[@"mobile_number"];
    self.avatarUrl=dict[@"image"];
    self.companyName=dict[@"company_name"];
}

-(void)logout{
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:NSStringFromClass(self.class)];
    [self setWithDict:nil];
}

@end
