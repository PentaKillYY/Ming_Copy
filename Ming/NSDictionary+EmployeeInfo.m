//
//  NSDictionary+EmployeeInfo.m
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-5.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "NSDictionary+EmployeeInfo.h"

#pragma mark ====employee info key=======
#define kEmployeeNo  @"employee_no"
#define kEmployeeName @"employee_name"
#define kEmployeeMail @"e_mail"
#define kEmployeePhone @"mobile_number"
#define kEmployeeGrade @"grade"

@implementation NSDictionary (EmployeeInfo)
@dynamic number;
@dynamic name;
@dynamic mail;
@dynamic grade;
@dynamic phone;

-(NSString *)number{
      return  [self objectForKey:kEmployeeNo];
}

-(NSString *)name{
    return  [self objectForKey:kEmployeeName];
}


-(NSString *)phone{
    return [self objectForKey:kEmployeePhone];
}

-(NSString *)mail{
    return [self objectForKey:kEmployeeMail];
    
}

-(NSString *)grade{
    return [self objectForKey:kEmployeeGrade];
}


@end
