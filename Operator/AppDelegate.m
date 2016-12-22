//
//  AppDelegate.m
//  Operator
//
//  Created by 白小田 on 16/9/12.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HWNavigationController.h"
#import "WXApi.h"
#import "AppDelegate+UMengShare.h"
#import "AppDelegate+JPush.h"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    // Override point for customization after application launch.
    if ([UserInfo account].account) {
        [Tool mainView:YES];
    }else{
        LoginViewController *login = [[LoginViewController alloc] init];
        HWNavigationController *loginNav = [[HWNavigationController alloc] initWithRootViewController:login];
        [MainWindow setRootViewController:loginNav];
    }
    [WXApi registerApp:@"wx5a8faf4ce5c9cac7" withDescription:@"话务员"];
    
    //友盟分享设置
    [self UMengShareSetupWithApplication:application didFinishLaunchingWithOptions:launchOptions];
    [self JpushApplication:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark --微信支付
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        [[UIApplication sharedApplication].keyWindow.rootViewController showHint:@"支付成功"];
    }];
    return [WXApi handleOpenURL:url delegate:self];
    
}
#pragma mark --微信支付回调
-(void)onResp:(BaseResp *)resp{
    NSString *strTitle;
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        strTitle = [NSString stringWithFormat:@"支付结果"];
        NSDictionary *dic;
        if(resp.errStr){
            dic = @{@"errCode":[NSString stringWithFormat:@"%d",resp.errCode],
                    @"errStr":resp.errStr};
        }else{
            dic = @{@"errCode":[NSString stringWithFormat:@"%d",resp.errCode]};
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXsuccess" object:dic];
        NSLog(@"发送成功");
    }
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 1.取消当前下载
    [[SDWebImageManager sharedManager] cancelAll];
    // 2.清空内存缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

@end
