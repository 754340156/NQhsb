//
//  CollectionViewController.m
//  Operator
//
//  Created by 白小田 on 16/9/22.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "CollectionViewController.h"
#import "HWPublicWebController.h"
#import "CollectionViewCell.h"
#import "HWCollectionModel.h"
#import "SalesjobDetailViewController.h"

static NSInteger pageIndex = 1;
static NSInteger pageSize = 10;

@interface CollectionViewController ()<UITableViewDataSource,UITableViewDelegate>

kBxtPropertyStrong HWCollectionModel *collectionModel;

kBxtPropertyStrong LXSegmentScrollView *scView;

kBxtPropertyStrong NSMutableArray   *kBxtTableViewArr;

kBxtPropertyStrong UITableView      *myTableview;

kBxtPropertyStrong UITableView      *myTableviewTwo;

kBxtPropertyStrong UITableView      *myTableviewThree;

kBxtPropertyAssign NSInteger        selectType;

kBxtPropertyStrong NSMutableArray * dataArray;

kBxtPropertyStrong NSMutableArray * data2Array;

kBxtPropertyStrong NSMutableArray * data3Array;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleLabel.text = @"收藏";
    _selectType = 1;
    [self.leftBackImage setHidden:YES];
    _kBxtTableViewArr = [NSMutableArray array];
    [self myTableview];
    
    [self myTableviewTwo];
    
    [self myTableviewThree];
    
    [self setRefresh];
    _scView = [[LXSegmentScrollView alloc]
               initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49)
               titleArray:@[@"话术本",@"大讲堂",@"录音库"]
               contentViewArray:_kBxtTableViewArr
               SuccessBlock:^(NSInteger index) {
//                   LogApi(@"%ld",(long)index);
                   _selectType = index;
//                   if (index == 1) {
//                       [weakSelf.myTableview.mj_header beginRefreshing];
//                       
//                   }else if(index == 2){
//                       [weakSelf.myTableviewTwo.mj_header beginRefreshing];
//
//                   }else{
//                       [weakSelf.myTableviewThree.mj_header beginRefreshing];
//                   }
               }];
    [self.view addSubview:_scView];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.myTableview.mj_header beginRefreshing];
    [self.myTableviewTwo.mj_header beginRefreshing];
    [self.myTableviewThree.mj_header beginRefreshing];
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
                 case 1:
                     self.data2Array = [HWCollectionModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
                     [_myTableviewTwo reloadData];
                     break;
                 case 3:
                     self.dataArray = [HWCollectionModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
                     [_myTableview reloadData];
                     break;
                 case 5:
                     self.data3Array = [HWCollectionModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
                     [_myTableviewThree reloadData];
                     break;
             }
             //成功处理数据
             DLog(@"%@",dic);
         }else
         {
             
             [self showHint:dic[@"errorMessage"]];
         }
         switch (type) {
             case 1:
                 [_myTableviewTwo.mj_header endRefreshing];
                 [_myTableviewTwo.mj_footer endRefreshing];
                 break;
             case 3:
                 [_myTableview.mj_header endRefreshing];
                 [_myTableview.mj_footer endRefreshing];
                 break;
             case 5:
                 [_myTableviewThree.mj_header endRefreshing];
                 [_myTableviewThree.mj_footer endRefreshing];
                 break;
         }
     } failBlock:^(NSError *error)
     {
         switch (type) {
             case 1:
                 [_myTableviewTwo.mj_header endRefreshing];
                 [_myTableviewTwo.mj_footer endRefreshing];
                 break;
             case 3:
                 [_myTableview.mj_header endRefreshing];
                 [_myTableview.mj_footer endRefreshing];
                 break;
             case 5:
                 [_myTableviewThree.mj_header endRefreshing];
                 [_myTableviewThree.mj_footer endRefreshing];
                 break;
         }
         [self showHint:@"网络连接失败"];
     }];

    
}
/**  type 1 大讲堂 3 话术本 5 录音库 */
-(void)netWorkMoreDataWithType:(NSInteger)type
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
                 case 1:
                     [self.data2Array addObjectsFromArray: [HWCollectionModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]]];
                     if ( [dic[@"response"][@"count"] integerValue] < pageSize) {
                         [_myTableviewTwo.mj_footer endRefreshingWithNoMoreData];
                         return ;
                     }
                     [_myTableviewTwo reloadData];
                     break;
                 case 3:
                     [self.dataArray addObjectsFromArray: [HWCollectionModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]]];
                     if ( [dic[@"response"][@"count"] integerValue] < pageSize) {
                         [_myTableview.mj_footer endRefreshingWithNoMoreData];
                         return ;
                     }
                     [_myTableview reloadData];
                     break;
                 case 5:
                     [self.data3Array addObjectsFromArray: [HWCollectionModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]]];
                     if ( [dic[@"response"][@"count"] integerValue] < pageSize) {
                         [_myTableviewThree.mj_footer endRefreshingWithNoMoreData];
                         return ;
                     }
                     [_myTableviewThree reloadData];
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
             case 1:
                 [_myTableviewTwo.mj_header endRefreshing];
                 [_myTableviewTwo.mj_footer endRefreshing];
                 break;
             case 3:
                 [_myTableview.mj_header endRefreshing];
                 [_myTableview.mj_footer endRefreshing];
                 break;
             case 5:
                 [_myTableviewThree.mj_header endRefreshing];
                 [_myTableviewThree.mj_footer endRefreshing];
                 break;
         }
     } failBlock:^(NSError *error)
     {
         pageIndex--;
         switch (type) {
             case 1:
                 [_myTableviewTwo.mj_header endRefreshing];
                 [_myTableviewTwo.mj_footer endRefreshing];
                 break;
             case 3:
                 [_myTableview.mj_header endRefreshing];
                 [_myTableview.mj_footer endRefreshing];
                 break;
             case 5:
                 [_myTableviewThree.mj_header endRefreshing];
                 [_myTableviewThree.mj_footer endRefreshing];
                 break;
         }
         [self showHint:@"网络连接失败"];
     }];
    
}
- (void)networkDelegateCollectionWithDataId:(NSString *)dataId
{
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                                 @"dataId":dataId};
    [NetWorkHelp netWorkWithURLString:collectionDelete
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 [self showHint:@"删除成功"];
                             }else{
                                 
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [self showHint:@"网络连接错误"];
                         }];
}
#pragma mark - setup
-(UITableView *)myTableview
{
    if (!_myTableview) {
        _myTableview = [[UITableView alloc] init];
        _myTableview.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64-49);
        _myTableview.delegate = self;
        _myTableview.tableFooterView=[[UIView alloc] init];
        _myTableview.dataSource = self;
        _myTableview.backgroundColor = BXT_BACKGROUND_COLOR;
        [_myTableview registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CollectionViewCell class])];
        _myTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self netWorkHelpWithType:3];
        }];
        [_kBxtTableViewArr addObject:_myTableview];
    }
    return _myTableview;
}
-(UITableView *)myTableviewTwo
{
    if (!_myTableviewTwo) {
        _myTableviewTwo = [[UITableView alloc] init];
        _myTableviewTwo.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64-49);
        _myTableviewTwo.tableFooterView=[[UIView alloc] init];
        _myTableviewTwo.delegate = self;
        _myTableviewTwo.dataSource = self;
        _myTableviewTwo.backgroundColor = BXT_BACKGROUND_COLOR;
        [_myTableviewTwo registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CollectionViewCell class])];
        _myTableviewTwo.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self netWorkHelpWithType:1];
        }];
        [_kBxtTableViewArr addObject:_myTableviewTwo];
    }
    return _myTableviewTwo;
}

