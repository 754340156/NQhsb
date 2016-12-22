//
//  HWJobLogController.m
//  Operator
//
//  Created by hai on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWJobLogController.h"
#import "HWDataStatisticController.h"
#import "HWJobLogDetailController.h"
#import "HWAddJobLogController.h"
#import "HWJobLogCell.h"
#import "HWJobLogModel.h"
static NSInteger pageIndex = 1;
static NSInteger pageSize = 10;
@interface HWJobLogController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
/**  <#注释#> */
@property (weak, nonatomic) IBOutlet UIButton *addLogBtn;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (weak, nonatomic) IBOutlet UIButton *addShujuBtn;
@end

@implementation HWJobLogController
#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = @"工作日志";
    [self setCorner];
    [self setTableView];
    [self setRefresh];
}
#pragma mark - setup
- (void)setCorner
{
    [self.addLogBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(45);
    }];
    
    [self.addShujuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.equalTo(self.addLogBtn.mas_top);
        make.height.offset(45);
    }];
    self.addShujuBtn.layer.masksToBounds = YES;
    self.addShujuBtn.layer.borderWidth = 0.7;
    self.addShujuBtn.titleLabel.textColor = KTabBarColor;
    self.addShujuBtn.layer.borderColor = KTabBarColor.CGColor;
    self.addShujuBtn.layer.cornerRadius = 3;
    [self.addLogBtn setBackgroundColor:KTabBarColor];
}
- (void)setTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-90) style:UITableViewStylePlain];
    _tableView.backgroundColor = BXT_BACKGROUND_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWJobLogCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HWJobLogCell class])];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}
- (void)setRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self network];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self networkMoreData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer.hidden = YES;
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = (self.dataArray.count < pageSize);
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWJobLogCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HWJobLogCell class])];
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWJobLogDetailController *jobLogDetailVC = [[HWJobLogDetailController alloc] init];
    jobLogDetailVC.dataId = [self.dataArray[indexPath.row] dataId];
    [self.navigationController pushViewController:jobLogDetailVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJWeakSelf;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self networkDelegateJobLogWithDataId:[self.dataArray[indexPath.row] dataId] success:^{
            [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView reloadData];
        }];
    }
}
#pragma mark - network
- (void)network
{
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token};
    [NetWorkHelp netWorkWithURLString:workLogList
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 self.dataArray = [HWJobLogModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
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
- (void)networkMoreData
{

    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"pageIndex":@(++pageIndex),
                          @"pageSize":@(pageSize)};
    [NetWorkHelp netWorkWithURLString:workLogList
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 [self.dataArray addObjectsFromArray:[HWJobLogModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]]];
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
- (void)networkDelegateJobLogWithDataId:(NSString *)dataId success:(void(^)())success
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                          @"dataId":dataId};
    [NetWorkHelp netWorkWithURLString:deleteWorkLog
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                             if ([dic[@"code"] intValue] == 0) {
                                 [self showHint:@"删除成功"];
                                 success();
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                             [self showHint:@"网络连接错误"];
                         }];
}
#pragma mark - Action
//数据统计
- (IBAction)dataStatisticAction:(id)sender
{
    HWDataStatisticController *dataStatisticVC = [[HWDataStatisticController alloc] init];
    [Html5LoadUrl loadUrlWithRelevanceId:nil
                                    type:@"6"
                            SuccessBlock:^(NSString *url) {
                                dataStatisticVC.htmlUrl = url;
                                [self.navigationController pushViewController:dataStatisticVC animated:YES];
                            } failBlock:^(NSError *error) {
                              
                            }];
    
}
//添加日志
- (IBAction)addWorkLogAction:(id)sender
{
    HWAddJobLogController *addJobLogVC = [[HWAddJobLogController alloc] init];
    [self.navigationController pushViewController:addJobLogVC animated:YES];
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
