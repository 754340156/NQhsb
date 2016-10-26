//
//  SalesjobViewController.m
//  Operator
//
//  Created by 白小田 on 16/9/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "SalesjobViewController.h"
#import "JSDropDownMenu.h"
#import "SalesjobCell.h"
#import "TitleModels.h"
#import "BigForumModels.h"
#import "SalesjobDetailViewController.h"
static NSString *kBxtSalesjobCell = @"SalesjobCell";

@interface SalesjobViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSInteger _currentData1Index;
    NSInteger _pageIndex;
    NSInteger _pageSize;
    NSString *_searchTitle;
    NSString *_searchTitleID;
    titleResponse *_responseTitle;
    BigForumResponse *_bigResponse;
}
kBxtPropertyStrong UITableView *myTableview;
@end

@implementation SalesjobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageIndex = 1;
    _pageSize  = 9;
    _searchTitle = @"";
    _searchTitleID = @"";
    self.titleLabel.text = _selectTitleType;
    [self netWorkHelpTitle];
    [self myTableview];
}
-(void)netWorkHelp
{
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"type":_selectType,
                          @"keyword":_searchTitle,
                          @"attribution":_searchTitleID,
                          @"pageIndex":[NSString stringWithFormat:@"%ld",_pageIndex],
                          @"pageSize":[NSString stringWithFormat:@"%ld",_pageSize]};
    [NetWorkHelp netWorkWithURLString:recordinglist
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 _bigResponse = [BigForumResponse mj_objectWithKeyValues:dic[@"response"]];
                                 [_myTableview reloadData];
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
-(void)netWorkHelpTitle
{

    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"type":_selectType};
    [NetWorkHelp netWorkWithURLString:titleTree
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 _responseTitle = [titleResponse mj_objectWithKeyValues:dic[@"response"]];
                                 [self createTitle];
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             
                         }];
}
-(void)createTitle
{
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:45];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    [_myTableview.mj_header beginRefreshing];
    [self netWorkHelp];
}       
-(UITableView *)myTableview
{
    if (!_myTableview) {
        _myTableview = [[UITableView alloc] init];
        _myTableview.frame = CGRectMake(0, 104, WIDTH, HEIGHT-84);
        _myTableview.delegate = self;
        _myTableview.dataSource = self;
        [_myTableview registerNib:[UINib nibWithNibName:@"SalesjobCell" bundle:nil] forCellReuseIdentifier:kBxtSalesjobCell];
        _myTableview.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            [self netWorkHelp];
        }];
        _myTableview.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
            _pageIndex = _pageIndex++;
            [self netWorkHelp];
        }];
        [self.view addSubview:_myTableview];
    }
    return _myTableview;
}
#pragma mark - JSDropDownMenu delegate

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    return _responseTitle.nodes.count+1;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    if (column==3) {
        
        return YES;
    }
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    if (column == 1 || column == 2) {
        return YES;
    }
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column==1 || column == 2) {
        return 0.3;
    }
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (!_currentData1Index) {
    
        return 0;
        
    }else{
        return _currentData1Index;
    }

}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column == 0) {
        _searchTitle = @"";
        _searchTitleID = @"";
        [self netWorkHelp];
        return 0;
    }else{
        titleNodes *titleNodesModels = _responseTitle.nodes[column-1];
        if (leftOrRight==0) {
            return titleNodesModels.nodes.count;
        } else{
            titleTwoNodes *two = titleNodesModels.nodes[leftRow];
            return two.nodes.count;
        }
    }

}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    if (column == 0) {
        return @"全   部";
    }
    titleNodes *titleNodesModels = _responseTitle.nodes[column-1];
    return titleNodesModels.cname;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    
    if (indexPath.leftOrRight==0) {
        titleNodes *titleNodesModels = _responseTitle.nodes[indexPath.column-1];
        titleTwoNodes *titleTwo = titleNodesModels.nodes[indexPath.row];
        return titleTwo.cname;
    } else{
        titleNodes *titleNodesModels = _responseTitle.nodes[indexPath.column-1];
        titleTwoNodes *titleTwo = titleNodesModels.nodes[indexPath.leftRow];
        
        if (!titleTwo.nodes.count) {
            return titleTwo.cname;
        }else{
            titleThreeNodes *titleTreeT = titleTwo.nodes[indexPath.row];
            return titleTreeT.cname;
        }

    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        _searchTitle = @"";
        _searchTitleID = @"";
    }else{
        if(indexPath.leftOrRight==0){
            
            _currentData1Index = indexPath.column-1;
            titleNodes *titleNodesModels = _responseTitle.nodes[_currentData1Index];
            titleTwoNodes *titleTwo = titleNodesModels.nodes[indexPath.row];
            _searchTitle = titleTwo.cname;
            _searchTitleID = titleTwo.code;
            return;
        }else{
            _currentData1Index = indexPath.row;
            titleNodes *titleNodesModels = _responseTitle.nodes[indexPath.column-1];
            titleTwoNodes *titleTwo = titleNodesModels.nodes[indexPath.leftRow];
            
            if (!titleTwo.nodes.count) {
                 _searchTitle = titleTwo.cname;
                _searchTitleID = titleTwo.code;
            }else{
                titleThreeNodes *titleTreeT = titleTwo.nodes[indexPath.row];
                _searchTitle = titleTreeT.cname;
                _searchTitleID = titleTreeT.code;
            }
        }
    }
    [_myTableview.mj_header beginRefreshing];
    [self netWorkHelp];
    
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
