//
//  AudioBookViewController.m
//  Operator
//
//  Created by 白小田 on 16/10/17.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "AudioBookViewController.h"
#import "RecentPlayViewController.h"
#import "AddAudioViewController.h"
#import "HWSearchOperationController.h"
static NSString *kBxtCell = @"cell";

@interface AudioBookViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
kBxtPropertyStrong UITableView *myTableview;
kBxtPropertyStrong NSArray *dataTitleArr;
kBxtPropertyStrong UITextField *searchTF;
@end

@implementation AudioBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"录音本";
    [self dataTitleArr];
    [self myTableview];
}
-(void)headView
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
    
    _searchTF = [[UITextField alloc] init];
    _searchTF.frame = CGRectMake(10, 10, WIDTH-20, 34);
    _searchTF.backgroundColor = BXT_BACKGROUND_COLOR;
    _searchTF.layer.masksToBounds = YES;
    _searchTF.layer.cornerRadius  = 5;
    _searchTF.placeholder = @"输入关键词";
    _searchTF.delegate = self;
    [self setTextFieldLeftPadding:_searchTF forWidth:30];
    [header addSubview:_searchTF];
    header.width = WIDTH;
    header.backgroundColor = [UIColor whiteColor];
    _myTableview.tableHeaderView = header;
}
-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(leftWidth /3, leftWidth / 3, leftWidth /2, leftWidth/ 2)];
    leftImage.image = [UIImage imageNamed:@"Button_search"];
    [leftview addSubview:leftImage];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}
#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    HWSearchOperationController *searchVC = [[HWSearchOperationController alloc] init];
    searchVC.type = @"5";
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    [textField endEditing:YES];
}
-(NSArray *)dataTitleArr
{
    if (!_dataTitleArr) {
        _dataTitleArr = @[@[@"最近播放"],@[@"我的录音",@"添加新录音"]];
    }
    return _dataTitleArr;
}
-(UITableView *)myTableview
{
    if (!_myTableview) {
        _myTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
        _myTableview.delegate = self;
        _myTableview.dataSource = self;
        [self.view addSubview:_myTableview];
        [self headView];
    }
    return _myTableview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataTitleArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataTitleArr[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBxtCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBxtCell];
    }
    cell.textLabel.text = _dataTitleArr[indexPath.section][indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                [self pushVc:@"5" api:checklist];
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                 [self pushVc:@"5" api:listOfMe];
            }else{
                AddAudioViewController *audio = [[AddAudioViewController alloc] init];
                [self.navigationController pushViewController:audio animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}
-(void)pushVc:(NSString *)type api:(NSString *)api
{
    RecentPlayViewController *recent = [[RecentPlayViewController alloc] init];
    recent.selectType = type;
    recent.api        = api;
    [self.navigationController pushViewController:recent animated:YES];
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
