//
//  HWReSetKeyViewController.m
//  Operator
//
//  Created by NeiQuan on 16/10/13.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWReSetKeyViewController.h"
#import "NetWorkHelp.h"
#import "LoginViewController.h"
#import "HWNavigationController.h"
@interface HWReSetKeyViewController ()
{
    
    __weak IBOutlet UITextField *oldPwdTextField;
    
    __weak IBOutlet UITextField *secondTextFiedl;
    __weak IBOutlet UITextField *newPwdTextField;
}

- (IBAction)makeKeyAction:(id)sender;
@end

@implementation HWReSetKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --提交数据
- (IBAction)makeKeyAction:(id)sender
{
   //一些列正则匹配
    
    if (oldPwdTextField.text.length==0)
    {
        [self showHint:@"请输入原密码"];
        return;
    }else if (newPwdTextField.text.length==0){
        [self showHint:@"请输入新密码"];
        return;

    }else if (secondTextFiedl.text.length==0){
        [self showHint:@"请输入再次输入密码"];
        return;

    }else if (![secondTextFiedl.text isEqualToString:newPwdTextField.text])
    {
        [self showHint:@"两次输入的密码不同"];
        return;
    }
    [self postDataToNet];
    
}
-(void)postDataToNet
{
  NSDictionary  *parameters=@{@"oldPassword":oldPwdTextField.text,@"password":newPwdTextField.text,@"password2":secondTextFiedl.text,@"account":[UserInfo account].account};
   [self showHudInView:self.view hint:nil];
    [NetWorkHelp  netWorkWithURLString:userupdatePassword parameters:parameters SuccessBlock:^(NSDictionary *dic)
    {
        [self hideHud];
        if ([dic[@"code"]integerValue]==0)
        {
            LoginViewController *login = [[LoginViewController alloc] init];
            HWNavigationController *loginNav = [[HWNavigationController alloc] initWithRootViewController:login];
            [MainWindow setRootViewController:loginNav];
            
        }else
        {
            [self showHint:dic[@"errorMessage"]];
            
        }
    } failBlock:^(NSError *error)
    {
        [self hideHud];
        [self showHint:@"网络连接失败"];
    }];
}
@end
