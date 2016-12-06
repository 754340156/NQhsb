//
//  HWMusicMyVideoSearchVC.m
//  Operator
//
//  Created by NeiQuan on 16/10/25.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWMusicMyVideoSearchVC.h"
#import "HWMusicSelectedCell.h"
#import "HWMusicSelectedModleController.h"   //选择模板
#import "HWMusicAnalysicModel.h"
@interface HWMusicMyVideoSearchVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    
    UITableView         *_tableView;
    
    UIView              *_footBottomView;
    UIButton            *_footButton;
    UIButton            *_nextButton;//下一步
    
    
    NSMutableArray      *_dataListArray;
    NSInteger           _pageIndex;
    NSInteger         _selectedIndexpath;//选中的题库
    UITextField        *_textField;//搜索框
}


@end

@implementation HWMusicMyVideoSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text=@"请搜索你的录音";
    [self addsubViews];//添加子对象视图
}
#pragma mark --添加子视图
-(void)addsubViews
{
    _selectedIndexpath=-1;
    _dataListArray =[[NSMutableArray alloc] init];
    [self addSearchHeaderView];//添加搜索headerView
    [self addTableView];
    [self addfootView];
}
#pragma mark --添加搜索框
-(void)addSearchHeaderView
{
    _textField = [[UITextField alloc] init];
    _textField.frame = CGRectMake(10, 66, WIDTH-20, 34);
    _textField.backgroundColor = BXT_BACKGROUND_COLOR;
    _textField.layer.masksToBounds = YES;
    _textField.layer.cornerRadius  = 15;
    _textField.returnKeyType=UIReturnKeySearch;
    _textField.placeholder = @"  输入关键词";
    _textField.delegate = self;
    [self.view addSubview:_textField];
}

-(void)addTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 100, WIDTH, HEIGHT-100-50) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageIndex =1;
        [self loadMyVideoData:_pageIndex];
    }];
    _tableView.tableFooterView=[[UIView alloc] init];
    [_tableView.mj_header beginRefreshing];
    [self.view addSubview:_tableView];
    
}
-(void)addfootView
{
    __weak typeof(self)weakself=self;
    _footBottomView=[[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-64-35,  WIDTH, 55)];
    [_footBottomView setBackgroundColor:[UIColor clearColor]];
    
    _footButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_footButton setFrame:CGRectMake(20,3, (WIDTH-50)*0.5, 45)];
    [_footButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_footButton setBackgroundColor:KTabBarColor];
    _footButton.titleLabel.font=[UIFont systemFontOfSize:14];
    _footButton.layer.masksToBounds = YES;
    _footButton.layer.cornerRadius  = 3;
    [_footButton setTitle:@"跳过" forState:UIControlStateNormal];
    
    
    _nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setFrame:CGRectMake(WIDTH-(WIDTH-50)*0.5-20,3, (WIDTH-50)*0.5, 45)];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextButton setBackgroundColor:KTabBarColor];
    _nextButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    _nextButton.layer.masksToBounds = YES;
    _nextButton.layer.cornerRadius  = 3;
    [_footBottomView  addSubview:_footButton];
    [_footBottomView  addSubview:_nextButton];
    
    [_footButton addTarget:weakself action:@selector(selectedVideoControllerPushtoModuleConmtroller:) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton addTarget:weakself action:@selector(selectedVideoControllerPushtoModuleConmtroller:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:_footBottomView];
    
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
    
    HWMusicAnalysicVideoModel *model=_dataListArray[indexPath.row];
    cell.textLabel.text=model.title.length>0?model.title:@"后台添加没有字段";
    if (_selectedIndexpath==indexPath.row)
    {
        [cell.rightImageView setImage:[UIImage imageNamed:@"ICON_YES"]];
    }else
    {
        [cell.rightImageView setImage:[UIImage imageNamed:@"ICON_NO"]];
    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}
#pragma mark --点击单元格更新列表
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexpath=indexPath.row;
    [_tableView reloadData];
    
}
#pragma mark --textFielddeledate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];//键盘消失
        _pageIndex=0;
        [self loadMyVideoData:_pageIndex];
        return NO;
    }
    return YES;
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    [_textField resignFirstResponder];//视图滑动,键盘消失
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --跳转到根据模板生成
-(void)selectedVideoControllerPushtoModuleConmtroller:(UIButton *)sender
{
    
    HWMusicSelectedModleController *SelectedModuleVc=[[HWMusicSelectedModleController alloc] init];
    if (sender==_footButton) //跳过
    {
        SelectedModuleVc.releatedId=@"";//预防空指针 -->置为空
    }else//下一步
    {
        if (_selectedIndexpath==-1)
        {
            [self showHint:@"请选择录音"];
            return;
        }else
        {
            HWMusicAnalysicVideoModel *model=_dataListArray[_selectedIndexpath];
            SelectedModuleVc.releatedId=model.dataId;
        }
    }
    SelectedModuleVc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:SelectedModuleVc animated:YES];
    
    
}
#pragma mark --加载我的
-(void)loadMyVideoData:(NSInteger )page
{
    /*
     参数	account	[必选]用户ID
     type	[必选]类型3话术本,5我的录音
     wordsType	话术本类型1文字2图片3语音
     keywords	关键字
     // -->现在需要添加测试数据
     */
    _selectedIndexpath=-1;//防止二次刷新
    [self showHudInView:self.view hint:@""];
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                                 @"type":@"3",
                                 @"wordsType":@"1",
                                 @"pageIndex":@(page),
                                 @"pageSize":@"10",
                                 @"keywords":_textField.text
                                 };
    [NetWorkHelp netWorkWithURLString:listOfMe
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             [self hideHud];
                             if ([dic[@"code"] intValue] == 0)
                             {
                                 _dataListArray=[HWMusicAnalysicVideoModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"list"]];
                                 
                             }else
                             {
                                 [self showHint:dic[@"errorMessage"]];
                             }
                             [_tableView reloadData];
                             [_tableView.mj_footer endRefreshing];
                             [_tableView.mj_header endRefreshing];
                             
                         } failBlock:^(NSError *error)
    
                        {    [self hideHud];
                             [self showHint:@"网络连接错误"];
                             
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
