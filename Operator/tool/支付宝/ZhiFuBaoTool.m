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

+ (void)payForZhiFuBao:(NSString *)itemsName itemsParce:(NSString *)itemsParce orderNum:(NSString *)orderNum SuccessBlock:(void(^)(NSDictionary*dic))successBlock failBlock:(void(^)(NSDictionary *error))failBlock{
    
    NSString *partner = @"2088421878886554";
    NSString *seller = @"2164848677@qq.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOKkOZV0Sb8MuLO0ceAwp8hMxo/Vs8V+s3RLLya878NARGSXzf9jsIOLH1Ovo7jpNRiweM5PCNFTp+RY0WC3XUi4JFZoeN7CRHNAOgvqg8E6jnSNYhlFKic/TIT49VQr9xWDZSGBv7zN8ymidV4SCZlkbfhJQvpwKtTo6fIKhgPXAgMBAAECgYBC9+2/+KWV20d0ajw/14CsUetWMvo0wDR8h36+PpPGKOZMpwKKlUViCSjPjJWfHOHAktyPcZEUcVipw4jSwDvCo6wXtULqRndODTWGogY8bHi/Vjy8kyghAxJAucsueXSGAdE7jw4/3nhGWKXO9Ub41ZU7dQpGviqmkfISpNQcCQJBAPZKukBzw8OYCtvcZZYP+r5gsyeyMjoVPMFTX2cD8d/N85f/1WrZ+pxbBV6/9pnNKd9MJJIdDsmiGrvs9/MFhKUCQQDrkzW9CaVcU9rvJu90QrlmwrEBROQtD3DXbXhFpzD6wO2ydIV482OcPGYxObL+KoIZgmxLPTCqNDeOlLfm5XHLAkBchf4qMFMeq4OIzOcs1Jvx4Qnso7jSsR+90MBKRuUampgkReu61GCdVGRUD/FoHfbY+BXU/i2L+eXpK0CKf0wxAkBvze4zSeCxcRr3ZgM/qmtT2hMoBwpEWI+1rr7mT/NvDyHBEIxIWztraz8VHc1V09brRHshOmleXmn/wZWGgF8BAkEAxz9BJFM4SrMZSzhBUmkmscTANPBDfDOJN8R70ngfpf1pQwVngifGl+LOxyxVEZIPouaOHGAd8PBcnd8YZCdYVA==";
    if ([partner length] == 0 || [seller length] == 0 || [privateKey length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"缺少partner或者seller或者私钥" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    Order *order = [[Order alloc]init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = orderNum;
    order.productName = @"北京泰利玛科技有限公司";
    order.productDescription = @"该物品价值连城";
    order.amount = itemsParce;//价格
    order.notifyURL = @"http://telephone-operator.tunnel.qydev.com/telephone-operator/api/payNotice/ali.do";
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //scheme要与setting中的URLType相同，不然点击取消支付不能回到程序
    NSString *appScheme = @"OperatorAliPay";
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@,",orderSpec);
    
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec,signedString,@"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"resultu = %@",resultDic);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                successBlock(resultDic);
                
            }else{
                failBlock(resultDic);
            }
            
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

