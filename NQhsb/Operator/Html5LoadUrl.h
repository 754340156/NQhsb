//
//  Html5LoadUrl.h
//  Operator
//
//  Created by 白小田 on 16/10/17.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Html5LoadUrl : NSObject
/**
 *  	H5请求
 *
 *  @param relevanceId 详情ID
 *  @param type        类型  1 大讲堂(销售职)  2 大讲堂(管理职)  3 话术本  4 大咖讲话术  5 录音库  6 工作日志  7 录音分析
 *
 *  @return H5链接
 */
+ (void)loadUrlWithRelevanceId:(NSString *)relevanceId type:(NSString *)type SuccessBlock:(void(^)(NSString *url))successBlock failBlock:(void(^)(NSError*error))failBlock;
@end
