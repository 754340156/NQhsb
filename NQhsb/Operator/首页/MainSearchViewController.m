//
//  MainSearchViewController.m
//  Operator
//
//  Created by 白小田 on 16/9/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "MainSearchViewController.h"
#import "MainSearchModels.h"
#import "MainSearchFinishModels.h"
#import "MainSearchFinishViewController.h"

static NSString *kBxtSearchCell = @"searchCell";

@interface MainSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

kBxtPropertyStrong UITextField *searchTF;

kBxtPropertyStrong UITableView *myTableview;

kBxtPropertyStrong NSMutableArray *dataArr;

kBxtPropertyAssign NSInteger pageIndex;

kBxtPropertyAssign NSInteger pageSize;

kBxtPropertyStrong MainSearchModels *searchModel;

kBxtPropertyStrong MainSearchResponse *searchResponse;

kBxtPropertyStrong MainSearchFinishModels *finishModels;
@end

@implementation MainSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageIndex = 1;
    _pageSize  = 9;
    [self dataArr];
    [self searchTF];
    [self myTableview];
}
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithObjects:@"贾老师经典销售录音",@"贾老师经典销售录音",@"贾老师经典销售录音", nil];
    }
    return _dataArr;
}
-(UITextField *)searchTF
{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] init];
        _searchTF.frame = CGRectMake(10, 27, WIDTH-70, 35);
        _searchTF.placeholder = @"请输入关键字";
        _searchTF.backgroundColor = BXT_BACKGROUND_COLOR;
        _searchTF.layer.masksToBounds = YES;
        _searchTF.layer.cornerRadius  = 8;
        _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.returnKeyType = UIReturnKeySearch;
        _searchTF.delegate = self;
        [self setTextFieldLeftPadding:_searchTF forWidth:40];
        
        UIButton *clearBack = [[UIButton alloc] initWithFrame:CGRectMake(_searchTF.right, _searchTF.top, 70, _searchTF.height)];
        [clearBack setTitle:@"取消" forState:UIControlStateNormal];
        [clearBack setTitleColor:[UIColor colorWithRed:0.8588 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
        [clearBack addTarget:self action:@selector(clearBtn) forControlEvents:UIControlEventTouchUpInside];
        
        [self.navigationBarBackground addSubview:_searchTF];
        [self.navigationBarBackground addSubview:clearBack];
    }
    return _searchTF;
}
-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(leftWidth /2, leftWidth / 5, leftWidth /2.5, leftWidth/ 2.5)];
    leftImage.image = [UIImage imageNamed:@"Button_search"];
    [leftview addSubview:leftImage];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}
-(UITableView *)myTableview
{
    if (!_myTableview) {
        _myTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
        _myTableview.delegate = self;
        _myTableview.dataSource = self;
        _myTableview.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
           [self netWorkSearch];
        }];
        
        UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        foot.backgroundColor = [UIColor colorWithRed:0.7261 green:0.7223 blue:0.73 alpha:1.0];
        UIButton *footLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, foot.width, foot.height)];
        [footLabel setTitle:@"清理历史纪录" forState:UIControlStateNormal];
        [footLabel setTintColor:[UIColor blackColor]];
        footLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
        footLabel.backgroundColor = [UIColor clearColor];
        [footLabel addTarget:self action:@selector(cleanSearch) forControlEvents:UIControlEventTouchUpInside];
        [foot addSubview:footLabel];
        _myTableview.tableFooterView = foot;
        [self.view addSubview:_myTableview];
        [self netWorkSearch];
    }
    return _myTableview;
}
-(void)clearBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
//清除全部搜索纪录
-(void)cleanSearch
{
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token};
    [NetWorkHelp netWorkWithURLString:delAllRecentlySearch
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 [self showHint:@"清除成功"];
                                 [self netWorkSearch];
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [self showHint:@"网络连接失败"];
                         }];
}
-(void)netWorkSearch
{
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"pageIndex":@(_pageIndex),
                          @"pageSize":@(_pageSize)};
    [NetWorkHelp netWorkWithURLString:recentlySearch
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 _searchModel = [MainSearchModels mj_objectWithKeyValues:dic];
                                 if (!_searchModel.response.count) {
                                     _myTableview.tableFooterView.hidden = YES;
                                 }
                                 [_myTableview reloadData];
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [self showHint:@"网络连接失败"];
                         }];
    
}
-(void)beginSearch:(NSString *)searchText
{
    NSDictionary *dic = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"keyword":searchText,
                          @"pageIndex":@(_pageIndex),
                          @"pageSize":@(_pageSize)};
    [NetWorkHelp netWorkWithURLString:recentlySearch
                           parameters:dic
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 _finishModels = [MainSearchFinishModels mj_objectWithKeyValues:dic];
                                 MainSearchFinishViewController *main = [[MainSearchFinishViewController alloc] init];
                                 main.response = _finishModels.response;
                                 [self.navigationController pushViewController:main animated:YES];
                                 
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [self showHint:@"网络连接失败"];
                         }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchModel.response.count;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self  delegateBtnClick:indexPath];//删除
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBxtSearchCell];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kBxtSearchCell];
    }
    _searchResponse = _searchModel.response[indexPath.row];
    cell.textLabel.text = _searchResponse.keyword;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _searchResponse = _searchModel.response[indexPath.row];
    [self beginSearch:_searchResponse.keyword];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (!textField.text) {
        [self showHint:@"请先输入搜索关键字"];
    }else{
        [self beginSearch:textField.text];
    }
    return YES;
}
-(void)delegateBtnClick:(NSIndexPath *)indexPath
{
    _searchResponse = _searchModel.response[indexPath.row];
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"dataId":_searchResponse.dataId};
    [NetWorkHelp netWorkWithURLString:delOneRecentlySearch
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 [self showHint:@"删除成功"];
                                 [self netWorkSearch];
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [self showHint:@"网络连接失败"];
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
