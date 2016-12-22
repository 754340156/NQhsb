//
//  Html5LoadAssist.h
//  Operator
//
//  Created by 白小田 on 2016/11/30.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,kHtmlType){
    kHtmlTypeStateHelp = 1,   //关于我们
    kHtmlTypeStateAboutUs,    //使用帮助
    kHtmlTypeStateFaq,        //常见问题
    kHtmlTypeStateIntegral,   //积分说明
    kHtmlTypeStateManage,     //管理职说明
};

@interface Html5LoadAssist : NSObject

+ (void)html5LoadAssistUrlWithType:(kHtmlType)type SuccessBlock:(void(^)(NSString *url))successBlock failBlock:(void(^)(NSError *error))failBlock;

@end
