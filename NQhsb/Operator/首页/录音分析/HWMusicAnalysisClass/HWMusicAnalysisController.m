//
//  HWMusicAnalysisController.m
//  Operator
//
//  Created by NeiQuan on 16/10/17.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWMusicAnalysisController.h"
#import "HWMusicAnalysicModel.h" //model
#import "HWMusicSelectedModleController.h"
#import "HWMusicSelectedVideoVc.h"
#import "SalesjobDetailViewController.h"
#import "HWMusicAnimationController.h"
#import "HWMusicquestionReportViewController.h"
@interface HWMusicAnalysisController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    
    UITableView         *_tableView;
    UIButton            *_footButton;
    UIButton            *_nextButton;//下一步
    
    
    NSMutableArray      *_dataListArray;
    NSInteger           _pageIndex;
    UITextField        *_textField;//搜索框
}
@end

@implementation HWMusicAnalysisController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text=@"录音分析";
    [self addsubViews];
}
#pragma mark --添加子视图
-(void)addsubViews
{
    _dataListArray =[[NSMutableArray alloc] init];
    [self addTableView];
    [self addfootView];
   // [self addSearchHeaderView];
}
#pragma mark --添加搜索框
-(void)addSearchHeaderView
{
    _textField = [[UITextField alloc] init];
    _textField.frame = CGRectMake(10, 66, WIDTH-20, 34);
    _textField.backgroundColor = BXT_BACKGROUND_COLOR;
    _textField.layer.masksToBounds = YES;
    _textField.layer.cornerRadius  = 15;
    _textField.placeholder = @"  输入关键词";
    _textField.delegate = self;
    [self.view addSubview:_textField];
}
-(void)addTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-45) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = BXT_BACKGROUND_COLOR;
    _tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex =1;
        [self loadMusicListData:_pageIndex];
    }];
    _tableView.tableFooterView=[[UIView alloc] init];
    [_tableView.mj_header beginRefreshing];
    [self.view addSubview:_tableView];
    
}
-(void)addfootView
{
    __weak typeof(self)weakself=self;
    _footButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_footButton setFrame:CGRectMake(0, HEIGHT-45, WIDTH, 45)];
    [_footButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_footButton setBackgroundColor:KTabBarColor];
    _footButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [_footButton setTitle:@"新增录音分析" forState:UIControlStateNormal];
    [_footButton addTarget:weakself action:@selector(pushtoModleVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_footButton];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ self class])];
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ self class])];
    }
    HWMusicAnalysicModel *model=_dataListArray[indexPath.row];
    cell.textLabel.text=model.title.length>0?model.title:@"缺少相关字段";
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    [self  deleteMusicQuestion:indexPath];//删除
   
}
#pragma mark --音乐分析查看--->答完题的界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWMusicAnalysicModel *analysic = _dataListArray[indexPath.row];
    if (![analysic.isShelves isEqualToString:@"1"]) {
        HWMusicquestionReportViewController *job = [[HWMusicquestionReportViewController alloc] init];
        [Html5LoadUrl loadUrlWithRelevanceId:analysic.dataId
                                        type:@"7"
                                SuccessBlock:^(NSString *url) {
                                    job.loadUrl = url;
                                    job.questionlogId = analysic.dataId;
                                    [self.navigationController pushViewController:job animated:YES];
                                } failBlock:^(NSError *error) {
                                    [self showHint:kBxtNetWorkError];
                                }];
    }else{
        [self getQuestionDataAndPushtoAnimationVC:indexPath];
    }
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --选择模板
-(void)pushtoModleVC
{
    HWMusicSelectedVideoVc  *Videoselected=[[HWMusicSelectedVideoVc alloc] init];
    Videoselected.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:Videoselected animated:YES];
    
}
#pragma mark --分页加载网络数据
-(void)loadMusicListData:(NSInteger )pageIndex
{
    //question/list.do
    NSDictionary *parameters=@{@"account":[UserInfo account].account,
                               @"token":[UserInfo account].token,
                               @"pageSize":@"10",
                               @"pageIndex":@(pageIndex)};
    [NetWorkHelp  netWorkWithURLString:questionlist parameters:parameters SuccessBlock:^(NSDictionary *dic)
     {
         if ([dic[@"code"]integerValue]==0)
         {
          //后期要加入判断是否有分页
            _dataListArray=[HWMusicAnalysicModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
            [_tableView reloadData];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
         }
     } failBlock:^(NSError *error)
     {
         
     }];
}
#pragma mark --侧滑删除录音
-(void)deleteMusicQuestion:(NSIndexPath *)indexPath
{
    HWMusicAnalysicModel *model=_dataListArray[indexPath.row];
    NSDictionary *parameters=@{@"account":[UserInfo account].account,
                               @"token":[UserInfo account].token,
                               @"dataId":model.dataId,
                               @"token":[UserInfo account].token};
    
    [self showHudInView:self.view hint:@""];
    [NetWorkHelp  netWorkWithURLString:MusicDelete parameters:parameters SuccessBlock:^(NSDictionary *dic)
     {
         [self hideHud];
         if ([dic[@"code"]integerValue]==0)
         {
             _pageIndex=1;
             [_tableView reloadData];
         }else
         {
             [self showHint:dic[@"errorMessage"]];
         }
     } failBlock:^(NSError *error)
     {
         [self hideHud];
         [self showHint:@"请检查你的网络"];
     }];
}
#pragma mark --获取答题模板数据
-(void)getQuestionDataAndPushtoAnimationVC:(NSIndexPath *)indexPath
{
     NSString *urlids=[_dataListArray[indexPath.row] valueForKeyPath:@"dataId"];

     HWMusicAnimationController  *MusicListVC=[[HWMusicAnimationController alloc] init];
     MusicListVC.hidesBottomBarWhenPushed=YES;
     MusicListVC.relevanceId = urlids;
     [self.navigationController pushViewController:MusicListVC animated:YES];
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
