//
//  HWJobLogDetailController.m
//  Operator
//
//  Created by hai on 16/10/25.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWJobLogDetailController.h"
#import "HWJobLogDetailModel.h"
@interface HWJobLogDetailController ()
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
@property (weak, nonatomic) IBOutlet UIButton *kBxtFootSaveBtn;

/**  详情模型 */
@property (nonatomic,strong) HWJobLogDetailModel * model;
@end

@implementation HWJobLogDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"我的工作日志";
    [self setRightButton];
    [self setBorder];
    [self networkGetDetailWithDataId:self.dataId];
}
#pragma mark -  setup
- (void)setRightButton
{
    [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.rightButton setTitle:@"删除" forState:UIControlStateSelected];
    [self.rightButton setTitleColor:KTabBarColor forState:UIControlStateNormal];
    [self.rightButton setTitleColor:KTabBarColor forState:UIControlStateSelected];
    [self.rightButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _kBxtFootSaveBtn.layer.masksToBounds = YES;
    _kBxtFootSaveBtn.layer.cornerRadius  = 3;
}
#pragma mark - target
- (void)editAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        //编辑,变成输入框
        self.titleTF.userInteractionEnabled = YES;
        self.timeTF.userInteractionEnabled = YES;
        self.textField1.userInteractionEnabled = YES;
        self.textField2.userInteractionEnabled = YES;
        self.textField3.userInteractionEnabled = YES;
        self.textField4.userInteractionEnabled = YES;
        self.textField5.userInteractionEnabled = YES;
        self.textField6.userInteractionEnabled = YES;
        self.remarkTV.userInteractionEnabled = YES;
        [self.titleTF becomeFirstResponder];
    }else
    {
        //删除
        [self networkDelegateWithDataId:self.dataId];
    }

}
//保存
- (IBAction)saveAction:(UIButton *)sender
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
    [self networkSaveDetailWithDataId:self.dataId Content1:self.textField1.text Content2:self.textField2.text Content3:self.textField3.text Content4:self.textField4.text Content5:self.textField5.text Content6:self.textField6.text time:self.timeTF.text];
}
#pragma mark - network
- (void)networkGetDetailWithDataId:(NSString *)dataId
{
    MJWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                                 @"dataId":dataId};
    [NetWorkHelp netWorkWithURLString:workLogDetail
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                             if ([dic[@"code"] intValue] == 0) {
                                 weakSelf.model = [HWJobLogDetailModel mj_objectWithKeyValues:dic[@"response"][@"data"]];
                                 [weakSelf updata];
                             }else{
                                 
                                 [weakSelf showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                             [weakSelf showHint:@"网络连接错误"];
                         }];
}
- (void)networkSaveDetailWithDataId:(NSString *)dataId Content1:(NSString *)content1 Content2:(NSString *)content2 Content3:(NSString *)content3 Content4:(NSString *)content4 Content5:(NSString *)content5 Content6:(NSString *)content6 time:(NSString *)time
{
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                                 @"dataId":dataId,
                                 @"content1":content1,
                                 @"content2":content2,
                                 @"content3":content3,
                                 @"content4":content4,
                                 @"content5":content5,
                                 @"content6":content6,
                                 @"time":time,
                                 @"title":self.titleTF.text,
                                 @"remark":self.remarkTV.text};
    [NetWorkHelp netWorkWithURLString:updateWorkLog
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
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
- (void)networkDelegateWithDataId:(NSString *)dataId
{
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                                 @"dataId":dataId};
    [NetWorkHelp netWorkWithURLString:deleteWorkLog
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 [self showHint:@"删除成功"];
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
#pragma mark - private
- (void)updata
{
    self.titleTF.text = self.model.title;
    self.remarkTV.text = self.model.remark;
    self.timeTF.text = self.model.wltime;
    self.textField1.text = self.model.content1;
    self.textField2.text = self.model.content2;
    self.textField3.text = self.model.content3;
    self.textField4.text = self.model.content4;
    self.textField5.text = self.model.content5;
    self.textField6.text = self.model.content6;
}
#pragma mark - lazy
- (HWJobLogDetailModel *)model
{
    if (!_model) {
        _model = [HWJobLogDetailModel new];
    }
    return _model;
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
    [self setBorderWithControl:self.textField1];
    [self setBorderWithControl:self.textField2];
    [self setBorderWithControl:self.textField3];
    [self setBorderWithControl:self.textField4];
    [self setBorderWithControl:self.textField5];
    [self setBorderWithControl:self.textField6];
}
- (void)setBorderWithControl:(UIView *)control
{
    control.layer.borderWidth = 0.5f;
    control.layer.borderColor = [UIColor whiteColor].CGColor;
}
@end
