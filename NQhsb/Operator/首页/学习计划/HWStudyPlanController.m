//
//  HWStudyPlanController.m
//  Operator
//
//  Created by hai on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWStudyPlanController.h"
#import "HWAddStudyPlanController.h"
#import "HWStudyPlanDetailController.h"
#import "HWStudyPlanModel.h"
static NSInteger pageIndex = 1;
static NSInteger pageSize = 10;
@interface HWStudyPlanController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addPlanBtn;
/**  <#注释#> */
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation HWStudyPlanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"学习计划";
    [self setRefresh];
    [self setCorner];
}
#pragma mark - setup
- (void)setRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self networkHelp];
    }];
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [self networkMoreDataHelp];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer.hidden = YES;
}
- (void)setCorner
{
    self.addPlanBtn.layer.masksToBounds = YES;
    self.addPlanBtn.layer.cornerRadius = 4;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = (self.dataArray.count < pageSize);
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = [self.dataArray[indexPath.row] title];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWStudyPlanDetailController *detailVC =[[HWStudyPlanDetailController alloc] init];
    detailVC.dataId = [self.dataArray[indexPath.row] dataId];
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - Action
- (IBAction)addPlanAction:(id)sender
{
    HWAddStudyPlanController *addStudyPlanVC = [[HWAddStudyPlanController alloc] init];
    [self.navigationController pushViewController:addStudyPlanVC animated:YES];
}
#pragma mark - network
- (void)networkHelp
{
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token};
    [NetWorkHelp netWorkWithURLString:studyPlanlist
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 self.dataArray = [HWStudyPlanModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
                                 [self.tableView reloadData];
                             }else
                             {
                                 [self showHint:dic[@"errorMessage"]];
                             }
                             [self.tableView.mj_footer endRefreshing];
                             [self.tableView.mj_header endRefreshing];
                         } failBlock:^(NSError *error) {
                             [self.tableView.mj_footer endRefreshing];
                             [self.tableView.mj_header endRefreshing];
                             [self showHint:@"网络连接错误"];
                         }];
}
- (void)networkMoreDataHelp
{
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                                 @"pageIndex":@(++pageIndex),
                                 @"pageSize":@(pageSize)};
    [NetWorkHelp netWorkWithURLString:studyPlanlist
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 [self.dataArray addObjectsFromArray:[HWStudyPlanModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]]];
                                 if ( [dic[@"response"][@"count"] integerValue] < pageSize) {
                                     [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                     return ;
                                 }
                                 [self.tableView reloadData];
                             }else{
                                 pageIndex--;
                                 [self showHint:dic[@"errorMessage"]];
                             }
                             [self.tableView.mj_footer endRefreshing];
                             [self.tableView.mj_header endRefreshing];
                         } failBlock:^(NSError *error) {
                             pageIndex--;
                             [self.tableView.mj_footer endRefreshing];
                             [self.tableView.mj_header endRefreshing];
                             [self showHint:@"网络连接错误"];
                         }];
}
#pragma mark - lazy
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
