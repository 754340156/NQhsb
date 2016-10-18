//
//  LoginViewController.h
//  Operator
//
//  Created by 白小田 on 16/9/13.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : NavViewController
@property (weak, nonatomic) IBOutlet UITextField *kBxtUserPhone;

@property (weak, nonatomic) IBOutlet UITextField *kBxtUserPasswd;

@property (weak, nonatomic) IBOutlet UIButton *kBxtLoginBtn;

@property (weak, nonatomic) IBOutlet UIButton *kBxtForgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *kBxtReginBtn;

@end
