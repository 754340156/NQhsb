//
//  ZhiFuBaoTool.m
//  YunChao
//
//  Created by YuanZhiPu on 15/11/9.
//  Copyright © 2015年 why. All rights reserved.
//
/*  */
#import "ZhiFuBaoTool.h"
#import "Order.h"
#import "DataSigner.h"

@implementation ZhiFuBaoTool

+ (void)payForZhiFuBao:(NSString *)itemsName itemsParce:(NSString *)itemsParce SuccessBlock:(void(^)(NSDictionary*dic))successBlock{
 
    
    
    NSString *partner = @"2088421537591180";
    NSString *seller = @"hemabuluo@homehome.cc";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANJfcJv9lvaSLBzrAULqOsT0c1oeK0jr7K7f9LVtata4pJpBpEYf1gU4ThpBkRTCYo+II60ERQT0HIqOyyrW9lmScvIzZ9aaofTc7zDjvaINdCARAn99zX4Q0Wy4VyoigLhJ+en/f+14QPuEcS4oJVDVjJ3/Acw18axFoFLgikGtAgMBAAECgYA+PdqVbHwDy8+dZrJi1+Y3a5PNb+uikZrfSoeePhdEHDEnKpCt5rFtrfD9t7RzDegXS1Iy2HaLNqZTIFhf/mW4JNiUR1N4jbzrdnW90t/0SAbmGBOCdzJIU6+taLY+rG93nm9t1m6LdB3YYAqC7g7oIaa8sLQvX1ihxN2BuYQgAQJBAPymjaV5fXesva5pHIR4ZrzhVSCjaNzH2YohhLg7vY+PZ9y144qLf4LjyqywOV6Df9tUAtYuGYDnhzv+/uDkPa0CQQDVKWdvEQUgCKkThYV1S6IIJ4GSbSfBunkQNMo8hvRyb4635lyekIofzoQgdl/oGyV+XlW4g2y9OajcHe1ftpQBAkBC5LZMQcZ+kTYHn7z1Ngu9psurQJjbG+71K7rALNEb2ZReU6pTXGv+c+GNp3sJEzgfEjdODhaikqqzr+g8EzJhAkEAtX0OIuNz4KVfB078pTSjHZw9VuV3Hxvcba70rXod8L0I34zUOPFJmPElT9pZp+5NCv3YsEO9tpK8McWNUJvMAQJAJEsvBNDH/7iH3YdVCXy+WqGHL3e4B9H6MQM6f/hW+C+AdUQ43Bg1dQLHyC+p26cOhPM4hhtGiFP8borqoIyeyw==";
    if ([partner length] == 0 || [seller length] == 0 || [privateKey length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"缺少partner或者seller或者私钥" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    Order *order = [[Order alloc]init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [ZhiFuBaoTool generateTradeNO];
    order.productName = @"测试";
    order.productDescription = @"该物品价值连城";
    order.amount = itemsParce;//价格
    order.notifyURL = @"http://www.neiquan.net:8114/hmsq/payNotice/ali";
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //scheme要与setting中的URLType相同，不然点击取消支付不能回到程序
    NSString *appScheme = @"JsenTestAliPay";
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@,",orderSpec);
    
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec,signedString,@"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"resultu = %@",resultDic);
//            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
//                //支付成功,这里放想要的操作
//                [NetWorkHelp netWorkPayString:[NSString stringWithFormat:@"?orderNo=%@",ReadForLocation(@"orderNo")]         parameters:nil
//                                 SuccessBlock:^(NSDictionary *dic) {
//                                     
//                                 } failBlock:^(NSError *error) {
//                                     
//                                 }];
//                NSString *str = [NSString stringWithFormat:@"%@?orderNo=%@",apiPay,ReadForLocation(@"orderNo")];
//                [NetWorkHelp netWorkPayString:str
//                                   parameters:nil
//                                 SuccessBlock:^(NSDictionary *dic) {
//                                     LogError(@"支付成功=====发送编号成功");
//                                 } failBlock:^(NSError *error) {
//                                     
//                                 }];
                successBlock(resultDic);

//            }else{
//                LogError(@"%@",resultDic);
//            }
        
        }];
        NSLog(@"111111");
    }
}

//生成订单
+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
 

@end

