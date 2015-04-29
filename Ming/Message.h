//
//  Message.h
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-9.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "JSONModel.h"

@interface Message : JSONModel
@property (nonatomic,strong) NSString *MsgID;
@property (nonatomic,strong) NSString *MsgTitle;
@property (nonatomic,strong) NSString *MsgContent;
@property (nonatomic,strong) NSString *ReadTimes;
@property (nonatomic,strong) NSString *CreatedBy;
@property (nonatomic,strong) NSString *CreatedTime;
@property (nonatomic,strong) NSString *SystemID;
@property (nonatomic,strong) NSString *SystemName;
@property (nonatomic,strong) NSString *SystemLogo;
@property (nonatomic,strong) NSString *ReadStatus;
@end
