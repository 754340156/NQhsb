//
//  AppDelegate+UMengShare.m
//  Operator
//
//  Created by hai on 16/10/24.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "AppDelegate+UMengShare.h"
#import <UMSocialCore/UMSocialCore.h>

@implementation AppDelegate (UMengShare)
- (void)UMengShareSetupWithApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"580ddcde734be438db000456"];
    
    //设置微信聊天的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx5a8faf4ce5c9cac7" appSecret:@"7b6c6f2ae7ea3238c146c72c2c50661e"  redirectURL:@"http://mobile.umeng.com/social"];
    //设置微信朋友圈的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:@"wx5a8faf4ce5c9cac7" appSecret:@"7b6c6f2ae7ea3238c146c72c2c50661e" redirectURL:@"http://mobile.umeng.com/social"];
    //设置qq聊天的appID和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105713569" appSecret:@"XrNa9K8MRJ0vLatz" redirectURL:@"http://mobile.umeng.com/social"];
    //设置qq空间聊天的appID和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Qzone appKey:@"1105713569" appSecret:@"XrNa9K8MRJ0vLatz" redirectURL:@"http://mobile.umeng.com/social"];
}
@end
