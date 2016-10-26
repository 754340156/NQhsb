//
//  HWOperationTypeController.m
//  Operator
//
//  Created by hai on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWOperationTypeController.h"
#import "HWAddTextController.h"
#import "HWAddPicController.h"
#import "HWAddVoiceController.h"
@interface HWOperationTypeController ()<UITableViewDelegate,UITableViewDataSource>
/**  <#注释#> */
@property (nonatomic,strong) UITableView * tableView;
/**  <#注释#> */
@property (nonatomic,strong) NSArray * dataArray;
@end

@implementation HWOperationTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.titleText;
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {//添加文本话术
        HWAddTextController *textVC = [[HWAddTextController alloc] init];
        [self.navigationController pushViewController:textVC animated:YES];
    }else if (indexPath.row == 1)
    {//添加图片话术
        HWAddPicController *picVC = [[HWAddPicController alloc] init];
        [self.navigationController pushViewController:picVC animated:YES];
    }else if (indexPath.row == 2)
    {//添加录音话术
        HWAddVoiceController *voiceVC = [[HWAddVoiceController alloc] init];
        [self.navigationController pushViewController:voiceVC animated:YES];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"请选择类型";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
#pragma mark - lazy
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@"文本话术",@"图片话术",@"录音话术"];
    }
    return _dataArray;
}

@end