-(UITableView *)myTableviewThree
{
    if (!_myTableviewThree) {
        _myTableviewThree = [[UITableView alloc] init];
        _myTableviewThree.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64-49);
        _myTableviewThree.delegate = self;
        _myTableviewThree.tableFooterView=[[UIView alloc] init];
        _myTableviewThree.dataSource = self;
        _myTableviewThree.backgroundColor = BXT_BACKGROUND_COLOR;
        [_myTableviewThree registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CollectionViewCell class])];
        _myTableviewThree.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self netWorkHelpWithType:5];
        }];
        [_kBxtTableViewArr addObject:_myTableviewThree];
    }
    return _myTableviewThree;
}
- (void)setRefresh
{
    MJWeakSelf;
    _myTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf netWorkHelpWithType:3];
    }];
    _myTableviewTwo.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf netWorkHelpWithType:1];
    }];
    _myTableviewThree.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf netWorkHelpWithType:5];
    }];
    _myTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf netWorkMoreDataWithType:3];
    }];
    _myTableviewTwo.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf netWorkMoreDataWithType:1];
    }];
    _myTableviewThree.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf netWorkMoreDataWithType:5];
    }];
    [_myTableview.mj_header beginRefreshing];
    [_myTableviewTwo.mj_header beginRefreshing];
    [_myTableviewThree.mj_header beginRefreshing];
    
    _myTableview.mj_footer.hidden = YES;
    _myTableviewTwo.mj_footer.hidden = YES;
    _myTableviewThree.mj_footer.hidden = YES;
}
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_myTableview])
    {
        _myTableview.mj_footer.hidden = (self.dataArray.count < pageSize);
        return self.dataArray.count;
    }else if ([tableView isEqual:_myTableviewTwo])
    {
        _myTableviewTwo.mj_footer.hidden = (self.data2Array.count < pageSize);
        return self.data2Array.count;
    }else if ([tableView isEqual:_myTableviewThree])
    {
        _myTableviewThree.mj_footer.hidden = (self.data3Array.count < pageSize);
        return self.data3Array.count;
    }
    return  0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CollectionViewCell class])];
    if ([tableView isEqual:_myTableview])
    {
        cell.model = self.dataArray[indexPath.row];
    }else if ([tableView isEqual:_myTableviewTwo])
    {
        cell.model = self.data2Array[indexPath.row];
    }else if ([tableView isEqual:_myTableviewThree])
    {
        cell.model = self.data3Array[indexPath.row];
    }
    //给cell加长按手势
    UILongPressGestureRecognizer *gestureLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(gestureLongPress:)];
    //    gestureLongPress.minimumPressDuration =1;
    [cell.contentView addGestureRecognizer:gestureLongPress];
    return cell;
}
//cell顶格
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
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
        if (tableView == _myTableview) {
            arr = _dataArray;
        }else if (tableView == _myTableviewTwo){
            arr = _data2Array;
        }else{
            arr = _data3Array;
        }
        _collectionModel = arr[row];
        [self networkDelegateCollectionWithDataId:_collectionModel.dataId];
        [arr removeObjectAtIndex:row];
        //        删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView setEditing:NO animated:YES];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark - 长按手势

