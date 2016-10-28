//
//  WeiXinTool.m
//  YunChao
//
//  Created by YuanZhiPu on 15/11/9.
//  Copyright © 2015年 why. All rights reserved.
//

#import "WeiXinTool.h"
#import "payRequsestHandler.h"
@implementation WeiXinTool


+ (void)payForWeiXin:(NSString *)itemsName itemsParce:(NSString *)itemsParce  orderid:(NSString *)orderId{
    payRequsestHandler *req = [[payRequsestHandler alloc]init];
    [req init:APP_ID mch_id:MCH_ID];
    //设置商户密钥
    [req setKey:PARTNER_ID];
    //预支付订单   1表示一分钱
    NSMutableDictionary *dict = [req sendPay_demo:itemsName orderPrice:itemsParce orderid:orderId];
    if (dict == nil) {
        //获取debug信息
        
        NSString *debug = [req getDebugifo];
        NSLog(@"%@\n\n",debug);
    }else{
        //获取字典的值
        NSLog(@"%@\n\n",[req getDebugifo]);
        NSMutableString *stamp = [dict objectForKey:@"timestamp"];
        //发起微信支付需要的参数
        PayReq *req = [[PayReq alloc]init];
        req.openID = [dict objectForKey:@"appid"];//微信号与APPID组成的唯一标识，用于判断是否切换账户
        req.partnerId = [dict objectForKey:@"partnerid"];//商家id
        req.prepayId = [dict objectForKey:@"prepayid"];//预支付订单
        req.nonceStr = [dict objectForKey:@"noncestr"];//随机串防止重发
        req.timeStamp = stamp.intValue;//时间戳防止重发
        req.package = [dict objectForKey:@"package"];//签名
        req.sign = [dict objectForKey:@"sign"];//对数据的签名
        
        //调用微信
        if ([WXApi isWXAppInstalled]) {
            [WXApi sendReq:req];
        }else{
            [[[UIAlertView alloc]initWithTitle:nil message:@"你未安装微信" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil] show];
        }
    }
}

@end
