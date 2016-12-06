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
@interface HWMusicAnswerController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView   *_tableView;
    UIButton      *_footbutton;
    NSMutableDictionary *accessoryDic;
    UITextField   *_addTextFiled;
}
@end

@implementation HWMusicAnswerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text=@"开场";
    accessoryDic = [NSMutableDictionary dictionaryWithCapacity:0];
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
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-60) style:UITableViewStyleGrouped];
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
    [_footbutton setFrame:CGRectMake(20, HEIGHT-55, WIDTH-40, 45)];
    [_footbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_footbutton setBackgroundColor:KTabBarColor];
    _footbutton.titleLabel.font=[UIFont systemFontOfSize:14];
    [_footbutton setTitle:@"提交" forState:UIControlStateNormal];
    _footbutton.layer.masksToBounds = YES;
    _footbutton.layer.cornerRadius  = 3;
    [_footbutton addTarget:weakself action:@selector(postanswerData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_footbutton];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return _dataListArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    HWMusicquestionBankModel *model=_dataListArray[section];
    NSArray *tworowsArray=[model.content componentsSeparatedByString:@"#"];
    return tworowsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HWMusicAnswerTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HWMusicAnswerTableViewCell class])];
    
    if (cell==nil)
    {
        cell=[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HWMusicAnswerTableViewCell class]) owner:self options:nil][0];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.rightImageView setImage:[UIImage imageNamed:@"ICON_NO"]];
    
    HWMusicquestionBankModel *model=_dataListArray[indexPath.section];
    [self getIsSelectReturn:model tableCell:cell indexPath:indexPath];
    [self getIsCacheReturn:model tableCell:cell indexPath:indexPath];
    [self getIsFillingReturn:model tableCell:cell indexPath:indexPath];
    NSArray *tworowsArray=[model.content componentsSeparatedByString:@"#"];
    cell.titleLable.text=[NSString stringWithFormat:@"%@",tworowsArray[indexPath.row]];
    return cell;
    
}
#pragma mark -- 判断是否已选择此题
-(void)getIsSelectReturn:(HWMusicquestionBankModel *)model tableCell:(HWMusicAnswerTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    NSString *key = [accessoryDic objectForKey:model.dataId];
    NSArray *arr = [key componentsSeparatedByString:@","];
    for (NSString *object in accessoryDic) {
        if ([object isEqualToString:model.dataId]) {
            for (NSString *str in arr) {
                if ([str intValue]-1 == indexPath.row) {
                    [cell.rightImageView setImage:[UIImage imageNamed:@"ICON_YES"]];
                }
            }
        }
    }
}
#pragma mark -- 判断是否为缓存题
-(void)getIsCacheReturn:(HWMusicquestionBankModel *)model tableCell:(HWMusicAnswerTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (![model.uanswer isEqualToString:@""] && indexPath.row == [model.uanswer intValue]-1) {
        [cell.rightImageView setImage:[UIImage imageNamed:@"ICON_YES"]];
        [accessoryDic setObject:model.uanswer forKey:model.dataId];
        [self isDeletePushBtn:YES];
    }
}
#pragma mark -- 填空题
-(void)getIsFillingReturn:(HWMusicquestionBankModel *)model tableCell:(HWMusicAnswerTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if ([model.type isEqualToString:@"0"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        _addTextFiled = [[UITextField alloc] init];
        _addTextFiled.frame =    CGRectMake(10, 10, WIDTH-20, 40);
        _addTextFiled.tag   =    indexPath.section+100;
        _addTextFiled.delegate = self;
        _addTextFiled.layer.masksToBounds = YES;
        _addTextFiled.layer.borderWidth   = 0.6;
        _addTextFiled.layer.cornerRadius  = 3;
        _addTextFiled.layer.borderColor = [UIColor colorWithWhite:0.699 alpha:1.000].CGColor;
        [cell.contentView addSubview:_addTextFiled];
        if(![model.uanswer isEqualToString:@""])_addTextFiled.text = model.uanswer;
        [cell.rightImageView setHidden:YES];
    }
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
    }else
    {
        titleLable.text=[NSString stringWithFormat:@"%@.填空",model.indexs];
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
    NSArray *rowsArray=[model.content componentsSeparatedByString:@"#"];
    NSString *string=rowsArray[indexPath.row];
    if ([model.type isEqualToString:@"0"]){
        return 60;
    }
    return [NSString sizeWithString:string font:[UIFont systemFontOfSize:14] constrainedToWidth:WIDTH-35].height+20;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text){
        HWMusicquestionBankModel *model=_dataListArray[textField.tag-100];
        [accessoryDic setObject:textField.text forKey:model.dataId];
    }
}
#pragma mark --点击单元格做题事件的监听
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogApi(@" didSelect accessory  %ld %ld",indexPath.section,indexPath.row);
    HWMusicquestionBankModel *model=_dataListArray[indexPath.section];
    
    if (![model.uanswer isEqualToString:@""]) {
        DLog(@"不可更改状态");
    }else{
        if ([model.type isEqualToString:@"1"])//题类型0填空题1单选2多选
        
        {//单选
            [accessoryDic removeObjectForKey:model.dataId];
            [accessoryDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+1]
                             forKey:model.dataId];
            
            
        }else if ([model.type isEqualToString:@"2"])
        {//多选
           NSString *key = [accessoryDic objectForKey:model.dataId];
            if (key) {
                [accessoryDic setObject:[NSString stringWithFormat:@"%@,%ld",key,indexPath.row+1] forKey:model.dataId];
                //重复删除
                NSArray *arr = [key componentsSeparatedByString:@","];
                for (NSString *str in arr) {
                    if ([str intValue]-1 == indexPath.row) {
                        NSMutableArray *mutabarr = [NSMutableArray arrayWithArray:arr];
                        [mutabarr removeObject:str];
                        NSString *strTwo = [mutabarr componentsJoinedByString:@","];
                        [accessoryDic setObject:strTwo forKey:model.dataId];
                    }
                }
            }else{
                //添加多选
                [accessoryDic setObject:[NSString stringWithFormat:@"%ld",indexPath.row+1] forKey:model.dataId];
            }
          
        }
        [_tableView reloadData];
    }
}
/**
 *  删除提交按钮
 */
-(void)isDeletePushBtn:(BOOL)isDelete
{
    if (isDelete && _footbutton){
        _tableView.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
        [_footbutton removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 答 案
#pragma mark --
//MusicquestionAddproblem
-(void)postanswerData
{
    int i = 0;
    for (NSString *str in accessoryDic) {
        LogApi(@"%@",str);
        i++;
    }
    if (i<_dataListArray.count) {
        [self showHint:@"请做完全部题目"];
    }else{
        [self showHudInView:self.view hint:@""];//relevanceId
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:accessoryDic];
        NSDictionary *parameters=@{@"account":[UserInfo account].account,
                                   @"token":[UserInfo account].token,
                                   @"answers":[dic mj_JSONString],
                                   @"mooduleId":_selectId,
                                   @"questionlogId":_questionlogId};
        [NetWorkHelp netWorkWithURLString:MusicquestionAddproblem
                               parameters:parameters
                             SuccessBlock:^(NSDictionary *dic)
         {
             if ([dic[@"code"] intValue] == 0) {
                 [self showHint:@"提交成功"];
                 [self.navigationController popViewControllerAnimated:YES];
             }else{
                 [self showHint:dic[@"errorMessage"]];
             }
             [self hideHud];
         } failBlock:^(NSError *error) {
             [self showHint:kBxtNetWorkError];
             [self hideHud];
         }];
    }
}

@end
