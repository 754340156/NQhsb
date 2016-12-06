//
//  WeiXinTool.h
//  YunChao
//
//  Created by YuanZhiPu on 15/11/9.
//  Copyright © 2015年 why. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApi.h"

@interface WeiXinTool : NSObject


/**
 
 @param itemsName  商品名称
 @param itemsParce 价格
 @param orderId    订单id
 */
+ (void)payForWeiXin:(NSString *)itemsName itemsParce:(NSString *)itemsParce  orderid:(NSString *)orderId;

@end
