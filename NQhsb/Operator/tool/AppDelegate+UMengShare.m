//
//  AppDelegate+UMengShare.m
//  Operator
//
//  Created by hai on 16/10/24.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "AppDelegate+UMengShare.h"
#import "UMSocialSinaSSOHandler.h"
@implementation AppDelegate (UMengShare)
- (void)UMengShareSetupWithApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:@"580ddcde734be438db000456"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx5a8faf4ce5c9cac7" appSecret:@"7b6c6f2ae7ea3238c146c72c2c50661e" url:@"http://www.umeng.com/social"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"" appKey:@"" url:@"http://www.umeng.com/social"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@""
                                              secret:@""
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}
@end
