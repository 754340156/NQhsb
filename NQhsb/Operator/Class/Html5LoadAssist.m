//
//  Html5LoadAssist.m
//  Operator
//
//  Created by 白小田 on 2016/11/30.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "Html5LoadAssist.h"

@implementation Html5LoadAssist

+(void)html5LoadAssistUrlWithType:(kHtmlType)type SuccessBlock:(void (^)(NSString *))successBlock failBlock:(void (^)(NSError *))failBlock
{
    __block NSString *str;
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                                 @"type":[NSString stringWithFormat:@"%ld",type]};
    [NetWorkHelp netWorkWithURLString:H5HelpUrl
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             str = [NSString stringWithFormat:@"%@%@?&type=%ld",OperatorApi,H5HelpUrl,type];
                             successBlock(str);
                         } failBlock:^(NSError *error) {
                             failBlock(error);
                         }];
}

@end
