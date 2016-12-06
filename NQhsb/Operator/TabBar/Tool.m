//
//  Tool.m
//  KCB
//
//  Created by YuanZhiPu on 15/8/26.
//  Copyright (c) 2015年 NeiQuan. All rights reserved.
//

#import "Tool.h"
#import "MainViewController.h"
#import "CollectionViewController.h"
#import "HelpViewController.h"
#import "MyStyleViewController.h"
#import "UIImage+ZP.h"
#import "HWNavigationController.h"
@implementation Tool

+ (void)mainView:(BOOL)isMain{
    
    if (isMain == NO) {
        
    }else{
        
        //主页
        MainViewController *homeVc = [[MainViewController alloc] init];
        HWNavigationController *homeNav = [[HWNavigationController alloc] initWithRootViewController:homeVc];
        homeNav.tabBarItem.image = [[UIImage imageNamed:@"Home_ICON_Unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"Home_ICON_Select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        homeNav.tabBarItem.title = @"主页";
        [homeNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        [homeNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:KTabBarColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];


        //收藏
        CollectionViewController *CollectionVC = [[CollectionViewController alloc] init];
        HWNavigationController *CollectionNav = [[HWNavigationController alloc] initWithRootViewController:CollectionVC];
        CollectionNav.tabBarItem.image = [[UIImage imageNamed:@"Collect_ICON_Unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        CollectionNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"Collect_ICON_Select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        CollectionNav.tabBarItem.title = @"收藏";
        [CollectionNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        [CollectionNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:KTabBarColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
        
        //帮助
        HelpViewController *HelpViewC = [[HelpViewController alloc] init];
        
        HWNavigationController * HelpViewNav = [[HWNavigationController alloc] initWithRootViewController:HelpViewC];
        HelpViewNav.tabBarItem.image = [[UIImage imageNamed:@"HELP_ICON_Unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        HelpViewNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"HELP__ICON_Select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        HelpViewNav.tabBarItem.title = @"帮助";
        [HelpViewNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        [HelpViewNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:KTabBarColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
        //我的
        MyStyleViewController *MyStyleVC = [[MyStyleViewController alloc] init];
        
        HWNavigationController * MyStyleNav = [[HWNavigationController alloc] initWithRootViewController:MyStyleVC];
        MyStyleNav.tabBarItem.image = [[UIImage imageNamed:@"MINE_ICON_Unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        MyStyleNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"MINE_ICON_Select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        MyStyleNav.tabBarItem.title = @"我的";
        [MyStyleNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        [MyStyleNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:KTabBarColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
        
        NSArray *viewArr = @[homeNav,CollectionNav,HelpViewNav,MyStyleNav];
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        tabBarController.tabBar.backgroundColor=[UIColor colorWithRed:0.9037 green:0.899 blue:0.9085 alpha:1.0];
        tabBarController.viewControllers = viewArr;
        tabBarController.tabBar.backgroundImage=[UIImage createImageWithColor:[UIColor whiteColor]];
        tabBarController.selectedIndex = 0;
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(0, 0, WIDTH, 0.5);
        view.backgroundColor=[UIColor whiteColor];
        [tabBarController.tabBar addSubview:view];
        [MainWindow setRootViewController:tabBarController];
    
        
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end
