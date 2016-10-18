//
//  NetWorkHelp.m
//  Thousands Of Donkey
//
//  Created by a on 15/7/23.
//  Copyright (c) 2015年 NeiQuan. All rights reserved.
//

#import "NetWorkHelp.h"

@implementation NetWorkHelp
//POST请求
+ (void)netWorkWithURLString:(NSString *)urlString parameters:(NSDictionary*)parameters SuccessBlock:(void(^)(NSDictionary*dic))successBlock failBlock:(void(^)(NSError*error))failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer =  [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *encodingString = [OperatorApi stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *apiString = [NSString stringWithFormat:@"%@%@",encodingString,urlString];
    
    [manager POST:apiString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        successBlock(dictionary);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LogError(@"Error: %@", error.description);
        failBlock(error);
    }];
}
+(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
//文件的上传
+ (void)upLoadWithURLString:(NSString *)urlString parameters:(NSDictionary*)parameters data:(YZPData *)data SuccessBlock:(void(^)(NSDictionary*dic))successBlock failBlock:(void(^)(NSError*error))failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *encodingString = [OperatorApi stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",encodingString,urlString];
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> fromData) {
    [fromData appendPartWithFileData:data.data name:data.name fileName:data.fileName mimeType:data.mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        successBlock(dictionary);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LogError(@"Error: %@", error.description);
        failBlock(error);
    }];
}
+ (void)getWorkReachability{
    
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
            {
                NSLog(@"未知网络");
            }
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            {
                NSLog(@"没有网络(断网)");
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
            {
                NSLog(@"手机自带网络");
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
            {
                NSLog(@"WIFI");
            }
                break;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
}

+ (void)netWorkGETWithURLString:(NSString *)urlString SuccessBlock:(void(^)(NSDictionary*dic))successBlock failBlock:(void(^)(NSError*error))failBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *encodingString = [OperatorApi stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",encodingString,urlString];

    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        successBlock(dictionary);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
    
}


+ (void)POSTWithUrl:(NSString *)url parameters:(NSString *)parameters SuccessBlock:(void(^)(NSDictionary*dic))successBlock{
    
    NSString *encodingString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodingString]];
    
    //将字符串转化为data
    NSData *dataParameters = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    //将data放入请求体中

    [mutableURLRequest setHTTPBody:dataParameters];
    //设置请求方法
    [mutableURLRequest setHTTPMethod:@"POST"];
    
    //同步连接 一次性返回所有数据 如果数据量大 会造成主线程阻塞 主线程UI线程 卡
    NSData *data = [NSURLConnection sendSynchronousRequest:mutableURLRequest returningResponse:nil error:nil];
    //        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    successBlock(dic);
}


@end
