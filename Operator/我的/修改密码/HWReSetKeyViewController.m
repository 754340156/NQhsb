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

static NSString *kTitle = @"修改密码";

@interface HWReSetKeyViewController ()
{
    
    __weak IBOutlet UITextField *oldPwdTextField;
    
    __weak IBOutlet UITextField *secondTextFiedl;
    __weak IBOutlet UITextField *newPwdTextField;
}
@property (weak, nonatomic) IBOutlet UIButton *kFinishBtn;

- (IBAction)makeKeyAction:(id)sender;
@end

@implementation HWReSetKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.titleLabel setText:kTitle];
    [self setWithFrameAndColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setWithFrameAndColor
{
    [self.view setBackgroundColor:BXT_BACKGROUND_COLOR];
    [self.kFinishBtn setBackgroundColor:KTabBarColor];
    [self.oneView setFrame:CGRectMake(0, 64, WIDTH, 44)];
    [self.twoView setFrame:CGRectMake(0, self.oneView.bottom, WIDTH, 44)];
    [self.threeView setFrame:CGRectMake(0, self.twoView.bottom, WIDTH, 44)];
    [self.kFinishBtn setFrame:CGRectMake(0, HEIGHT/2, WIDTH, 45)];
    [self.oneView addSubview:[self footViewWithaddView:self.oneView]];
    [self.twoView addSubview:[self footViewWithaddView:self.twoView]];
    [self.threeView addSubview:[self footViewWithaddView:self.threeView]];
}
-(UIView *)footViewWithaddView:(UIView *)addView
{
    UIView *footView = [[UIView alloc] init];
    footView.frame = CGRectMake(0, addView.height-0.5, WIDTH, 0.5);
    footView.backgroundColor = BXT_BACKGROUND_COLOR;
    return footView;
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
  NSDictionary  *parameters=@{@"oldPassword":oldPwdTextField.text,@"password":newPwdTextField.text,@"password2":secondTextFiedl.text,@"account":[UserInfo account].account,@"token":[UserInfo account].token};
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
