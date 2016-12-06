//
//  HWAddStudyPlanController.m
//  Operator
//
//  Created by hai on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWAddStudyPlanController.h"
#import "HWStudyPlanDetailController.h"
#import "HWAddStudyPlanCell.h"
#import "HWCollectionModel.h"
static NSInteger pageIndex = 1;
static NSInteger pageSize = 10;
@interface HWAddStudyPlanController ()<UITableViewDataSource,UITableViewDelegate,HWAddStudyPlanCellDelegate>

@property (nonatomic,strong) LXSegmentScrollView *scView;

@property (nonatomic,strong) UIButton * confirmBtn;

@property (nonatomic,strong) NSMutableArray *contentTableViewArr;

@property (nonatomic,strong) UITableView *tableView1;

@property (nonatomic,strong) UITableView *tableView2;

@property (nonatomic,strong) UITableView *tableView3;

@property (nonatomic,assign) NSInteger   currentIndex;

@property (nonatomic,strong) NSMutableArray * dataArray1;

@property (nonatomic,strong) NSMutableArray * dataArray2;

@property (nonatomic,strong) NSMutableArray * dataArray3;
/**  存储点击加入的数组 */
@property (nonatomic,strong) NSMutableArray * addDataArray;
@end

@implementation HWAddStudyPlanController
#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.addDataArray = [NSMutableArray array];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = @"添加学习计划";
    MJWeakSelf;
    self.contentTableViewArr = [NSMutableArray array];
    [self myTableview];
    
    [self myTableviewTwo];
    
    [self myTableviewThree];
    
    [self setRefresh];
    self.scView = [[LXSegmentScrollView alloc]
                   initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-64)
                   titleArray:@[@"话术本",@"大讲堂",@"录音库",]
                   contentViewArray:self.contentTableViewArr
                   SuccessBlock:^(NSInteger index) {
//                       LogApi(@"%ld",(long)index);
//                       self.currentIndex = index;
//                       if (index == 1) {
//                           [weakSelf.tableView1.mj_header beginRefreshing];
//                           
//                       }else if(index == 2){
//                           [weakSelf.tableView2.mj_header beginRefreshing];
//                           
//                       }else{
//                           [weakSelf.tableView3.mj_header beginRefreshing];
//                       }
                   }];
    [self.view addSubview:_scView];
    [self setConfirmBtn];
}
#pragma mark - network
/**  type 1 大讲堂 3 话术本 5 录音库 */
-(void)netWorkHelpWithType:(NSInteger)type
{
    NSDictionary  *parameters=@{@"account":[UserInfo account].account,
                                @"token":[UserInfo account].token,
                                @"type":@(type)};
    
    [NetWorkHelp  netWorkWithURLString:collectionList parameters:parameters SuccessBlock:^(NSDictionary *dic)
     {
         [self hideHud];
         if ([dic[@"code"]integerValue]==0)
         {
             switch (type) {
                 case 3:
                     self.dataArray1 = [HWCollectionModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
                     [self.tableView1 reloadData];
                     break;
                 case 1:
                     self.dataArray2 = [HWCollectionModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
                     [self.tableView2 reloadData];
                     break;
                 case 5:
                     self.dataArray3 = [HWCollectionModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
                     [self.tableView3 reloadData];
                     break;
             }
             //成功处理数据
             DLog(@"%@",dic);
         }else
         {
             
             [self showHint:dic[@"errorMessage"]];
         }
         switch (type) {
             case 3:
                 [self.tableView1.mj_header endRefreshing];
                 [self.tableView1.mj_footer endRefreshing];
                 break;
             case 1:
                 [self.tableView2.mj_header endRefreshing];
                 [self.tableView2.mj_footer endRefreshing];
                 break;
             case 5:
                 [self.tableView3.mj_header endRefreshing];
                 [self.tableView3.mj_footer endRefreshing];
                 break;
         }
     } failBlock:^(NSError *error)
     {
         switch (type) {
             case 3:
                 [self.tableView1.mj_header endRefreshing];
                 [self.tableView1.mj_footer endRefreshing];
                 break;
             case 1:
                 [self.tableView2.mj_header endRefreshing];
                 [self.tableView2.mj_footer endRefreshing];
                 break;
             case 5:
                 [self.tableView3.mj_header endRefreshing];
                 [self.tableView3.mj_footer endRefreshing];
                 break;
         }
         [self showHint:@"网络连接失败"];
     }];
    
    
}
/**  type 1 大讲堂 3 话术本 5 录音库 */
- (void)netWorkMoreDataWithType:(NSInteger)type
{
    NSDictionary *dic = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"type":@(type),
                          @"pageIndex":@(++pageIndex),
                          @"pageSize":@(pageSize)};
    [NetWorkHelp  netWorkWithURLString:collectionList parameters:dic SuccessBlock:^(NSDictionary *dic)
     {
         [self hideHud];
         if ([dic[@"code"] integerValue] == 0) {
             switch (type) {
                 case 3:
                     [self.dataArray1 addObjectsFromArray: [HWCollectionModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]]];
                     if ( [dic[@"response"][@"count"] integerValue] < pageSize) {
                         [self.tableView1.mj_footer endRefreshingWithNoMoreData];
                         return ;
                     }
                     [self.tableView1 reloadData];
                     break;
                 case 1:
                     [self.dataArray2 addObjectsFromArray: [HWCollectionModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]]];
                     if ( [dic[@"response"][@"count"] integerValue] < pageSize) {
                         [self.tableView2.mj_footer endRefreshingWithNoMoreData];
                         return ;
                     }
                     [self.tableView2 reloadData];
                     break;
                 case 5:
                     [self.dataArray3 addObjectsFromArray: [HWCollectionModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]]];
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
         switch (type) {
             case 3:
                 [self.tableView1.mj_header endRefreshing];
                 [self.tableView1.mj_footer endRefreshing];
                 break;
             case 1:
                 [self.tableView2.mj_header endRefreshing];
                 [self.tableView2.mj_footer endRefreshing];
                 break;
             case 5:
                 [self.tableView3.mj_header endRefreshing];
                 [self.tableView3.mj_footer endRefreshing];
                 break;
         }
     } failBlock:^(NSError *error)
     {
         pageIndex--;
         switch (type) {
             case 3:
                 [self.tableView1.mj_header endRefreshing];
                 [self.tableView1.mj_footer endRefreshing];
                 break;
             case 1:
                 [self.tableView2.mj_header endRefreshing];
                 [self.tableView2.mj_footer endRefreshing];
                 break;
             case 5:
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
        [weakSelf netWorkHelpWithType:3];
    }];
    self.tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf netWorkHelpWithType:1];
    }];
    self.tableView3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf netWorkHelpWithType:5];
    }];
    self.tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf netWorkMoreDataWithType:3];
    }];
    self.tableView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf netWorkMoreDataWithType:1];
    }];
    self.tableView3.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf netWorkMoreDataWithType:5];
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
        self.tableView1.tableFooterView = [[UIView alloc] init];
        self.tableView1.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64-64);
        self.tableView1.delegate = self;
        self.tableView1.dataSource = self;
        [self.tableView1 registerNib:[UINib nibWithNibName:NSStringFromClass([HWAddStudyPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HWAddStudyPlanCell class])];
        self.tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self netWorkHelpWithType:3];
        }];
        [self.contentTableViewArr addObject:self.tableView1];
    }
    return self.tableView1;
}
-(UITableView *)myTableviewTwo
{
    if (!self.tableView2) {
        self.tableView2 = [[UITableView alloc] init];
        self.tableView2.tableFooterView = [[UIView alloc] init];
        self.tableView2.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64-64);
        self.tableView2.delegate = self;
        self.tableView2.dataSource = self;
        [self.tableView2 registerNib:[UINib nibWithNibName:NSStringFromClass([HWAddStudyPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HWAddStudyPlanCell class])];
        self.tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self netWorkHelpWithType:1];
        }];
        [self.contentTableViewArr addObject:self.tableView2];
    }
    return self.tableView2;
}
-(UITableView *)myTableviewThree
{
    if (!self.tableView3) {
        self.tableView3 = [[UITableView alloc] init];
        self.tableView3.tableFooterView = [[UIView alloc] init];
        self.tableView3.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64-64);
        self.tableView3.delegate = self;
        self.tableView3.dataSource = self;
        [self.tableView3 registerNib:[UINib nibWithNibName:NSStringFromClass([HWAddStudyPlanCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HWAddStudyPlanCell class])];
        self.tableView3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self netWorkHelpWithType:5];
        }];
        [self.contentTableViewArr addObject:self.tableView3];
    }
    return self.tableView3;
}
- (void)setConfirmBtn
{
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-45);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(45);
    }];
    [self.confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundColor:KTabBarColor];

}
#pragma mark - Target
//点击确定按钮
- (void)confirmAction
{
    if (!self.addDataArray.count) {
        [self showHint:@"请至少加入一个学习计划"];
        return;
    }
    //跳转详情界面
    HWStudyPlanDetailController *detailVC = [[HWStudyPlanDetailController alloc] init];
    //传入模型数组
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.addDataArray) {
        [array addObject:dic.allValues[0]];
    }
    detailVC.kTitle     = @"添加学习计划";
    detailVC.dataArray = array.copy;
    [self.navigationController pushViewController:detailVC animated:YES];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWAddStudyPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HWAddStudyPlanCell class])];
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
    cell.delegate = self;
    return cell;
}
#pragma mark - HWAddStudyPlanCellDelegate
- (void)HWAddStudyPlanCellDelegate_addStudyPlanOrRemoveWithBtn:(UIButton *)sender Model:(HWCollectionModel *)model Cell:(HWAddStudyPlanCell *)cell
{
    NSIndexPath *indexpath = [[NSIndexPath alloc] init];
    switch (self.currentIndex) {
        case 1:
            indexpath = [self.tableView1  indexPathForCell:cell];
            break;
        case 2:
            indexpath = [self.tableView2  indexPathForCell:cell];
            break;
        case 3:
            indexpath = [self.tableView3  indexPathForCell:cell];
            break;
    }
    if (sender.selected) {
        //加入数组
        [self.addDataArray addObject:@{indexpath:model}];
    }else
    {
        for (NSDictionary *dic in self.addDataArray) {
            if (dic[indexpath]) [self.addDataArray removeObject:dic];
        }
        //移除数组
    }
}
#pragma mark - lazy
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
- (NSMutableArray *)addDataArray
{
    if (!_addDataArray) {
        _addDataArray = [NSMutableArray array];
    }
    return _addDataArray;
}


@end
