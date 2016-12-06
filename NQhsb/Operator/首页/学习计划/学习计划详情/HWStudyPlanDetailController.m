//
//  HWStudyPlanDetailController.m
//  Operator
//
//  Created by hai on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWStudyPlanDetailController.h"
#import "HWStudyPlanDetailModel.h"
#import "HWCollectionModel.h"
#import "CollectionViewCell.h"
#import "SalesjobDetailViewController.h"
@interface HWStudyPlanDetailController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextView *remarkTV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**  整个界面的模型 */
@property (nonatomic,strong) HWStudyPlanDetailModel * detailModel;

@end

@implementation HWStudyPlanDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defaultSetting];
    [self setTableView];
    [self setRightButton];
}
#pragma mark - setup
- (void)defaultSetting
{
    self.dataId == nil ?[self.tableView reloadData] :[self networkGetData];
    self.backView.layer.shadowOpacity = 0.3;
    if (self.kTitle)self.titleLabel.text = self.kTitle;
    else self.titleLabel.text = @"学习计划";
    self.remarkTV.text = @"添加备注";
    self.remarkTV.delegate = self;
    self.remarkTV.textColor = [UIColor colorWithWhite:0.8 alpha:1];
}
- (void)setTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CollectionViewCell class])];
    self.tableView.tableFooterView = [[UIView alloc] init];
}
- (void)setRightButton
{
    [self.rightButton setTitleColor:KTabBarColor forState:UIControlStateNormal];
    [self.rightButton setTitle:self.dataId == nil ? @"保存":@"编辑" forState:UIControlStateNormal];
    if (self.dataId) {
        //编辑
        [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self.rightButton setTitle:@"保存" forState:UIControlStateSelected];
    }else
    {
        //添加
        [self.rightButton setTitle: @"保存" forState:UIControlStateNormal];
    }
    
    [self.rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setupData
{
    self.titleTF.text = self.detailModel.data.title;
    self.remarkTV.text = self.detailModel.data.remark;
    self.titleTF.userInteractionEnabled = NO;
    self.remarkTV.userInteractionEnabled = NO;
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CollectionViewCell class])];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesjobDetailViewController *webVC = [[SalesjobDetailViewController alloc] init];
    HWCollectionModel *model = self.dataArray[indexPath.row];
    [Html5LoadUrl loadUrlWithRelevanceId:model.dataId type:model.type SuccessBlock:^(NSString *url) {
        webVC.kBxtH5Url = url;
        webVC.kBxtTitle = model.title;
        webVC.relevanceId = model.dataId;
        webVC.type = model.type;
        [self.navigationController pushViewController:webVC animated:YES];
    } failBlock:^(NSError *error) {
        [self showHint:kBxtNetWorkError];
    }];
}
#pragma mark - textViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor colorWithWhite:0.23 alpha:1];
    textView.text = nil;
    return YES;
}
#pragma mark - Target
- (void)rightAction:(UIButton *)sender
{
    if (self.dataId) {
        sender.selected = !sender.selected;
        if (!sender.selected) {
            self.titleTF.userInteractionEnabled = NO;
            self.remarkTV.userInteractionEnabled = NO;
            [self networkEditStudyPlanWithDataId:self.dataId title:self.titleTF.text remark:self.remarkTV.text];
        }else
        {

            self.titleTF.userInteractionEnabled = YES;
            self.remarkTV.userInteractionEnabled = YES;
            [self.titleTF becomeFirstResponder];
        }
    }else
    {
        MJWeakSelf;
        //添加并生成学习计划
        NSMutableArray *dataIdArray = [NSMutableArray array];
        for (HWCollectionModel *model in self.dataArray) {
            [dataIdArray addObject:model.dataId];
        }
        [self networkWithDataIdArray:dataIdArray Success:^(NSString *dataId) {
            [weakSelf networkGenerateStudyPlanWithDataId:dataId title:self.titleTF.text remark:self.remarkTV.text];
        }];
    }
}
#pragma mark - network
//展示的时候获取数据
- (void)networkGetData
{
    MJWeakSelf;
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"dataId":self.dataId};
    [NetWorkHelp netWorkWithURLString:studyPlanData
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                  weakSelf.detailModel = [HWStudyPlanDetailModel mj_objectWithKeyValues:dic[@"response"]];
                                 weakSelf.dataArray = [HWCollectionModel mj_objectArrayWithKeyValuesArray:self.detailModel.list];
                                 [weakSelf.tableView reloadData];
                                 [weakSelf setupData];
                             }else
                             {
                                 [weakSelf showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [weakSelf showHint:@"网络连接错误"];
                         }];
}
//添加学习计划
- (void)networkWithDataIdArray:(NSArray <NSString *>*)dataIdArray Success:(void(^)(NSString *dataId))success
{
    MJWeakSelf;
    __block NSMutableString *str;
    [dataIdArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (str) {
            [str appendString:[NSString stringWithFormat:@",%@",obj]];
        }else
        {
            str = obj.mutableCopy;
        }
    }];
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                                 @"content":str};
    [NetWorkHelp netWorkWithURLString:studyPlanAdd
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 success(dic[@"response"][@"studyplanId"]);
                             }else
                             {
                                 [weakSelf showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [weakSelf showHint:@"网络连接错误"];
                         }];
}
//生成学习计划
- (void)networkGenerateStudyPlanWithDataId:(NSString *)dataId title:(NSString *)title remark:(NSString *)remark
{
    MJWeakSelf;
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                                 @"dataId":dataId,
                                 @"title":title,
                                 @"remark":remark};
    [NetWorkHelp netWorkWithURLString:studyPlanGenerate
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 [weakSelf showHint:@"您已成功添加学习任务"];
                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                     [self.navigationController popViewControllerAnimated:YES];
                                 });
                             }else
                             {
                                 [weakSelf showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [weakSelf showHint:@"网络连接错误"];
                         }];
}
//修改学习计划
- (void)networkEditStudyPlanWithDataId:(NSString *)dataId title:(NSString *)title remark:(NSString *)remark
{
    MJWeakSelf;
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                                 @"dataId":dataId,
                                 @"title":title,
                                 @"remark":remark};
    [NetWorkHelp netWorkWithURLString:studyPlanUpdate
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 [weakSelf showHint:@"修改成功"];
                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                     [self.navigationController popViewControllerAnimated:YES];
                                 });
                             }else
                             {
                                 [weakSelf showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [weakSelf showHint:@"网络连接错误"];
                         }];
}
#pragma mark - lazy
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
@end
