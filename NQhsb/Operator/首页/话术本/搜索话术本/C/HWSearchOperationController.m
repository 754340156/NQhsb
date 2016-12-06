//
//  HWSearchOperationController.m
//  Operator
//
//  Created by hai on 16/10/20.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWSearchOperationController.h"
#import "SalesjobDetailViewController.h"
#import "HWOperationModel.h"
#import "HWOperationCell.h"
#import "HWHotSearchCell.h"
#import "HWHotSearchFlowLayout.h"
static NSInteger pageIndex = 1;
static NSInteger pageSize = 10;
@interface HWSearchOperationController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,HWHotSearchCellDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
#warning 高度没有动态修改
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewH;
/**  搜索出来的数据 */
@property (nonatomic,strong) NSMutableArray * searchDataA;
/**  热门搜索的数据  */
@property (nonatomic,strong) NSMutableArray * hotSeaDataA;
/**  记录当前搜索的关键字 */
@property (nonatomic,strong) NSMutableDictionary * keywordDic;
@end

@implementation HWSearchOperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableViewAndCollectionView];
    [self setRefresh];
    [self networkHotSearch];
}
#pragma mark - setup
- (void)setTableViewAndCollectionView
{
    [self.collectionView setCollectionViewLayout:[[HWHotSearchFlowLayout alloc]init]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWOperationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HWOperationCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HWHotSearchCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HWHotSearchCell class])];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionElementKindSectionHeader class])];
    self.collectionView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = BXT_BACKGROUND_COLOR;
}
- (void)setRefresh
{
    self.tableView.mj_footer  = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self networkSearchMoreData];
    }];
    self.tableView.mj_footer.hidden = YES;
}
#pragma mark - UITableViewDelegate
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = (self.searchDataA.count < pageSize);
    return self.searchDataA.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWOperationCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HWOperationCell class])];
    cell.model = self.searchDataA[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesjobDetailViewController *publicWebVC = [[SalesjobDetailViewController alloc] init];
    HWOperationModel *model = self.searchDataA[indexPath.row];
    [Html5LoadUrl loadUrlWithRelevanceId:model.dataId type:self.type SuccessBlock:^(NSString *url) {
        publicWebVC.kBxtH5Url = url;
        publicWebVC.kBxtTitle = model.title;
        publicWebVC.type = self.type;
        publicWebVC.relevanceId = model.dataId;
        [self.navigationController pushViewController:publicWebVC animated:YES];
    } failBlock:^(NSError *error) {
        [self showHint:kBxtNetWorkError];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
}
#pragma mark - UICollectionViewDeleagte
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.hotSeaDataA.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HWHotSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HWHotSearchCell class]) forIndexPath:indexPath];
    cell.titleText = self.hotSeaDataA[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionElementKindSectionHeader class]) forIndexPath:indexPath];
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,-10,WIDTH , 20)];
        headerLabel.text = @"热门搜索";
        headerLabel.font = [UIFont systemFontOfSize:15];
        [reusableView addSubview:headerLabel];
    }
    return reusableView;
    
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hotSeaDataA.count > 0) {
        return [HWHotSearchCell getSizeWithText:self.hotSeaDataA[indexPath.row]];
    }
    return CGSizeMake(80, 24);
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //点击关键字去搜索
    [self networkSearchWithKeyword:searchBar.text hotLabel:nil];
    [searchBar resignFirstResponder];
}
#pragma mark - HWHotSearchCellDelegate
- (void)HWHotSearchCellDelegate_ClickTitleText:(NSString *)titleText
{
    //热门标签去搜索
    [self networkSearchWithKeyword:nil hotLabel:titleText];
    [self.searchBar resignFirstResponder];
}
#pragma mark - network
//热门搜索
- (void)networkHotSearch
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"type":self.type};
    [NetWorkHelp netWorkWithURLString:hotSearch
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                             if ([dic[@"code"] intValue] == 0) {
                                 for (NSDictionary *dictionary in dic[@"response"]) {
                                     [self.hotSeaDataA addObject: dictionary[@"title"]];
                                 }
                                 [self.collectionView reloadData];
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                             [self showHint:@"网络连接错误"];
                         }];
    
}
//搜索请求
- (void)networkSearchWithKeyword:(NSString *)keyword hotLabel:(NSString *)hotLabel
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[UserInfo account].account forKey:@"account"];
    [parameters setObject:[UserInfo account].token forKey:@"token"];
    [parameters setObject:self.type forKey:@"type"];
    keyword ? [parameters setObject:keyword forKey:@"keyword"]:[parameters setObject:hotLabel forKey:@"label"];
    self.keywordDic = parameters.mutableCopy;
    [NetWorkHelp netWorkWithURLString:recordinglist
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 self.searchDataA = [HWOperationModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
                                 if (!self.searchDataA.count) {
                                     [self showHint:@"没有搜到更多结果"];
                                 }
                                 [self.tableView reloadData];
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [self showHint:@"网络连接错误"];
                         }];
}
//搜索更多数据
- (void)networkSearchMoreData
{
    [self.keywordDic setObject:@(++pageIndex) forKey:@"pageIndex"];
    [self.keywordDic setObject:@(pageSize) forKey:@"pageSize"];
    [NetWorkHelp netWorkWithURLString:recordinglist
                           parameters:self.keywordDic
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 [self.searchDataA addObjectsFromArray:[HWOperationModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]]];
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
                         } failBlock:^(NSError *error) {
                             pageIndex--;
                             [self.tableView.mj_footer endRefreshing];
                             [self showHint:@"网络连接错误"];
                         }];
}
#pragma mark - target
- (IBAction)cancelAction:(id)sender
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - lazy
- (NSMutableArray *)searchDataA
{
    if (!_searchDataA) {
        _searchDataA = [NSMutableArray array];
    }
    return _searchDataA;
}
- (NSMutableArray *)hotSeaDataA
{
    if (!_hotSeaDataA) {
        _hotSeaDataA = [NSMutableArray array];
    }
    return _hotSeaDataA;
}
- (NSMutableDictionary *)keywordDic
{
    if (!_keywordDic) {
        _keywordDic = [NSMutableDictionary dictionary];
    }
    return _keywordDic;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}
@end
