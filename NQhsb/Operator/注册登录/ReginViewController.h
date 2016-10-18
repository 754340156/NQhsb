//
//  ReginViewController.h
//  Operator
//
//  Created by 白小田 on 16/9/13.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReginViewController : NavViewController
@property (weak, nonatomic) IBOutlet UIButton *kBxtAuthCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *kBxtAutoCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *kBxtPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *kBxtAuthTF;
@property (weak, nonatomic) IBOutlet UITextField *kBxtPasswdTF;
@property (weak, nonatomic) IBOutlet UITextField *kBxtAffirmTF;

@property (weak, nonatomic) IBOutlet UIButton *kBxtReginBtn;

/**
 *  1. 忘记密码   2. 注册   （必传）
 */
@property (strong,nonatomic) NSString *selectType;
@end
