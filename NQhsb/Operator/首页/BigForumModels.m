//
//  BigForumModels.m
//  Operator
//
//  Created by 白小田 on 16/10/17.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "BigForumModels.h"

@implementation BigForumModels

@end
@implementation BigForumResponse

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [BigForumList class]};
}

@end


@implementation BigForumList

@end


