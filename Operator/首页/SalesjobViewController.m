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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.footerView.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.footerView.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageIndex = 1;
    _pageSize  = 100;
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
                             [self showHint:kBxtNetWorkError];
                         }];
}
-(void)createTitle
{
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:45];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = color_333333;
    menu.selectTextColor = KTabBarColor;
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
        _myTableview.frame = CGRectMake(0, 109, WIDTH, HEIGHT-84);
        _myTableview.delegate = self;
        _myTableview.dataSource = self;
        [_myTableview registerNib:[UINib nibWithNibName:@"SalesjobCell" bundle:nil] forCellReuseIdentifier:kBxtSalesjobCell];
        _myTableview.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            [self netWorkHelp];
        }];
//        _myTableview.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
//            _pageIndex = _pageIndex++;
//            [self netWorkHelp];
//        }];
        [self.view addSubview:_myTableview];
    }
    return _myTableview;
}
#pragma mark - JSDropDownMenu delegate

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    return _responseTitle.nodes.count+1;
}

- (BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    if (column==3) {
        
        return YES;
    }
    
    return NO;
}

- (BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    if (column == 0) {
        return NO;
    }
    return YES;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column == 0) {
        return 1;
    }
    
    return 0.5;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (!_currentData1Index) {
    
        return 0;
        
    }else{
        return _currentData1Index;
    }

}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    titleTwoNodes *two;
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
            if (leftRow>=0) {
                two = titleNodesModels.nodes[leftRow];
            }
            return two.nodes.count;
        }
            
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    if (column == 0) {
        return @"全   部";
    }
    if (column <= _responseTitle.nodes.count) {
        titleNodes *titleNodesModels = _responseTitle.nodes[column-1];
        return titleNodesModels.cname;
    }
    return nil;
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

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath Block:(void(^)(NSInteger count))block {
    
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
            block(titleTwo.nodes.count);
            if (titleTwo.nodes.count) {
                return;
            }
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXTWeakSelf;
    BigForumList *list = _bigResponse.list[indexPath.row];
    SalesjobDetailViewController *job = [[SalesjobDetailViewController alloc] init];
    [Html5LoadUrl loadUrlWithRelevanceId:list.dataId
                                    type:list.type
                            SuccessBlock:^(NSString *url) {
                                job.kBxtH5Url = url;
                                job.kBxtTitle = list.title;
                                job.relevanceId = list.dataId;
                                job.type        = list.type;
                                job.isNotShare = YES;
                                [weakSelf.navigationController pushViewController:job animated:YES];
                            } failBlock:^(NSError *error) {
                                [weakSelf showHint:kBxtNetWorkError];
                            }];
    
}


@end
