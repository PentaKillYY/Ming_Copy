//
//  M2BaseModel.h
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-4.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#define OBJC_STRINGIFY(x) @#x
#define encodeObject(x) [aCoder encodeObject:self.x forKey:OBJC_STRINGIFY(x)]
#define decodeObject(x) self.x = [aDecoder decodeObjectForKey:OBJC_STRINGIFY(x)]


@interface M2BaseModel : NSObject<NSCoding>
-(void)synchronize;

-(void)setWithDict:(NSDictionary *)dict;

@end
