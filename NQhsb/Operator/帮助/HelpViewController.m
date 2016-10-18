//
//  HelpViewController.m
//  Operator
//
//  Created by 白小田 on 16/9/22.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HelpViewController.h"
#import "HWAboutViewController.h"//关于
#import "HWPhoneViewController.h"//联系方式
static NSString *kBxtCell = @"cell";

@interface HelpViewController ()<UITableViewDelegate,UITableViewDataSource>

kBxtPropertyStrong UITableView *myTableview;

kBxtPropertyStrong NSMutableArray *kBxtTitleArr;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftBackImage.hidden=YES;
    self.titleLabel.text = @"帮助";
    [self kBxtTitleArr];
    [self myTableview];
}
-(NSMutableArray *)kBxtTitleArr
{
    if (!_kBxtTitleArr) {
        _kBxtTitleArr = [NSMutableArray arrayWithObjects:@"关于我们",@"使用帮助",@"联系客服",@"用户反馈", nil];
    }
    return _kBxtTitleArr;
}
-(UITableView *)myTableview
{
    if (!_myTableview) {
        _myTableview = [[UITableView alloc] init];
        _myTableview.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
        _myTableview.delegate = self;
        _myTableview.dataSource = self;
        [self.view addSubview:_myTableview];
    }
    return _myTableview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _kBxtTitleArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBxtCell];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBxtCell];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _kBxtTitleArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            HWAboutViewController  *aboutVC=[[HWAboutViewController alloc] init];
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:aboutVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
            
        }
            break;
        case 1://使用帮助应该需要H5--->
        {
            HWAboutViewController  *aboutVC=[[HWAboutViewController alloc] init];
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:aboutVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 2:
        {
            HWPhoneViewController  *phoneVC=[[HWPhoneViewController alloc] init];
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:phoneVC animated:YES];
             self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 3: //意见反馈-->目前还没有找到接口
        {
            
        }
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
