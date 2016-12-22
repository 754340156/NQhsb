//
//  NavViewController.h
//  YunChao
//
//  Created by YuanZhiPu on 15/10/12.
//  Copyright © 2015年 why. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavViewController : UIViewController

@property (nonatomic,strong)UIImageView *navigationBarBackground; // navigationBar图片

@property (nonatomic,strong)UIButton *leftButton; // 左侧按钮

@property (nonatomic,strong)UIButton *rightButton; //右侧按钮

@property (nonatomic,strong)UILabel *titleLabel; // 头title

@property (nonatomic,strong)UIImageView *leftBackImage;

@property (nonatomic,strong)UIImageView *rightImage;


@property (nonatomic, assign)BOOL navigationBarIsHideen;

@property (nonatomic,strong)UIView *footerView;


- (void)backPrePage; // 返回上一页


@end
