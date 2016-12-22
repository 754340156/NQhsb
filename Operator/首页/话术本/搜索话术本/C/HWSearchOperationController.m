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
#import "SKTagView.h"//热门搜索
static NSInteger pageIndex = 1;
static NSInteger pageSize = 10;
@interface HWSearchOperationController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SKTagView *tagView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UILabel *hotLabel;

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
    [self searchBarTF];
    [self setTableViewAndCollectionView];
    [self setRefresh];
    [self networkHotSearch];
    [self defaultNetworkSearchWithKeyword];
}
#pragma mark - setup
-(void)searchBarTF
{
    _searchTF = [[UITextField alloc] init];
    _searchTF.frame = CGRectMake(10, 27, WIDTH-70, 33);
    _searchTF.placeholder = @"请输入关键字";
    _searchTF.backgroundColor = color_e7e7e7;
    _searchTF.layer.masksToBounds = YES;
    _searchTF.layer.cornerRadius  = 8;
    _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTF.returnKeyType = UIReturnKeySearch;
    _searchTF.delegate = self;
    [_searchTF becomeFirstResponder];
    
    UIButton *clearBack = [[UIButton alloc] initWithFrame:CGRectMake(_searchTF.right, _searchTF.top, 60, _searchTF.height)];
    [clearBack setTitle:@"取消" forState:UIControlStateNormal];
    [clearBack setTitleColor:KTabBarColor forState:UIControlStateNormal];
    [clearBack addTarget:self action:@selector(clearBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBackground addSubview:clearBack];
    
    [self setTextFieldLeftPadding:_searchTF forWidth:40];
    [self.leftBackImage  setHidden:YES];
    [self.leftButton     setHidden:YES];
    [self setTextFieldLeftPadding:_searchTF forWidth:30];
    [self.navigationBarBackground addSubview:_searchTF];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (!textField.text || [textField.text isEqualToString: @""]) {
        [self showHint:@"请先输入搜索关键字"];
    }else{
        //点击关键字去搜索
        [self networkSearchWithKeyword:textField.text hotLabel:nil];
    }
    return YES;
}
-(void)clearBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tools
-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(leftWidth /3, leftWidth / 3, leftWidth /2, leftWidth/ 2)];
    leftImage.image = [UIImage imageNamed:@"Button_search"];
    [leftview addSubview:leftImage];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}
- (void)setTableViewAndCollectionView
{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWOperationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HWOperationCell class])];

    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = color_f5f5f5;
}
- (void)setRefresh
{
    self.tableView.mj_footer  = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self networkSearchMoreData];
    }];
    self.tableView.mj_footer.hidden = YES;
}
- (void)setTagViewWithDataArray:(NSArray *)array
{
    self.hotLabel.backgroundColor = color_f5f5f5;
    [self.tagView removeAllTags];
    self.tagView.backgroundColor = color_f5f5f5;
    self.tagView.padding = UIEdgeInsetsMake(10, 20, 10, 10);
    self.tagView.lineSpacing = 10;
    self.tagView.interitemSpacing = 20;
    self.tagView.preferredMaxLayoutWidth = 375;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 初始化标签
        SKTag *tag = [[SKTag alloc] initWithText:array[idx]];
        tag.padding = UIEdgeInsetsMake(3, 15, 3, 15);
        tag.cornerRadius = 5.0f;
        tag.font = [UIFont systemFontOfSize:14];
        tag.borderWidth = 0.5f;
        tag.borderColor = KTabBarColor;
        tag.textColor = KTabBarColor;
        tag.bgColor = color_f5f5f5;
        [self.tagView addTag:tag];
    }];
    self.tagView.didTapTagAtIndex = ^(NSUInteger idx){
        //热门标签去搜索
        [self networkSearchWithKeyword:nil hotLabel:array[idx]];
        [self.searchBar resignFirstResponder];
    };
    CGFloat tagHeight = self.tagView.intrinsicContentSize.height;
    self.collectionViewH.constant = tagHeight;
    [self.tagView layoutIfNeeded];
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
        publicWebVC.isNotShare = YES;
        [self.navigationController pushViewController:publicWebVC animated:YES];
    } failBlock:^(NSError *error) {
        [self showHint:kBxtNetWorkError];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
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
                                 [self setTagViewWithDataArray:self.hotSeaDataA];
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
//默认推荐搜索请求
- (void)defaultNetworkSearchWithKeyword
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[UserInfo account].account forKey:@"account"];
    [parameters setObject:[UserInfo account].token forKey:@"token"];
    [parameters setObject:self.type forKey:@"type"];
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
