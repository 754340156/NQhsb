//
//  EnCodeTool.m
//  StringEncryption
//
//  Created by 袁志浦 on 2016/10/8.
//  Copyright © 2016年 袁志浦. All rights reserved.
//

#import "EnCodeTool.h"
#import "NSString+Coded.h"

@implementation EnCodeTool

+ (NSString *)getSignWithDic:(NSDictionary *)dic{
    
    //1、请求参数的参数名，按照字典排序进 拼接;
    NSArray *array = [dic allKeys];
    NSArray *parameteArray = [array sortedArrayUsingSelector:@selector(compare:)];
    NSString *parameterString = [parameteArray componentsJoinedByString:@""];
    NSLog(@"%@",parameterString);
    
    if (parameterString.length == 0) {
        parameterString = @"";
    }
    
    //2、将第1步的结果与token进行拼接;
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token.length == 0) {
        token = @"token";
    }
    NSString *joinTokenString = [NSString stringWithFormat:@"%@&%@",parameterString,token];
    NSLog(@"%@",joinTokenString);

    //3、将第2步的结果与时间戳进行拼接;
    NSDate *date = [NSDate date];
    NSTimeInterval timeStamp= [date timeIntervalSince1970];
    NSString *joinTimeString = [NSString stringWithFormat:@"%@&%d",joinTokenString,(int)timeStamp];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lld",(long long)timeStamp] forKey:@"PostToServerTime"];
    //4、将第3步的结果进 MD5加密;
    NSString  *MD5String = [joinTimeString MD5Hash];
    NSLog(@"%@",MD5String);
    
    //5、将第4步的结果与双 约定的key进 拼接;(上步结果在前，key在后，中间 &符号连接。)
    NSString *keyString = [NSString stringWithFormat:@"%@&%@",MD5String,@"key"];
    
    //6、将第5步的结果进 MD5加密(即为签名)
    NSString *signString = [keyString MD5Hash];
    
    return signString;
}

@end
