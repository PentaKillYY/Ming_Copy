//
//  M2BaseModel.m
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-4.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2BaseModel.h"

@implementation M2BaseModel


-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
}

/**
 *  保存Model
 */

-(void)synchronize{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:self];
    [defaults setObject:data forKey:NSStringFromClass(self.class)];
}
/**
 *  设置Model
 *
 *  @param dict 数据
 */


-(void)setWithDict:(NSDictionary *)dict{
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key];
    }];
}


@end
