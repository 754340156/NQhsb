//
//  HWAddJobLogController.m
//  Operator
//
//  Created by hai on 16/10/19.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWAddJobLogController.h"

@interface HWAddJobLogController ()<UITextFieldDelegate>
#pragma mark - setupControls
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *label8;
#pragma mark - textField
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;
@property (weak, nonatomic) IBOutlet UITextField *textField5;
@property (weak, nonatomic) IBOutlet UITextField *textField6;
/**  备注 */
@property (weak, nonatomic) IBOutlet UITextView *remarkTV;
/**  当前的时间 */
@property (weak, nonatomic) IBOutlet UITextField *timeTF;
/**  日期键盘 */
@property (strong, nonatomic) UIDatePicker *dateKB;
/**  标题 */
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation HWAddJobLogController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"添加日志";
    [self setBorder];
    [self setRightButton];
    [self setTimeTF];
    [self setDateKB];
    [self.titleTF becomeFirstResponder];
}
#pragma mark - setup
- (void)setRightButton
{
    self.backView.layer.shadowOpacity = 0.3;
    [self.rightButton setTitleColor:KTabBarColor forState:UIControlStateNormal];
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setTimeTF
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    self.timeTF.text = dateString;
}
- (void)setDateKB
{
    self.dateKB = [[UIDatePicker alloc] init];
    self.dateKB.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    self.dateKB.datePickerMode = UIDatePickerModeDate;
    //提前一个星期
    self.dateKB.minimumDate = [[NSDate date] initWithTimeIntervalSinceNow:-24*60*60*7];
    self.dateKB.maximumDate = [NSDate date];
    self.timeTF.inputView = self.dateKB;
    [self.dateKB addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
}
#pragma mark - Target
//保存
- (void)saveAction
{
    if(![self.textField1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [self showHint:@"参数不能为空"];
        return;
    }
    if(![self.textField2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [self showHint:@"参数不能为空"];
        return;
    }
    if(![self.textField3.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [self showHint:@"参数不能为空"];
        return;
    }
    if(![self.textField4.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [self showHint:@"参数不能为空"];
        return;
    }
    if(![self.textField5.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [self showHint:@"参数不能为空"];
        return;
    }
    if(![self.textField6.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [self showHint:@"参数不能为空"];
        return;
    }
    if (![self.timeTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [self showHint:@"时间不能为空"];
    }
    [self networkAddJobLogWithContent1:self.textField1.text
                              Content2:self.textField2.text
                              Content3:self.textField3.text
                              Content4:self.textField4.text
                              Content5:self.textField5.text
                              Content6:self.textField6.text
                                  time:self.timeTF.text];
}
- (void)valueChange:(UIDatePicker *)sender
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [fmt stringFromDate:sender.date];
    self.timeTF.text = dateStr;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:self.timeTF]) {
        return NO;
    }
    return YES;
}
#pragma mark - network
- (void)networkAddJobLogWithContent1:(NSString *)content1 Content2:(NSString *)content2 Content3:(NSString *)content3 Content4:(NSString *)content4 Content5:(NSString *)content5 Content6:(NSString *)content6 time:(NSString *)time
{
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                                 @"content1":content1,
                                 @"content2":content2,
                                 @"content3":content3,
                                 @"content4":content4,
                                 @"content5":content5,
                                 @"content6":content6,
                                 @"time":time,
                                 @"title":self.titleTF.text,
                                 @"remark":self.remarkTV.text};
    [NetWorkHelp netWorkWithURLString:addWorkLog
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 //添加日志成功
                                 [self showHint:@"保存成功"];
                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                     [self.navigationController popViewControllerAnimated:YES];
                                 });
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [self showHint:@"网络连接错误"];
                         }];
}
#pragma mark - setupBorder
- (void)setBorder
{
    [self setBorderWithControl:self.label1];
    [self setBorderWithControl:self.label2];
    [self setBorderWithControl:self.label3];
    [self setBorderWithControl:self.label4];
    [self setBorderWithControl:self.label5];
    [self setBorderWithControl:self.label6];
    [self setBorderWithControl:self.label7];
    [self setBorderWithControl:self.label8];
    [self setKetBordType:self.textField1];
    [self setKetBordType:self.textField2];
    [self setKetBordType:self.textField3];
    [self setKetBordType:self.textField4];
    [self setKetBordType:self.textField5];
    [self setKetBordType:self.textField6];
}
- (void)setBorderWithControl:(UIView *)control
{
    control.layer.borderWidth = 0.5f;
    control.layer.borderColor = [UIColor whiteColor].CGColor;
}
- (void)setKetBordType:(UITextField *)textFiled
{
    textFiled.layer.borderWidth = 0.5f;
    textFiled.layer.borderColor = [UIColor whiteColor].CGColor;
    textFiled.keyboardType = UIKeyboardTypeNumberPad;
}
@end