- (void)gestureLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    UITableView *tableview = [[UITableView alloc] init];
    if (_selectType == 1) {
        tableview = _myTableview;
    }else if(_selectType == 2){
        tableview = _myTableviewTwo;
    }else{
        tableview = _myTableviewThree;
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
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesjobDetailViewController *publicWebVC = [[SalesjobDetailViewController alloc] init];
    
    HWCollectionModel *model = [HWCollectionModel new];
    if ([tableView isEqual:_myTableview])
    {
        model = self.dataArray[indexPath.row];
    }else if ([tableView isEqual:_myTableviewTwo])
    {
        model = self.data2Array[indexPath.row];
    }else if ([tableView isEqual:_myTableviewThree])
    {
        model = self.data3Array[indexPath.row];
    }
    [Html5LoadUrl loadUrlWithRelevanceId:model.dataId
                                    type:model.type
                            SuccessBlock:^(NSString *url) {
                                publicWebVC.kBxtH5Url = url;
                                publicWebVC.kBxtTitle = model.title;
                                publicWebVC.relevanceId = model.dataId;
                                publicWebVC.type        = model.type;
                                publicWebVC.isNotShare = YES;
                                [self.navigationController pushViewController:publicWebVC animated:YES];
                            } failBlock:^(NSError *error) {
                                [self showHint:kBxtNetWorkError];
                            }];
}
#pragma  mark - lazy
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)data2Array
{
    if (!_data2Array) {
        _data2Array = [NSMutableArray array];
    }
    return _data2Array;
}
- (NSMutableArray *)data3Array
{
    if (!_data3Array) {
        _data3Array = [NSMutableArray array];
    }
    return _data3Array;
}
@end
