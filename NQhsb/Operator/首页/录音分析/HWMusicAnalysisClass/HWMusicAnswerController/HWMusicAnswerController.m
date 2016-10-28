//
//  HWMusicAnswerController.m
//  Operator
//
//  Created by NeiQuan on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWMusicAnswerController.h"
#import "HWMusicAnswerTableViewCell.h"
#import "HWMusicAnalysicModel.h"
#import "NSString+YWExtension.h"
@interface HWMusicAnswerController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView   *_tableView;
    UIButton      *_footbutton;
    
}
@end

@implementation HWMusicAnswerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text=@"开场";
    [self addsubViews];//添加
}
#pragma mark --添加子视图
-(void)addsubViews
{
    [self addTableView];
    [self addfootView];
}
#pragma mark --set方法调用
-(void)setDataListArray:(NSMutableArray *)dataListArray
{
    _dataListArray=dataListArray;
    [_tableView reloadData];
}
-(void)addTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-40) style:UITableViewStyleGrouped];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc] init];
    _tableView.separatorColor=[UIColor clearColor];
    [_tableView.mj_header beginRefreshing];
    [self.view addSubview:_tableView];
    
}
-(void)addfootView
{
    __weak typeof(self)weakself=self;
    _footbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_footbutton setFrame:CGRectMake(20, HEIGHT-40, WIDTH-40, 35)];
    [_footbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_footbutton setBackgroundColor:KTabBarColor];
    _footbutton.titleLabel.font=[UIFont systemFontOfSize:14];
    [_footbutton setTitle:@"提交" forState:UIControlStateNormal];
    [_footbutton addTarget:weakself action:@selector(postanswerData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_footbutton];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return _dataListArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    HWMusicquestionBankModel *model=_dataListArray[section];
    NSArray *rowsArray=[model.content componentsSeparatedByString:@","];
    return rowsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HWMusicAnswerTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HWMusicAnswerTableViewCell class])];
    
    if (cell==nil)
    {
        cell=[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HWMusicAnswerTableViewCell class]) owner:self options:nil][0];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    HWMusicquestionBankModel *model=_dataListArray[indexPath.section];
    NSArray *rowsArray=[model.content componentsSeparatedByString:@","];
    cell.titleLable.text=[NSString stringWithFormat:@"%@",rowsArray[indexPath.row]];
    return cell;
    
}
#pragma mark --
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HWMusicquestionBankModel *model=_dataListArray[section];
    UIView  *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 45)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    UILabel *titleLable=[[UILabel alloc] initWithFrame:CGRectMake(3, 2, WIDTH, 21)];
    titleLable.font=[UIFont systemFontOfSize:14];
   
    
    UILabel *subLable=[[UILabel alloc] initWithFrame:CGRectMake(3, 22, WIDTH-6, 21)];
    subLable.textColor=[UIColor grayColor];
    subLable.font=[UIFont systemFontOfSize:12];
    subLable.text=[NSString stringWithFormat:@" %@",model.title];
    [headerView addSubview:titleLable];
    [headerView addSubview:subLable];
    
    if ([model.type isEqualToString:@"1"])//题类型0无答案题1单选2多选
    {
    titleLable.text=[NSString stringWithFormat:@"%@.单选",model.indexs];
        
    }else if ([model.type isEqualToString:@"2" ])
    {
        titleLable.text=[NSString stringWithFormat:@"%@.多选",model.indexs];
    }
    
    
    return headerView;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.01f)];
    
    return footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HWMusicquestionBankModel *model=_dataListArray[indexPath.section];
    NSArray *rowsArray=[model.content componentsSeparatedByString:@","];
    NSString *string=rowsArray[indexPath.row];
    return [NSString sizeWithString:string font:[UIFont systemFontOfSize:14] constrainedToWidth:WIDTH-35].height+20;
}
#pragma mark --点击单元格做题事件的监听
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --答案
//MusicquestionAddproblem
-(void)postanswerData
{
    //现在需求还不明确，无法做-->需要和安卓协调
    [self showHudInView:self.view hint:@""];
    NSDictionary *parameters=@{@"account":[UserInfo account].account,
                               @"token":[UserInfo account].token,
                               @"bankId":@"12",
                               @"answer":@"123",
                               @"mooduleId":@"22"};
    [NetWorkHelp netWorkWithURLString:MusicquestionAddproblem
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic)
    {
        
    } failBlock:^(NSError *error) {
        
    }];
    
    
    
}

@end
