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
/**  <#注释#> */
@property(nonatomic,strong) NSMutableArray * dataArray;
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
                                 self.dataArray = _bigResponse.list.mutableCopy;
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
- (void)networkDeleteWithDataId:(NSString *)dataId
{
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                                 @"type":@"5",
                                 @"dataId":dataId};
    [NetWorkHelp netWorkWithURLString:recordingdelete
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 LogApi(@"删除成功");
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                                 DLog(@"删除失败 %@",dic[@"errorMessage"]);
                             }
                         } failBlock:^(NSError *error) {
                             [self showHint:@"网络连接失败"];
                         }];
}
-(UITableView *)myTableview
{
    if (!_myTableview) {
        _myTableview = [[UITableView alloc] init];
        _myTableview.frame = CGRectMake(0, 64, WIDTH, HEIGHT);
        _myTableview.delegate = self;
        _myTableview.dataSource = self;
        _myTableview.rowHeight = 105;
        [_myTableview registerNib:[UINib nibWithNibName:@"SalesjobCell" bundle:nil] forCellReuseIdentifier:kBxtSalesjobCell];
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
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesjobCell *cell = [tableView dequeueReusableCellWithIdentifier:kBxtSalesjobCell];
    cell.list = self.dataArray[indexPath.row];
    //给cell加长按手势
//    UILongPressGestureRecognizer *gestureLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(gestureLongPress:)];
    //    gestureLongPress.minimumPressDuration =1;
//    [cell.contentView addGestureRecognizer:gestureLongPress];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BigForumList *list = self.dataArray[indexPath.row];
    SalesjobDetailViewController *job = [[SalesjobDetailViewController alloc] init];
    [Html5LoadUrl loadUrlWithRelevanceId:list.dataId
                                    type:list.type
                            SuccessBlock:^(NSString *url) {
                                job.kBxtH5Url = url;
                                job.kBxtTitle = list.title;
                                job.relevanceId = list.dataId;
                                job.type = list.type;
                                job.isNotShare = [_api isEqualToString:checklist];
                                [self.navigationController pushViewController:job animated:YES];
                            } failBlock:^(NSError *error) {
                                [self showHint:kBxtNetWorkError];
                            }];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isMyAudio) {
        return YES;
    }
    return  NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [self networkDeleteWithDataId:[self.dataArray[indexPath.row] dataId]];
        [self.dataArray removeObjectAtIndex:indexPath.row] ;
        //        删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView setEditing:NO animated:YES];
    }
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
