//
//  NavViewController.m
//  YunChao
//
//  Created by YuanZhiPu on 15/10/12.
//  Copyright © 2015年 why. All rights reserved.
//

#import "NavViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float width = [UIScreen mainScreen].bounds.size.width;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationController.navigationBar.hidden =YES;
    
    // 导航栏 View
    _navigationBarBackground = [[UIImageView alloc] init];
    _navigationBarBackground.frame = CGRectMake(0, 0, width, 64);
    _navigationBarBackground.backgroundColor = KnavColor;
    _navigationBarBackground.userInteractionEnabled = YES;
    [self.view addSubview:_navigationBarBackground];
    
    // 导航栏中间 title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, width-120, 44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:18.0f];
    _titleLabel.textColor = [UIColor blackColor];
    [_navigationBarBackground addSubview:_titleLabel];

    
    // 创建 左侧 按钮
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(10,30, 55, 30);
    [_leftButton addTarget:self action:@selector(backPrePage) forControlEvents:UIControlEventTouchUpInside];
    _leftButton.adjustsImageWhenHighlighted =NO;
    [_navigationBarBackground addSubview:_leftButton];
    
    _leftBackImage = [[UIImageView alloc] init];
    _leftBackImage.frame = CGRectMake(0, 0, 22, 22);
    _leftBackImage.image = [UIImage imageNamed:@"ICON-return"];
    [_leftButton addSubview:_leftBackImage];
    // 创建 右侧 按钮
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(width-65, 30, 55, 30);
    _rightButton.adjustsImageWhenHighlighted = NO;
    [_navigationBarBackground addSubview:_rightButton];
    
    _rightImage=[[UIImageView alloc]initWithFrame:CGRectMake(33, 2, 22, 22)];
    _rightImage.hidden = YES;
    [_rightButton addSubview:_rightImage];
    
    
    if (self.navigationBarIsHideen ==YES) {
        self.navigationBarBackground.hidden = YES;
    }else{
        self.navigationBarBackground.hidden = NO;
    }
    
    _footerView = [[UIView alloc] init];
    _footerView.frame = CGRectMake(0, _navigationBarBackground.height-1, width, 0.5);
    _footerView.backgroundColor = [UIColor colorWithRed:0.8107 green:0.8064 blue:0.815 alpha:1.0];
    [_navigationBarBackground addSubview:self.footerView];
    //RGBACOLOR
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark - 返回上个页面
- (void)backPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
