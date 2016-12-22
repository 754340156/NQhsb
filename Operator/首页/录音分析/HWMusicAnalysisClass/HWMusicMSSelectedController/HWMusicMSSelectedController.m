//
//  HWMusicMSSelectedController.m
//  Operator
//
//  Created by NeiQuan on 16/10/17.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWMusicMSSelectedController.h"
#import "HWMusicAnalysicModel.h"
#import "HWMusicAnimationController.h" //开始分析->动画
#import "HWHttpManger.h"
@interface HWMusicMSSelectedController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView         *_tableView;
    UIButton            *_footButton;
}
@end

@implementation HWMusicMSSelectedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text=@"录音分析模板";
    [self addsubViews];
    
    // Do any additional setup after loading the view.
}
#pragma mark --添加子视图
-(void)addsubViews
{
    [self addTableView];
    [self addfootView];
}
#pragma mark --set方法调用
-(void)setDatalistArray:(NSMutableArray *)datalistArray
{
    _datalistArray=datalistArray;
    [_tableView reloadData];
    
}
-(void)addTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-40) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
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
    _footButton.layer.masksToBounds = YES;
    _footButton.layer.cornerRadius  = 3;
    [_footButton setTitle:@"确定模板" forState:UIControlStateNormal];
    [_footButton addTarget:weakself action:@selector(getQuestionDataAndPushtoAnimationVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_footButton];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _datalistArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ self class])];
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([ self class])];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
 
    HWMusicAnalysicListModel  *model=_datalistArray[indexPath.row];
    cell.textLabel.text=model.title;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 46;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --获取答题模板数据
-(void)getQuestionDataAndPushtoAnimationVC
{
    
    [self showHudInView:self.view hint:@""];
    NSString *urlids=[[_datalistArray valueForKeyPath:@"dataId"] componentsJoinedByString:@","];
    NSDictionary *parameters=@{@"account":[UserInfo account].account,
                               @"ids":urlids,
                               @"title":_pushtitle,
                               @"token":[UserInfo account].token};
    [NetWorkHelp  netWorkWithURLString:MusicquestionChooselist parameters:parameters SuccessBlock:^(NSDictionary *dic)
     {   [self hideHud];
         if ([dic[@"code"]integerValue]==0)
         {
             HWMusicAnimationController  *MusicListVC=[[HWMusicAnimationController alloc] init];
                MusicListVC.hidesBottomBarWhenPushed=YES;
             
             //需要把头部和尾部的model添加进去
             
              HWMusicquestionListModel *headerModel=[HWMusicquestionListModel mj_objectWithKeyValues:dic[@"response"][@"head"]];
             
//              HWMusicquestionListModel *footModel=[HWMusicquestionListModel mj_objectWithKeyValues:dic[@"response"][@"foot"]];
             
             NSMutableArray *dataquestionArray=[HWMusicquestionListModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"selectmoodule"]];
             [dataquestionArray insertObject:headerModel atIndex:0];
//             [dataquestionArray addObject:footModel];
             
             MusicListVC.questionDataArray=dataquestionArray;
             MusicListVC.relevanceId      = dic[@"response"][@"questionlogId"];
             [self.navigationController pushViewController:MusicListVC animated:YES];
             
         }else
         {
           [self showHint:@"无法构建题库"];
         }
     } failBlock:^(NSError *error)
     {
          [self hideHud];
          [self showHint:@"请检查你的网络"];
    }];

    
    
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
