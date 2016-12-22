//
//  HWAddTextController.m
//  Operator
//
//  Created by hai on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWAddTextController.h"
#import "PlaceholderTextView.h"

@interface HWAddTextController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *remarkTV;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation HWAddTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"添加文本话术";
//    self.backView.layer.shadowOpacity = 0.3;
    self.view.backgroundColor = BXT_BACKGROUND_COLOR;
    [self setRightButton];
}
#pragma mark - setup
- (void)setRightButton
{
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:KTabBarColor forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - target
//保存
- (void)saveAction
{
    if(![self.remarkTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [self showHint:@"文本不能为空"];
        return;
    }
    NSString *str =[self.titleTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self networkAddWordsWithTitle:str remark:self.remarkTV.text];
}
- (void)networkAddWordsWithTitle:(NSString *)title remark:(NSString *)remark
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"wordsType":@"1",
                          @"title":title,
                          @"remark":remark};
    [NetWorkHelp netWorkWithURLString:homePageaddWords
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                             if ([dic[@"code"] intValue] == 0) {
                                 //添加成功
                                 [self showHint:@"添加成功"];
                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                       [self.navigationController popViewControllerAnimated:YES];
                                 });
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                             [self showHint:@"网络连接错误"];
                         }];
}
#pragma mark - UITextFieldDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    kTextViewLineSpacingSet
    textView.typingAttributes = attributes;
}
@end
