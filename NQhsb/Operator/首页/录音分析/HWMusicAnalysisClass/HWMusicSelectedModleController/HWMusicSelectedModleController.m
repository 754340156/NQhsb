//
//  HWMusicSelectedModleController.m
//  Operator
//
//  Created by NeiQuan on 16/10/17.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWMusicSelectedModleController.h"
#import "HWMusicAnalysicModel.h"
#import "HWMusicMSSelectedController.h"
#import "HWMusicSelectedCell.h" //自定义cell
@interface HWMusicSelectedModleController ()<UITableViewDelegate,UITableViewDataSource>

{
        
        UITableView         *_tableView;
        UIButton            *_footButton;
        NSMutableArray      *_dataListArray;
        NSInteger           _pageIndex;
        UITextField          *_titleTextField;//用于选择模板的标题
        NSMutableArray        *_selectedArray;
}
@end

@implementation HWMusicSelectedModleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text=@"录音分析模板选择";
    [self addsubViews];
}
#pragma mark --添加子视图
-(void)addsubViews
{
    _dataListArray =[[NSMutableArray alloc] init];
    _selectedArray=[[NSMutableArray alloc] init];
    [self addTableView];
    [self addtitleTextField];//添加标题
    [self addfootView];
}
-(void)addTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+30, WIDTH, HEIGHT-64-40-30) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    _tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex =1;
        [self loadMusicListData:_pageIndex];
    }];
    _tableView.tableFooterView=[[UIView alloc] init];
    [_tableView.mj_header beginRefreshing];
    [self.view addSubview:_tableView];
    
}
#pragma mark --添加标题栏
-(void)addtitleTextField
{
    _titleTextField=[[UITextField alloc] initWithFrame:CGRectMake(5, 64, WIDTH-10, 30)];
    _titleTextField.borderStyle= UITextBorderStyleRoundedRect;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
    //attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12]; // 设置font
    attrs[NSForegroundColorAttributeName] = KTabBarColor;// 设置颜色
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"输入标题" attributes:attrs]; // 初始化富文本占位字符串
    _titleTextField.attributedPlaceholder = attStr;
    [self.view addSubview:_titleTextField];
    
}
-(void)addfootView
{
    _footButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_footButton setFrame:CGRectMake(20, HEIGHT-64-35, WIDTH-40, 35)];
    [_footButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_footButton setBackgroundColor:KTabBarColor];
    _footButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [_footButton setTitle:@"确定" forState:UIControlStateNormal];
    [_footButton addTarget:self action:@selector(pushtoMSVC) forControlEvents:UIControlEventTouchUpInside];
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
    
    HWMusicSelectedCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HWMusicSelectedCell"];
    
    if (cell==nil)
    {
        cell=[[HWMusicSelectedCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"HWMusicSelectedCell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    HWMusicAnalysicListModel  *model=_dataListArray[indexPath.row];
    if (indexPath.row==0)//默认选中神马的-->
    {
        cell.textLabel.text=model.title;
        cell.moduleTable.text=@"默认选中";
        [cell.rightImageView setImage:[UIImage imageNamed:@"ICON_YES"]];
       
    }else
    {
        cell.textLabel.text=model.title;
        cell.moduleTable.text=@"";
        if (model.Haveselected ==YES)
        {
            [cell.rightImageView setImage:[UIImage imageNamed:@"ICON_YES"]];
        }else
        {
            [cell.rightImageView setImage:[UIImage imageNamed:@"ICON_NO"]];
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 46;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     HWMusicAnalysicListModel  *model=_dataListArray[indexPath.row];
     model.Haveselected=!model.Haveselected;
     [_tableView reloadData];
    
}
-(void)pushtoMSVC
{
    [_selectedArray removeAllObjects];//每次返回移除
    [_titleTextField resignFirstResponder];
    if (_titleTextField.text.length==0)
    {
        [self showHint:@"标题不能为空"];
        return;
    }
    HWMusicMSSelectedController *MSVC=[[HWMusicMSSelectedController  alloc] init];
    for (NSInteger indexM=0; indexM<_dataListArray.count; indexM++)//循环遍历
    {
        HWMusicAnalysicListModel  *model=_dataListArray[indexM];
        if (indexM==0)  [_selectedArray addObject:model];
        if (model.Haveselected==YES)[_selectedArray addObject:model];
    }
    
    MSVC.hidesBottomBarWhenPushed=YES;
    MSVC.datalistArray=_selectedArray;
    [self.navigationController pushViewController:MSVC animated:YES];
    
}
#pragma mark --分页加载网络数据-->模板神马的-->分页问题依然存在
-(void)loadMusicListData:(NSInteger )pageIndex
{
 
    // question/list.do
    NSDictionary *parameters=@{@"account":[UserInfo account].account,
                               @"pageSize":@"10",
                               @"pageIndex":@(pageIndex),
                               @"token":[UserInfo account].token};
    [NetWorkHelp  netWorkWithURLString:Musicmoodulelist parameters:parameters SuccessBlock:^(NSDictionary *dic)
     {
         if ([dic[@"code"]integerValue]==0)
         {
             //后期要加入判断是否有分页 
          _dataListArray=[HWMusicAnalysicListModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"moodule"][@"list"]];
             [_tableView reloadData];
             [_tableView.mj_header endRefreshing];
             [_tableView.mj_footer endRefreshing];
         }
     } failBlock:^(NSError *error)
     {
         
     }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
