//
//  TitleModels.m
//  Operator
//
//  Created by 白小田 on 16/9/23.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "TitleModels.h"

@implementation TitleModels

@end



@implementation titleResponse

+ (NSDictionary *)objectClassInArray{
    return @{@"nodes" : [titleNodes class]};
}

@end


@implementation titleNodes

+ (NSDictionary *)objectClassInArray{
    return @{@"nodes" : [titleTwoNodes class]};
}

@end


@implementation titleTwoNodes

+ (NSDictionary *)objectClassInArray{
    return @{@"nodes" : [titleThreeNodes class]};
}

@end


@implementation titleThreeNodes

@end


