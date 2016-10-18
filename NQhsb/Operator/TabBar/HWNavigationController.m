//
//  HWNavigationController.m
//  Operator
//
//  Created by NeiQuan on 16/10/13.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWNavigationController.h"

@interface HWNavigationController ()<UIGestureRecognizerDelegate>


@end

@implementation HWNavigationController
+ (void)initialize
{
    //设置导航条的样式
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor whiteColor]];
    [navBar setTintColor:[UIColor whiteColor]];
    [navBar setBackgroundColor:[UIColor whiteColor]];
    navBar.translucent = YES;
    ////设置标题的颜色
    // [navBar  setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:186/255.0 green:187/255.0 blue:188/255.0 alpha:1.0]}];
    [navBar  setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor  blackColor]}];
    
    // 取出导航条item的外观对象(主题对象)
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    //设置默认状态文字的颜色
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:md forState:UIControlStateNormal];
    
    // 设置高亮状态文字的颜色
    NSMutableDictionary *higMd = [NSMutableDictionary dictionary];
    higMd[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:higMd forState:UIControlStateHighlighted];
    
    // 设置不可用状态的颜色
    NSMutableDictionary *disMd = [NSMutableDictionary dictionary];
    disMd[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:disMd forState:UIControlStateDisabled];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;

    // Do any additional setup after loading the view.
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
   
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0)
    {
        UIButton *btn = [UIButton  buttonWithType:UIButtonTypeCustom];
        // 设置对应状态图片
        [btn setImage:[UIImage imageNamed:@"ICON-return"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ICON-return"] forState:UIControlStateHighlighted];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -27, 0, 0)];
        btn.frame = CGRectMake(0, 0, 40, 44);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pop)forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
       
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleDefault;
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark 返回上一层
- (void)pop
{
    [self popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
