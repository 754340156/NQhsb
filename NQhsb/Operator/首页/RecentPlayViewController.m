//
//  RecentPlayViewController.m
//  Operator
//
//  Created by 白小田 on 16/10/17.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "RecentPlayViewController.h"
#import "SalesjobCell.h"
#import "BigForumModels.h"
#import "SalesjobDetailViewController.h"
static NSString *kBxtSalesjobCell = @"SalesjobCell";

@interface RecentPlayViewController ()<UITableViewDataSource,UITableViewDelegate>
kBxtPropertyStrong UITableView *myTableview;
kBxtPropertyAssign NSInteger pageIndex;
kBxtPropertyAssign NSInteger pageSize;
kBxtPropertyStrong BigForumResponse *bigResponse;
@end

@implementation RecentPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([_api isEqualToString:checklist]) {
        self.titleLabel.text = @"最近播放";
    }else{
        self.titleLabel.text = @"我的录音";
    }
    
    _pageIndex = 1;
    _pageSize  = 9;
    [self myTableview];
}
-(void)netWorkHelp
{
    NSString *wordsType;
    if ([_api isEqualToString:@"/recording/listOfMe.do"]) {
        wordsType = @"5";
    }else{
        wordsType = @"3";
    }
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"type":_selectType,
                          @"wordsType":wordsType,
                          @"pageIndex":GJCFStringFromInt(_pageIndex),
                          @"pageSize":GJCFStringFromInt(_pageSize)};
    [NetWorkHelp netWorkWithURLString:_api
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 _bigResponse = [BigForumResponse mj_objectWithKeyValues:dic[@"response"]];
                                 [self.myTableview reloadData];
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                             [_myTableview.mj_header endRefreshing];
                             [_myTableview.mj_footer endRefreshing];
                         } failBlock:^(NSError *error) {
                             [self showHint:@"网络连接错误"];
                             [_myTableview.mj_header endRefreshing];
                             [_myTableview.mj_footer endRefreshing];
                         }];
}
-(UITableView *)myTableview
{
    if (!_myTableview) {
        _myTableview = [[UITableView alloc] init];
        _myTableview.frame = CGRectMake(0, 64, WIDTH, HEIGHT);
        _myTableview.delegate = self;
        _myTableview.dataSource = self;
        _myTableview.rowHeight = 44;
        _myTableview.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            [self netWorkHelp];
        }];
        _myTableview.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
            _pageIndex = _pageIndex++;
            [self netWorkHelp];
        }];
        [self netWorkHelp];
        [self.view addSubview:_myTableview];
    }
    return _myTableview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _bigResponse.list.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesjobCell *cell = [tableView dequeueReusableCellWithIdentifier:kBxtSalesjobCell];
    cell.list = _bigResponse.list[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BigForumList *list = _bigResponse.list[indexPath.row];
    SalesjobDetailViewController *job = [[SalesjobDetailViewController alloc] init];
    [Html5LoadUrl loadUrlWithRelevanceId:list.dataId
                                    type:list.type
                            SuccessBlock:^(NSString *url) {
                                job.kBxtH5Url = url;
                                job.kBxtTitle = list.title;
                                [self.navigationController pushViewController:job animated:YES];
                            } failBlock:^(NSError *error) {
                                [self showHint:@"连接失败,请检查网络连接"];
                            }];
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
