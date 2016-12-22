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
/**  <#注释#> */
@property (nonatomic,strong) NSMutableArray * dataArray;
/**  <#注释#> */
@property (nonatomic,strong) NSMutableArray * iconArray;
@end

@implementation HWPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.titleText;
    [self maketableView];
}
-(void)maketableView{
    
    _tableView=[[ UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = BXT_BACKGROUND_COLOR;
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
    cell.imageView.image = [UIImage imageNamed:self.iconArray[indexPath.section]];
    cell.textLabel.text = self.dataArray[indexPath.section];
    cell.textLabel.textColor=[UIColor grayColor];
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
    [view setBackgroundColor:BXT_BACKGROUND_COLOR];
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
    if (indexPath.section == 0) {
        NSString *mail = self.dataArray[indexPath.section];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",mail]]];
    }else if (indexPath.section == 1)
    {
        NSString *phoneNum = [self.dataArray[indexPath.section] substringToIndex:12];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定要拨打%@",phoneNum] message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
        [alertVC addAction:okAction];
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }
}
#pragma mark - lazy
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@"telsey@telemia.cn",@"400-850-1088(工作日10:00-18:00)"].mutableCopy;
    }
    return _dataArray;
}
- (NSMutableArray *)iconArray
{
    if (!_iconArray) {
        _iconArray = @[@"ICON_mailbox",@"ICON_Telephone"].mutableCopy;
    }
    return _iconArray;
}
@end
