//
//  MainSearchFinishViewController.m
//  Operator
//
//  Created by 白小田 on 16/10/20.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "MainSearchFinishViewController.h"
#import "SalesjobCell.h"
#import "SalesjobDetailViewController.h"

static NSString *kBxtSalesjobCell = @"SalesjobCell";

@interface MainSearchFinishViewController ()<UITableViewDelegate,UITableViewDataSource>

kBxtPropertyStrong UITableView *myTableview;

@end

@implementation MainSearchFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"搜索结果";
    [self myTableview];
}
-(UITableView *)myTableview
{
    if (!_myTableview) {
        _myTableview = [[UITableView alloc] init];
        _myTableview.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
        _myTableview.delegate = self;
        _myTableview.dataSource = self;
        [self.view addSubview:_myTableview];
    }
    return _myTableview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _response.list.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesjobCell *cell = [tableView dequeueReusableCellWithIdentifier:kBxtSalesjobCell];
    cell.list = _response.list[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MainSearchList *list = _response.list[indexPath.row];
//    SalesjobDetailViewController *job = [[SalesjobDetailViewController alloc] init];
//    [Html5LoadUrl loadUrlWithRelevanceId:list.dataId
//                                    type:list.type
//                            SuccessBlock:^(NSString *url) {
//                                job.kBxtH5Url = url;
//                                job.kBxtTitle = list.title;
//                                [self.navigationController pushViewController:job animated:YES];
//                            } failBlock:^(NSError *error) {
//                                [self showHint:@"连接失败,请检查网络连接"];
//                            }];
    
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
