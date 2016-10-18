//
//  BaseModel.m
//  CarTreasure
//
//  Created by hai on 16/4/7.
//  Copyright © 2016年 NeiQuan. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

//MJLogAllIvars

+ (NSDictionary *)replacedKeyFromPropertyName
{
    NSDictionary *dict = @{@"ID":@"id"};
    return dict;
}
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if (oldValue == nil || [oldValue isKindOfClass:[NSNull class]]){
        return @"";
    }
    //把没有的字段处理成空字符串
    if (!oldValue)
    {
        return @"";
    }
    
    return oldValue;
}
@end
