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
#import "SalesjobDetailViewController.h" //详情
static NSInteger pageIndex = 1;
static NSInteger pageSize = 10;
@interface HWMyOperationController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) HWOperationModel *operationModel;

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
//                   LogApi(@"%ld",(long)index);
                   self.currentIndex = index;
//                   if (index == 1) {
//                       [weakSelf.tableView1.mj_header beginRefreshing];
//                       
//                   }else if(index == 2){
//                       [weakSelf.tableView2.mj_header beginRefreshing];
//                       
//                   }else{
//                       [weakSelf.tableView3.mj_header beginRefreshing];
//                   }
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
    
    [NetWorkHelp  netWorkWithURLString:listOfMe
                            parameters:parameters
                          SuccessBlock:^(NSDictionary *dic)
     {
         [self hideHud];
         if ([dic[@"code"]integerValue]==0)
         {
             switch (wordsType) {
                 case 1:
                     _dataArray1 = [HWOperationModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
                     [_tableView1 reloadData];
                     break;
                 case 2:
                     _dataArray2 = [HWOperationModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
                     [_tableView2 reloadData];
                     break;
                 case 3:
                     _dataArray3 = [HWOperationModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
                     [_tableView3 reloadData];
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
                 [_tableView1.mj_header endRefreshing];
                 [_tableView1.mj_footer endRefreshing];
                 break;
             case 2:
                 [_tableView2.mj_header endRefreshing];
                 [_tableView2.mj_footer endRefreshing];
                 break;
             case 3:
                 [_tableView3.mj_header endRefreshing];
                 [_tableView3.mj_footer endRefreshing];
                 break;
         }
     } failBlock:^(NSError *error)
     {
         switch (wordsType) {
             case 1:
                 [_tableView1.mj_header endRefreshing];
                 [_tableView1.mj_footer endRefreshing];
                 break;
             case 2:
                 [_tableView2.mj_header endRefreshing];
                 [_tableView2.mj_footer endRefreshing];
                 break;
             case 3:
                 [_tableView3.mj_header endRefreshing];
                 [_tableView3.mj_footer endRefreshing];
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
                         [_tableView1.mj_footer endRefreshingWithNoMoreData];
                         return ;
                     }
                     [self.tableView1 reloadData];
                     break;
                 case 2:
                     [self.dataArray2 addObjectsFromArray: [HWOperationModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]]];
                     if ( [dic[@"response"][@"count"] integerValue] < pageSize) {
                         [_tableView2.mj_footer endRefreshingWithNoMoreData];
                         return ;
                     }
                     [self.tableView2 reloadData];
                     break;
                 case 3:
                     [self.dataArray3 addObjectsFromArray: [HWOperationModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]]];
                     if ( [dic[@"response"][@"count"] integerValue] < pageSize) {
                         [_tableView3.mj_footer endRefreshingWithNoMoreData];
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
                 [_tableView1.mj_header endRefreshing];
                 [_tableView1.mj_footer endRefreshing];
                 break;
             case 2:
                 [_tableView2.mj_header endRefreshing];
                 [_tableView2.mj_footer endRefreshing];
                 break;
             case 3:
                 [_tableView3.mj_header endRefreshing];
                 [_tableView3.mj_footer endRefreshing];
                 break;
         }
     } failBlock:^(NSError *error)
     {
         pageIndex--;
         switch (wordsType) {
             case 1:
                 [_tableView1.mj_header endRefreshing];
                 [_tableView1.mj_footer endRefreshing];
                 break;
             case 2:
                 [_tableView2.mj_header endRefreshing];
                 [_tableView2.mj_footer endRefreshing];
                 break;
             case 3:
                 [_tableView3.mj_header endRefreshing];
                 [_tableView3.mj_footer endRefreshing];
                 break;
         }
         [self showHint:@"网络连接失败"];
     }];
    
}
- (void)setRefresh
{
    MJWeakSelf;
    _tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf netWorkHelpWithWordsType:1];
    }];
    _tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf netWorkHelpWithWordsType:2];
    }];
    _tableView3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf netWorkHelpWithWordsType:3];
    }];
    _tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf netWorkMoreDataWithWordsType:1];
    }];
    _tableView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf netWorkMoreDataWithWordsType:2];
    }];
    _tableView3.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf netWorkMoreDataWithWordsType:3];
    }];
    [_tableView1.mj_header beginRefreshing];
    [_tableView2.mj_header beginRefreshing];
    [_tableView3.mj_header beginRefreshing];
    
    _tableView1.mj_footer.hidden = YES;
    _tableView2.mj_footer.hidden = YES;
    _tableView3.mj_footer.hidden = YES;
}
#pragma mark - setup
-(UITableView *)myTableview
{
    if (!_tableView1) {
        _tableView1 = [[UITableView alloc] init];
        _tableView1.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
        _tableView1.delegate = self;
        _tableView1.dataSource = self;
        _tableView1.backgroundColor = BXT_BACKGROUND_COLOR;
        [_tableView1 registerNib:[UINib nibWithNibName:NSStringFromClass([HWOperationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HWOperationCell class])];
        _tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self netWorkHelpWithWordsType:1];
        }];
        _tableView1.tableFooterView=[[UIView alloc] init];
        [_contentTableViewArr addObject:_tableView1];
    }
    return _tableView1;
}
-(UITableView *)myTableviewTwo
{
    if (!_tableView2) {
        _tableView2 = [[UITableView alloc] init];
        
        _tableView2.tableFooterView=[[UIView alloc] init];
        
        _tableView2.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        _tableView2.backgroundColor = BXT_BACKGROUND_COLOR;
        [_tableView2 registerNib:[UINib nibWithNibName:NSStringFromClass([HWOperationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HWOperationCell class])];
        self.tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self netWorkHelpWithWordsType:2];
        }];
        [_contentTableViewArr addObject:_tableView2];
    }
    return _tableView2;
}
-(UITableView *)myTableviewThree
{
    if (!_tableView3) {
        _tableView3 = [[UITableView alloc] init];
        _tableView3.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
        _tableView3.tableFooterView=[[UIView alloc] init];
        _tableView3.delegate = self;
        _tableView3.dataSource = self;
        _tableView3.backgroundColor = BXT_BACKGROUND_COLOR;
        [_tableView3 registerNib:[UINib nibWithNibName:NSStringFromClass([HWOperationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HWOperationCell class])];
        _tableView3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self netWorkHelpWithWordsType:3];
        }];
        [_contentTableViewArr addObject:_tableView3];
    }
    return _tableView3;
}
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView1])
    {
        _tableView1.mj_footer.hidden = (_dataArray1.count < pageSize);
        return _dataArray1.count;
    }else if ([tableView isEqual:_tableView2])
    {
        _tableView2.mj_footer.hidden = (_dataArray2.count < pageSize);
        return _dataArray2.count;
    }else if ([tableView isEqual:_tableView3])
    {
        _tableView3.mj_footer.hidden = (_dataArray3.count < pageSize);
        return _dataArray3.count;
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
    if ([tableView isEqual:_tableView1])
    {
        cell.model = _dataArray1[indexPath.row];
    }else if ([tableView isEqual:_tableView2])
    {
        cell.model = _dataArray2[indexPath.row];
        
    }else if ([tableView isEqual:_tableView3])
    {
        cell.model = _dataArray3[indexPath.row];
    }
    //给cell加长按手势
    UILongPressGestureRecognizer *gestureLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(gestureLongPress:)];
