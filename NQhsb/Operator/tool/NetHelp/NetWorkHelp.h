//
//  NetWorkHelp.h
//  Thousands Of Donkey
//
//  Created by a on 15/7/23.
//  Copyright (c) 2015年 NeiQuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "YZPData.h"
@interface NetWorkHelp : NSObject

+ (void)netWorkWithURLString:(NSString *)urlString parameters:(NSDictionary*)parameters SuccessBlock:(void(^)(NSDictionary*dic))successBlock failBlock:(void(^)(NSError*error))failBlock;

+ (void)getWorkReachability;

+ (void)upLoadWithURLString:(NSString *)urlString parameters:(NSDictionary*)parameters data:(YZPData *)data SuccessBlock:(void(^)(NSDictionary*dic))successBlock failBlock:(void(^)(NSError*error))failBlock;

+ (void)POSTWithUrl:(NSString *)url parameters:(NSString *)parameters SuccessBlock:(void(^)(NSDictionary*dic))successBlock;

+(NSString*)DataTOjsonString:(id)object;

@end
