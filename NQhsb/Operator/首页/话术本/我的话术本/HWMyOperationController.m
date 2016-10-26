//
//  HWMyOperationController.m
//  Operator
//
//  Created by hai on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWMyOperationController.h"
#import "HWOperationCell.h"
#import "HWOperationModel.h"
#import "HWPublicWebController.h" //详情
static NSInteger pageIndex = 1;
static NSInteger pageSize = 10;
@interface HWMyOperationController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) LXSegmentScrollView *scView;

@property (nonatomic,strong) NSMutableArray *contentTableViewArr;

@property (nonatomic,strong) UITableView *tableView1;

@property (nonatomic,strong) UITableView *tableView2;

@property (nonatomic,strong) UITableView *tableView3;

@property (nonatomic,assign) NSInteger   currentIndex;

@property (nonatomic,strong) NSMutableArray * dataArray1;

@property (nonatomic,strong) NSMutableArray * dataArray2;

@property (nonatomic,strong) NSMutableArray * dataArray3;
@end

@implementation HWMyOperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.titleText;
    MJWeakSelf;
    self.contentTableViewArr = [NSMutableArray array];
    [self myTableview];
    
    [self myTableviewTwo];
    
    [self myTableviewThree];
    
    [self setRefresh];
    self.scView = [[LXSegmentScrollView alloc]
               initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)
               titleArray:@[@"文本",@"图片",@"录音",]
               contentViewArray:self.contentTableViewArr
               SuccessBlock:^(NSInteger index) {
                   LogApi(@"%ld",(long)index);
                   self.currentIndex = index;
                   
                   if (index == 1) {
                       [weakSelf.tableView1.mj_header beginRefreshing];
                       
                   }else if(index == 2){
                       [weakSelf.tableView2.mj_header beginRefreshing];
                       
                   }else{
                       [weakSelf.tableView3.mj_header beginRefreshing];
                   }
               }];
    [self.view addSubview:_scView];
    
}
#pragma mark - network
/**  type 1 文字 2 图片 3 录音 */
-(void)netWorkHelpWithWordsType:(NSInteger)wordsType
{
    NSDictionary  *parameters=@{@"account":[UserInfo account].account,
                                @"token":[UserInfo account].token,
                                @"type":@(3),
                                @"wordsType":@(wordsType)};
    
    [NetWorkHelp  netWorkWithURLString:listOfMe parameters:parameters SuccessBlock:^(NSDictionary *dic)
     {
         [self hideHud];
         if ([dic[@"code"]integerValue]==0)
         {
             switch (wordsType) {
                 case 1:
                     self.dataArray1 = [HWOperationModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
                     [self.tableView1 reloadData];
                     break;
                 case 2:
                     self.dataArray2 = [HWOperationModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
                     [self.tableView2 reloadData];
                     break;
                 case 3:
                     self.dataArray3 = [HWOperationModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
                     [self.tableView3 reloadData];
                     break;
             }
             //成功处理数据
             DLog(@"%@",dic);
         }else
         {
             
             [self showHint:dic[@"errorMessage"]];
         }
         switch (wordsType) {
             case 1:
                 [self.tableView1.mj_header endRefreshing];
                 [self.tableView1.mj_footer endRefreshing];
                 break;
             case 2:
                 [self.tableView2.mj_header endRefreshing];
                 [self.tableView2.mj_footer endRefreshing];
                 break;
             case 3:
                 [self.tableView3.mj_header endRefreshing];
                 [self.tableView3.mj_footer endRefreshing];
                 break;
         }
     } failBlock:^(NSError *error)
     {
         switch (wordsType) {
             case 1:
                 [self.tableView1.mj_header endRefreshing];
                 [self.tableView1.mj_footer endRefreshing];
                 break;
             case 2:
                 [self.tableView2.mj_header endRefreshing];
                 [self.tableView2.mj_footer endRefreshing];
                 break;
             case 3:
                 [self.tableView3.mj_header endRefreshing];
                 [self.tableView3.mj_footer endRefreshing];
                 break;
         }
         [self showHint:@"网络连接失败"];
     }];
    
    
}
/**  type 1 文字 2 图片 3 录音 */
-(void)netWorkMoreDataWithWordsType:(NSInteger)wordsType
{
    NSDictionary *dic = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"type":@(3),
                          @"wordsType":@(wordsType),
                          @"pageIndex":@(++pageIndex),
                          @"pageSize":@(pageSize)};
    [NetWorkHelp  netWorkWithURLString:listOfMe parameters:dic SuccessBlock:^(NSDictionary *dic)
     {
         [self hideHud];
         if ([dic[@"code"] integerValue] == 0) {
             
             
             switch (wordsType) {
                 case 1:
                     [self.dataArray1 addObjectsFromArray: [HWOperationModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]]];
                     if ( [dic[@"response"][@"count"] integerValue] < pageSize) {
                         [self.tableView1.mj_footer endRefreshingWithNoMoreData];
                         return ;
                     }
                     [self.tableView1 reloadData];
                     break;
                 case 2:
                     [self.dataArray2 addObjectsFromArray: [HWOperationModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]]];
                     if ( [dic[@"response"][@"count"] integerValue] < pageSize) {
                         [self.tableView2.mj_footer endRefreshingWithNoMoreData];
                         return ;
                     }
                     [self.tableView2 reloadData];
                     break;
                 case 3:
                     [self.dataArray3 addObjectsFromArray: [HWOperationModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]]];
                     if ( [dic[@"response"][@"count"] integerValue] < pageSize) {
                         [self.tableView3.mj_footer endRefreshingWithNoMoreData];
                         return ;
                     }
                     [self.tableView3 reloadData];
                     break;
             }
             //成功处理数据
             DLog(@"%@",dic);
         }else
         {
             pageIndex--;
             [self showHint:dic[@"errorMessage"]];
         }
         switch (wordsType) {
             case 1:
                 [self.tableView1.mj_header endRefreshing];
                 [self.tableView1.mj_footer endRefreshing];
                 break;
             case 2:
                 [self.tableView2.mj_header endRefreshing];
                 [self.tableView2.mj_footer endRefreshing];
                 break;
             case 3:
                 [self.tableView3.mj_header endRefreshing];
                 [self.tableView3.mj_footer endRefreshing];
                 break;
         }
     } failBlock:^(NSError *error)
     {
         pageIndex--;
         switch (wordsType) {
             case 1:
                 [self.tableView1.mj_header endRefreshing];
                 [self.tableView1.mj_footer endRefreshing];
                 break;
             case 2:
                 [self.tableView2.mj_header endRefreshing];
                 [self.tableView2.mj_footer endRefreshing];
                 break;
             case 3:
                 [self.tableView3.mj_header endRefreshing];
                 [self.tableView3.mj_footer endRefreshing];
                 break;
         }
         [self showHint:@"网络连接失败"];
     }];
    
}
- (void)setRefresh
{
    MJWeakSelf;
    self.tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf netWorkHelpWithWordsType:1];
    }];
    self.tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf netWorkHelpWithWordsType:2];
    }];
    self.tableView3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf netWorkHelpWithWordsType:3];
    }];
    self.tableView1.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakSelf netWorkMoreDataWithWordsType:1];
    }];
    self.tableView2.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakSelf netWorkMoreDataWithWordsType:2];
    }];
    self.tableView3.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakSelf netWorkMoreDataWithWordsType:3];
    }];
    [self.tableView1.mj_header beginRefreshing];
    [self.tableView2.mj_header beginRefreshing];
    [self.tableView3.mj_header beginRefreshing];
    
    self.tableView1.mj_footer.hidden = YES;
    self.tableView2.mj_footer.hidden = YES;
    self.tableView3.mj_footer.hidden = YES;
}
#pragma mark - setup
-(UITableView *)myTableview
{
    if (!self.tableView1) {
        self.tableView1 = [[UITableView alloc] init];
        self.tableView1.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
        self.tableView1.delegate = self;
        self.tableView1.dataSource = self;
        [self.tableView1 registerNib:[UINib nibWithNibName:NSStringFromClass([HWOperationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HWOperationCell class])];
        self.tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self netWorkHelpWithWordsType:1];
        }];
        self.tableView1.tableFooterView=[[UIView alloc] init];
        [self.contentTableViewArr addObject:self.tableView1];
    }
    return self.tableView1;
}
-(UITableView *)myTableviewTwo
{
    if (!self.tableView2) {
        self.tableView2 = [[UITableView alloc] init];
        
        self.tableView2.tableFooterView=[[UIView alloc] init];
        
        self.tableView2.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
        self.tableView2.delegate = self;
        self.tableView2.dataSource = self;
        [self.tableView2 registerNib:[UINib nibWithNibName:NSStringFromClass([HWOperationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HWOperationCell class])];
        self.tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self netWorkHelpWithWordsType:2];
        }];
        [self.contentTableViewArr addObject:self.tableView2];
    }
    return self.tableView2;
}
-(UITableView *)myTableviewThree
{
    if (!self.tableView3) {
        self.tableView3 = [[UITableView alloc] init];
        self.tableView3.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
        self.tableView3.tableFooterView=[[UIView alloc] init];
        self.tableView3.delegate = self;
        self.tableView3.dataSource = self;
        [self.tableView3 registerNib:[UINib nibWithNibName:NSStringFromClass([HWOperationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HWOperationCell class])];
        self.tableView3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self netWorkHelpWithWordsType:3];
        }];
        [self.contentTableViewArr addObject:self.tableView3];
    }
    return self.tableView3;
}
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView1])
    {
        self.tableView1.mj_footer.hidden = (self.dataArray1.count < pageSize);
        return self.dataArray1.count;
    }else if ([tableView isEqual:self.tableView2])
    {
        self.tableView2.mj_footer.hidden = (self.dataArray2.count < pageSize);
        return self.dataArray2.count;
    }else if ([tableView isEqual:self.tableView3])
    {
        self.tableView3.mj_footer.hidden = (self.dataArray3.count < pageSize);
        return self.dataArray3.count;
    }
    return  0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HWOperationCell class])];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if ([tableView isEqual:self.tableView1])
    {
        cell.model = self.dataArray1[indexPath.row];
    }else if ([tableView isEqual:self.tableView2])
    {
        cell.model = self.dataArray2[indexPath.row];
    }else if ([tableView isEqual:self.tableView3])
    {
        cell.model = self.dataArray3[indexPath.row];
    }
    return cell;
}
#pragma mark --点击单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWPublicWebController  *webVc=[[HWPublicWebController alloc] init];
    webVc.type=@"3"; //话术本
    if ([tableView isEqual:self.tableView1])//文本
    {
        HWOperationModel *model=self.dataArray1[indexPath.row];
        webVc.RelevanceId=model.dataId;
       
    }else if ([tableView isEqual:self.tableView2])//图片
    {
        HWOperationModel *model=self.dataArray2[indexPath.row];
          webVc.RelevanceId=model.dataId;
    }else if ([tableView isEqual:self.tableView3])//语音
    {
         HWOperationModel *model=self.dataArray3[indexPath.row];
         webVc.RelevanceId=model.dataId;
    }
    [self.navigationController pushViewController:webVc animated:YES];
}
#pragma  mark - lazy
- (NSMutableArray *)dataArray1
{
    if (!_dataArray1) {
        _dataArray1 = [NSMutableArray array];
    }
    return _dataArray1;
}
- (NSMutableArray *)dataArray2
{
    if (!_dataArray2) {
        _dataArray2 = [NSMutableArray array];
    }
    return _dataArray2;
}
- (NSMutableArray *)dataArray3
{
    if (!_dataArray3) {
        _dataArray3 = [NSMutableArray array];
    }
    return _dataArray3;
}

@end
