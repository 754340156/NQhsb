//
//  HWOperationShowController.m
//  Operator
//
//  Created by hai on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWOperationShowController.h"
#import "HWOperationCell.h"
#import "HWOperationModel.h"
#import "SalesjobDetailViewController.h"
static NSInteger pageIndex = 1;
static NSInteger pageSize = 10;
@interface HWOperationShowController ()<UITableViewDataSource,UITableViewDelegate>
/**  <#注释#> */
@property (nonatomic,strong) UITableView * tableView;
/**   */
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation HWOperationShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.titleText;
    [self setTableView];
    [self setRefresh];
}
#pragma mark - setup
- (void)setTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT -64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView  = [[UIView alloc] init];
    self.tableView.backgroundColor = BXT_BACKGROUND_COLOR;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWOperationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HWOperationCell class])];
}
- (void)setRefresh
{
    MJWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataWithType:self.selectType];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreDataWithType:self.selectType];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer.hidden = YES;
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = (self.dataArray.count < pageSize);
    return  self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HWOperationCell class])];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesjobDetailViewController *publicWebVC = [[SalesjobDetailViewController alloc] init];
    HWOperationModel *model = self.dataArray[indexPath.row];
    [Html5LoadUrl loadUrlWithRelevanceId:model.dataId type:self.selectType SuccessBlock:^(NSString *url) {
        publicWebVC.kBxtH5Url = url;
        publicWebVC.kBxtTitle = model.title;
        publicWebVC.type = self.selectType;
        publicWebVC.relevanceId = model.dataId;
        [self.navigationController pushViewController:publicWebVC animated:YES];
    } failBlock:^(NSError *error) {
        [self showHint:kBxtNetWorkError];
    }];
}
#pragma mark - network
- (void)getDataWithType:(NSString *)type
{
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                                 @"type":type};
    [NetWorkHelp netWorkWithURLString:self.apiStr
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 self.dataArray = [HWOperationModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
                                 [self.tableView reloadData];
                             }else{
                                 
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
- (void)getMoreDataWithType:(NSString *)type
{
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                                 @"type":type,
                                 @"pageIndex":@(++pageIndex),
                                 @"pageSize":@(pageSize)};
    [NetWorkHelp netWorkWithURLString:self.apiStr
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 [self.dataArray addObjectsFromArray:[HWOperationModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]]];
                                 if ( [dic[@"response"][@"count"] integerValue] < pageSize) {
                                     [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                     return;
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
