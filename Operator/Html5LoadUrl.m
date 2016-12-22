//
//  Html5LoadUrl.m
//  Operator
//
//  Created by 白小田 on 16/10/17.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "Html5LoadUrl.h"

@implementation Html5LoadUrl
+(void)loadUrlWithRelevanceId:(NSString *)relevanceId type:(NSString *)type SuccessBlock:(void(^)(NSString *url))successBlock failBlock:(void(^)(NSError *error))failBlock
{
    __block NSString *str;
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                   @"token":[UserInfo account].token};
    [NetWorkHelp netWorkWithURLString:H5linkPath
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             str = [NSString stringWithFormat:@"%@?account=%@&relevanceId=%@&type=%@",dic[@"response"][@"linkPath"],[UserInfo account].account,relevanceId,type];
                             successBlock(str);
                         } failBlock:^(NSError *error) {
                             failBlock(error);
                         }];
}
@end
