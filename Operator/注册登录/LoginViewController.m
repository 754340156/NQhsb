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
    self.titleLabel.text = @"登录";
    self.leftBackImage.hidden=YES;
    self.kBxtUserPhone.delegate = self;
    self.kBxtUserPasswd.delegate = self;
    
    [self setUI];
    [self setColorSetting];
   
    [self.kBxtLoginBtn addTarget:self action:@selector(kBxtLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.kBxtReginBtn addTarget:self action:@selector(kBxtReginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.kBxtForgetBtn addTarget:self action:@selector(kBxtReginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setUI
{
    _kBxtUserPhone.leftViewMode = UITextFieldViewModeAlways;
    _kBxtUserPasswd.leftViewMode = UITextFieldViewModeAlways;
    
    [self.kBxtLoginBtn setFrame:CGRectMake(0, HEIGHT/2, WIDTH, 45)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 45)];
    label.text = @"  帐 号:";
    label.textColor = color_333333;
    _kBxtUserPhone.leftView = label;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 45)];
    label1.text = @"  密 码:";
    label1.textColor = color_333333;
    _kBxtUserPasswd.leftView = label1;
}
-(void)setColorSetting
{
    [self.view          setBackgroundColor:BXT_BACKGROUND_COLOR];
    [self.kBxtLoginBtn  setBackgroundColor:KTabBarColor];
    [self.kBxtReginBtn  setTitleColor:KTabBarColor forState:UIControlStateNormal];
    [self.kBxtForgetBtn setTitleColor:KTabBarColor forState:UIControlStateNormal];
}
-(void)kBxtLoginBtnClick
{

    if (_kBxtUserPhone.text && _kBxtUserPasswd.text) {
        if (![NSString judgePassWordLegal:_kBxtUserPasswd.text]) {
            [self showHint:@"请输入正确形式的密码"];
            return;
        }
        [self showHudInView:self.view hint:nil];
        NSDictionary *parameters = @{@"phone":_kBxtUserPhone.text,
                                     @"pushType":@"1",
                                     @"pushtoken":[JPUSHService registrationID] ? [JPUSHService registrationID]:@"",
                                     @"password":_kBxtUserPasswd.text};
        [NetWorkHelp netWorkWithURLString:userlogin
                               parameters:parameters
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
