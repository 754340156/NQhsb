//
//  HWOperationViewController.m
//  Operator
//
//  Created by hai on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWOperationViewController.h"
#import "HWSearchOperationController.h"
#import "HWOperationTypeController.h"
#import "HWOperationShowController.h"
#import "HWMyOperationController.h"
@interface HWOperationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
/**   */
@property (nonatomic,strong) UITableView * tableView;
/**   */
@property (nonatomic,strong) NSArray * dataArray;
/**  搜索框 */
@property (nonatomic,strong) UITextField * searchTF;
@end

@implementation HWOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"话术本";
    [self setTableView];
   
}
#pragma mark - setup
- (void)setTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //最近浏览或者大咖讲话术
        HWOperationShowController *operationShowVC  =[[HWOperationShowController alloc] init];

        if (indexPath.row == 0) {
            operationShowVC.selectType = @"3";
            operationShowVC.apiStr = checklist;
        }else if (indexPath.row == 1)
        {
            operationShowVC.selectType = @"4";
            operationShowVC.apiStr = recordinglist;
        }
        operationShowVC.titleText = self.dataArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:operationShowVC animated:YES];
    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            //我的话术本
            HWMyOperationController * myOperationVC = [[HWMyOperationController alloc] init];
            myOperationVC.titleText = self.dataArray[indexPath.section][indexPath.row];
            [self.navigationController pushViewController:myOperationVC animated:YES];
        }else if (indexPath.row == 1)
        {
            //添加新话术
            HWOperationTypeController *operationTypeVC = [[HWOperationTypeController alloc] init];
            operationTypeVC.titleText = self.dataArray[indexPath.section][indexPath.row];
            [self.navigationController pushViewController:operationTypeVC animated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 44;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        header.backgroundColor = [UIColor whiteColor];
        _searchTF = [[UITextField alloc] init];
        _searchTF.frame = CGRectMake(10, 5, WIDTH-20, 35);
        _searchTF.backgroundColor = BXT_BACKGROUND_COLOR;
        _searchTF.layer.masksToBounds = YES;
        _searchTF.layer.cornerRadius  = 5;
        _searchTF.placeholder = @"输入关键词";
        _searchTF.delegate = self;
        [self setTextFieldLeftPadding:_searchTF forWidth:30];
        [header addSubview:_searchTF];
        header.width = WIDTH;
        return header;
    }
        return nil;
}
#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    HWSearchOperationController *searchVC = [[HWSearchOperationController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    [textField endEditing:YES];
}
#pragma mark - tools
-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, leftWidth, leftWidth)];
    leftImage.image = [UIImage imageNamed:@"UMS_alipay_off"];
    [leftview addSubview:leftImage];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}
#pragma mark - lazy
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@[@"最近浏览",@"大咖讲话术"],@[@"我的话术本",@"添加新话术"]];
    }
    return _dataArray;
}

@end
