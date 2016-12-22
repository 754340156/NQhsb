//
//  UpdateUserInfo.h
//  Operator
//
//  Created by 白小田 on 2016/12/2.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateUserInfo : NSObject
+(void)updateUserInfo;
+(NSString *)getUserDataTime:(NSString *)time;
+(NSString *)intervalSinceNow:(NSString *)theDate;
@end
