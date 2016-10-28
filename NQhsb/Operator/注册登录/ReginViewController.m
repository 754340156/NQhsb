//
//  ReginViewController.m
//  Operator
//
//  Created by 白小田 on 16/9/13.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "ReginViewController.h"

@interface ReginViewController ()<UITextFieldDelegate>

@end

@implementation ReginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = [self navTitle];
    self.kBxtAuthTF.delegate = self;
    self.kBxtPhoneTF.delegate = self;
    self.kBxtPasswdTF.delegate = self;
    self.kBxtAffirmTF.delegate = self;
    [self setTextFieldLeftPadding:_kBxtPhoneTF forWidth:15];
    [self setTextFieldLeftPadding:_kBxtAuthTF forWidth:15];
    [self setTextFieldLeftPadding:_kBxtPasswdTF forWidth:15];
    [self setTextFieldLeftPadding:_kBxtAffirmTF forWidth:15];
    self.view.backgroundColor = BXT_BACKGROUND_COLOR;
    [self.kBxtAuthCodeBtn addTarget:self action:@selector(kBxtAuthCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.kBxtReginBtn addTarget:self action:@selector(kBxtReginBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(NSString *)navTitle
{
    NSString *title;
    if ([_selectType isEqualToString:@"1"]) {
        title = @"忘记密码";
    }else{
        title = @"注册";
    }
    return title;
}
-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}
-(void)kBxtAuthCodeBtn:(id)sender
{
    if (!GJCFStringIsMobilePhone(self.kBxtPhoneTF.text)) {
        [self showHint:@"不是合法的手机号码"];
    }else{
        [self time:sender];
        [self pushAuthCode];
    }
}

-(void)pushAuthCode
{
    NSDictionary *parameters = @{@"phone":self.kBxtPhoneTF.text};
    [NetWorkHelp netWorkWithURLString:pushCode
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 LogApi(@"发送验证码成功 －－ %@",dic);
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [self showHint:@"网络连接错误"];
                         }];
}
-(NSString *)reginNetWorkPhone:(NSString *)phone verCode:(NSString *)verCode password:(NSString *)password
{
    
    __block NSString *str;
    NSDictionary *parameters = @{@"phone":phone,
                          @"pushType":@"1",
                          @"verCode":verCode,
                          @"pushtoken":@"1",
                          @"password":password};
    [NetWorkHelp netWorkWithURLString:Register
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 str = @"注册成功";
                                 [self showHint:@"注册成功"];
                                 [self.navigationController popViewControllerAnimated:YES];
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                                 str = dic[@"errorMessage"];
                             }
                         } failBlock:^(NSError *error) {
                             str = @"网络连接错误";
                         }];
    return str;
    
}
-(void)kBxtReginBtnClick
{
    if (GJCFStringIsMobilePhone(self.kBxtPhoneTF.text) && self.kBxtAuthTF.text) {
        
        if ([_kBxtPasswdTF.text isEqualToString:_kBxtAffirmTF.text]) {
            
                  [self reginNetWorkPhone:_kBxtPhoneTF.text
                                  verCode:_kBxtAuthTF.text
                                 password:_kBxtPasswdTF.text];
        }
        
    }else{
        
        [self showHint:@"请填写完整"];
        
    }
}
#pragma  mark - 发送验证码时间设置
- (void)time:(UIButton *)l_timeButton{
    
    __block int timeout= 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                l_timeButton.userInteractionEnabled = YES;
                self.kBxtAutoCodeLabel.text = @"重新发送";
                
            });
        }else{
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.kBxtAutoCodeLabel.text = [NSString stringWithFormat:@"(%@ s)",strTime];
                l_timeButton.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
