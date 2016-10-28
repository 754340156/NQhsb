//
//  HWStudyPlanDetailController.m
//  Operator
//
//  Created by hai on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWStudyPlanDetailController.h"
#import "HWStudyPlanDetailModel.h"
#import "CustomHintView.h"
#import "HWCollectionModel.h"
#import "CollectionViewCell.h"
@interface HWStudyPlanDetailController ()<UITableViewDelegate,UITableViewDataSource,CustomHintViewDelegate>
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
    self.dataId == nil ?[self.tableView reloadData] :[self networkGetData];
    self.backView.layer.shadowOpacity = 0.3;
    [self setTableView];
    [self setRightButton];
}
#pragma mark - setup
- (void)setTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CollectionViewCell class])];
}
- (void)setRightButton
{
    [self.rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.rightButton setTitle:self.dataId == nil ? @"保存":@"删除" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setupData
{
    self.titleTF.text = self.detailModel.data.title;
    self.remarkTV.text = self.detailModel.data.remark;
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
#pragma mark - Target
- (void)rightAction:(UIButton *)sender
{
    if (self.dataId) {
        CustomHintView *hintView = [[CustomHintView alloc] initWithFrame:self.view.frame];
         hintView.titleText = @"确认要删除吗?";
        hintView.delegate = self;
        [self.view addSubview:hintView];
    }else
    {
        MJWeakSelf;
        //添加并生成学习计划
        NSMutableArray *dataIdArray = [NSMutableArray array];
        for (HWCollectionModel *model in self.dataArray) {
            [dataIdArray addObject:model.dataId];
        }
        [self networkWithDataIdArray:dataIdArray Success:^(NSString *dataId) {
            [weakSelf networkGenerateStudyPlanWithDataId:dataId title:self.titleLabel.text remark:self.remarkTV.text];
        }];
    }
}
#pragma mark - CustomHintViewDelegate
- (void)CustomHintViewDelegate_clickSureBtn
{
    [self networkDeleteStudyPlan];
}
- (void)CustomHintViewDelegate_clickCancelBtn
{
    
}
#pragma mark - network
//展示,删除的时候获取数据
- (void)networkGetData
{
    MJWeakSelf;
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"dataId":self.dataId};
    [NetWorkHelp netWorkWithURLString:studyPlanlist
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                  weakSelf.detailModel = [HWStudyPlanDetailModel mj_objectWithKeyValues:dic[@"response"]];
                                 weakSelf.dataArray = self.detailModel.list;
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
//删除学习计划
- (void)networkDeleteStudyPlan
{
    MJWeakSelf;
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                                 @"dataId":self.dataId};
    [NetWorkHelp netWorkWithURLString:studyPlanDelete
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 [weakSelf showHint:@"删除成功"];
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
//添加学习计划
- (void)networkWithDataIdArray:(NSArray <NSString *>*)dataIdArray Success:(void(^)(NSString *dataId))success
{
    MJWeakSelf;
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                                 @"content":dataIdArray};
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
                                 [weakSelf showHint:@"生成学习计划成功"];
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
