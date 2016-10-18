//
//  HWPhoneViewController.m
//  Operator
//
//  Created by NeiQuan on 16/10/13.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWPhoneViewController.h"

@interface HWPhoneViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *_tableView;
    
}
@end

@implementation HWPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"联系客服";
    [self maketableView];
}
-(void)maketableView{
    
    _tableView=[[ UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
}
#pragma mark --tableViewdeleGAte
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Mr-yuwei"];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Mr-yuwei"];
    }
    switch (indexPath.section)
    {
        case 0:
            cell.imageView.image=[UIImage imageNamed:@"Collect_ICON_Select"];
            cell.textLabel.text=@"service@zaih.com";
            break;
        case 1:
             cell.imageView.image=[UIImage imageNamed:@"Collect_ICON_Select"];
            cell.textLabel.text=@"400-0000-0000(工作日10:00-18:00)";
            break;
            
        default:
            break;
    }
    cell.textLabel.textColor=[UIColor grayColor];
    [cell setBackgroundColor:[UIColor colorWithRed:223.0/255 green:223.0/255  blue:223.0/255  alpha:1.0]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 46;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view=[[ UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    //[view setBackgroundColor:[ UIColor myColorWithString:@"f2f2f2" ]];
    return view;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[[ UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 46)];
    [view setBackgroundColor:[ UIColor whiteColor]];
    UILabel *labl=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.width-20, 46)];
    labl.font=[UIFont systemFontOfSize:16];
    switch (section) {
        case 0:
            labl.text=@"客服邮箱";
            break;
        case 1:
            labl.text=@"客服电话";
            break;
            
        default:
            break;
    }
    [view addSubview:labl];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 46 ;
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
#pragma mark --点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
