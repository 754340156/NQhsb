//
//  MainSearchFinishModels.m
//  Operator
//
//  Created by 白小田 on 16/10/20.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "MainSearchFinishModels.h"

@implementation MainSearchFinishModels

@end



@implementation MainSearchFinishResponse

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [MainSearchFinishList class]};
}

@end


@implementation MainSearchFinishList

@end


