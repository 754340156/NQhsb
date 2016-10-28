//
//  HWHttpManger.m
//  Operator
//
//  Created by NeiQuan on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWHttpManger.h"
#import "HWReChargeModel.h"
#import "HWMusicAnalysicModel.h"
@implementation HWHttpManger

/**
 获取用户的订单
 */
+ (void)getUserordersuccess:(void (^)(id result))success failBlock:(void(^)(NSError*error))failBlock
{
    NSDictionary *parameters=@{@"account":[UserInfo account].account,
                               @"token":[UserInfo account].token};
    [NetWorkHelp  netWorkWithURLString:Userorder parameters:parameters SuccessBlock:^(NSDictionary *dic)
     {
         if (success)
         {
             NSLog(@"%@",dic[@"response"]);
             
             NSLog(@"%@",[HWReChargeModel  mj_objectArrayWithKeyValuesArray:dic[@"response"]]);
          
             success([HWReChargeModel  mj_objectArrayWithKeyValuesArray:dic[@"response"]]);
         }
     } failBlock:^(NSError *error)
     {
         if (failBlock) {
             failBlock(error);
         }
     }];
}
#pragma mark --添加话术本
//[必选]话术本类型1文字2图片3语音
+ (void)AdduserWordsWithType:(NSString *)type content:(NSString *)content title:(NSString *)title remark:(NSString*)remark success:(void (^)(id result))success failBlock:(void(^)(NSError*error))failBlock
{
    NSDictionary *parameters=@{@"account":[UserInfo account].account,
                               @"content":content,
                               @"wordsType":type,
                               @"title":title,
                               @"remark":remark,
                               @"token":[UserInfo account].token};
    [NetWorkHelp  netWorkWithURLString:homePageaddWords parameters:parameters SuccessBlock:^(NSDictionary *dic)
     {
         if (success)
         {
             success(dic);
         }
     } failBlock:^(NSError *error)
     {
         if (failBlock)
         {
             failBlock(error);
         }
     }];
}
#pragma mark --根据模板生成问题分析
+ (void)getquestionListWithIds:(NSString *)ids success:(void (^)(id result))success failBlock:(void(^)(NSError*error))failBlock
{
    
    NSDictionary *parameters=@{@"account":[UserInfo account].account,@"ids":ids,
                               @"token":[UserInfo account].token};
    [NetWorkHelp  netWorkWithURLString:MusicquestionChooselist parameters:parameters SuccessBlock:^(NSDictionary *dic)
     {
         if (success)
         {
             success( [HWMusicquestionListModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"moodule"]]);
         }
     } failBlock:^(NSError *error)
     {
         if (failBlock)
         {
             failBlock(error);
         }
     }];
}
#pragma mark --根据模板id获取题库
+ (void)getquestiondataId:(NSString *)dataid success:(void (^)(id result))success failBlock:(void(^)(NSError*error))failBlock
{
    NSDictionary *parameters=@{@"account":[UserInfo account].account,
                               @"dataId":dataid,
                               @"token":[UserInfo account].token};
    [NetWorkHelp  netWorkWithURLString:MusicquestionBankList parameters:parameters SuccessBlock:^(NSDictionary *dic)
     {
         if (success)
         {
             success( [HWMusicquestionBankModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]]);
         }
     } failBlock:^(NSError *error)
     {
         if (failBlock)
         {
             failBlock(error);
         }
     }];

    
    
}
@end
