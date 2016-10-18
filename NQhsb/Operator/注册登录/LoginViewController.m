//
//  LoginViewController.m
//  Operator
//
//  Created by 白小田 on 16/9/13.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "LoginViewController.h"
#import "ReginViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"登陆";
    self.leftBackImage.hidden=YES;
    self.view.backgroundColor = BXT_BACKGROUND_COLOR;
    self.kBxtUserPhone.delegate = self;
    self.kBxtUserPasswd.delegate = self;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 45)];
    label.text = @"帐 号:";
    label.textColor = [UIColor blackColor];
    [self.kBxtUserPhone addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 45)];
    label1.text = @"密 码:";
    label1.textColor = [UIColor blackColor];
    [self.kBxtUserPasswd addSubview:label1];
    
    [self.kBxtLoginBtn addTarget:self action:@selector(kBxtLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.kBxtReginBtn addTarget:self action:@selector(kBxtReginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.kBxtForgetBtn addTarget:self action:@selector(kBxtReginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)kBxtLoginBtnClick
{
    [self showHudInView:self.view hint:nil];
    if (_kBxtUserPhone.text && _kBxtUserPasswd.text) {
        NSDictionary *dic = @{@"phone":_kBxtUserPhone.text,
                              @"pushType":@"1",
                              @"pushtoken":@"1",
                              @"password":_kBxtUserPasswd.text};
        [NetWorkHelp netWorkWithURLString:userlogin
                               parameters:dic
                             SuccessBlock:^(NSDictionary *dic) {
                                 if ([dic[@"code"] intValue] == 0) {
                                     
                                     XBAccessLoginTokenResult *result = [XBAccessLoginTokenResult mj_objectWithKeyValues:dic[@"response"][@"user"]];
                                     [UserInfo saveAccount:result];
                                     [Tool mainView:YES];
                                     
                                 }else{
                                     [self showHint:dic[@"errorMessage"]];
                                 }
                                 [self hideHud];
                             } failBlock:^(NSError *error) {
                                 [self showHint:@"网络连接失败"];
                                 [self hideHud];
                             }];
    }else{
        [self showHint:@"用户名与密码为必填"];
        [self hideHud];
    }
    
}

-(void)kBxtReginBtnClick:(UIButton *)btn
{
    ReginViewController *regin = [[ReginViewController alloc] init];
    regin.selectType = [NSString stringWithFormat:@"%ld",btn.tag-99];
    [self.navigationController pushViewController:regin animated:YES];
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
