//
//  ZhiFuBaoTool.h
//  YunChao
//
//  Created by YuanZhiPu on 15/11/9.
//  Copyright © 2015年 why. All rights reserved.
//
/**/
#import <Foundation/Foundation.h>

@interface ZhiFuBaoTool : NSObject

+ (void)payForZhiFuBao:(NSString *)itemsName itemsParce:(NSString *)itemsParce orderNum:(NSString *)orderNum SuccessBlock:(void(^)(NSDictionary*dic))successBlock failBlock:(void(^)(NSDictionary *error))failBlock;

@end