//    gestureLongPress.minimumPressDuration =1;
    [cell.contentView addGestureRecognizer:gestureLongPress];
    
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //        获取选中删除行索引值
        NSInteger row = [indexPath row];
        //        通过获取的索引值删除数组中的值
        NSMutableArray *arr = [NSMutableArray array];
        if (tableView == _tableView1) {
            arr = _dataArray1;
        }else if (tableView == _tableView2){
            arr = _dataArray2;
        }else{
            arr = _dataArray3;
        }
        _operationModel = arr[indexPath.row];
        [self netWorkHelpId:_operationModel.dataId];
        [arr removeObjectAtIndex:row];
        
        //        删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }  
}
#pragma mark - 长按手势

- (void)gestureLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    UITableView *tableview = [[UITableView alloc] init];
    if (_currentIndex == 1) {
        tableview = _tableView1;
    }else if(_currentIndex == 2){
        tableview = _tableView2;
    }else{
        tableview = _tableView3;
    }
    CGPoint tmpPointTouch = [gestureRecognizer locationInView:tableview];
    if (gestureRecognizer.state ==UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [tableview indexPathForRowAtPoint:tmpPointTouch];
        if (indexPath == nil) {
            LogError(@"not tableView");
        }else{
            NSInteger focusSection = [indexPath section];
            NSInteger  focusRow = [indexPath row];
            
            LogError(@"%ld",focusSection);
            LogError(@"%ld",focusRow);
            if (tableview.editing == YES) {
                [tableview setEditing:NO animated:YES];
            }else{
                [tableview setEditing:YES animated:YES];
            }
            
//            deletebtn.hidden =NO;
        }
    }
}
#pragma mark --点击单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesjobDetailViewController *webVc=[[SalesjobDetailViewController alloc] init];
    NSString *dataId = [NSString string];
    NSString *title = [NSString string];
    if ([tableView isEqual:_tableView1])//文本
    {
        dataId = [_dataArray1[indexPath.row] dataId];
        title = [_dataArray1[indexPath.row] title];
    }else if ([tableView isEqual:_tableView2])//图片
    {
        dataId = [_dataArray2[indexPath.row] dataId];
        title = [_dataArray2[indexPath.row] title];
    }else if ([tableView isEqual:_tableView3])//语音
    {
        dataId = [_dataArray3[indexPath.row] dataId];
        title = [_dataArray3[indexPath.row] title];
    }
    [Html5LoadUrl loadUrlWithRelevanceId:dataId type:@"3" SuccessBlock:^(NSString *url) {
        webVc.kBxtH5Url = url;
        webVc.type = @"3";
        webVc.kBxtTitle = title;
        webVc.relevanceId = dataId;
        [self.navigationController pushViewController:webVc animated:YES];
    } failBlock:^(NSError *error) {
        [self showHint:kBxtNetWorkError];
    }];
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

-(void)netWorkHelpId:(NSString *)Id
{
    NSDictionary *dic = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"type":@"3",
                          @"wordsType":[NSString stringWithFormat:@"%ld",_currentIndex],
                          @"dataId":Id};
    [NetWorkHelp netWorkWithURLString:recordingdelete
                           parameters:dic
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

@end
