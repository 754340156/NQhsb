//
//  BigForumViewController.m
//  Operator
//
//  Created by 白小田 on 16/9/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "BigForumViewController.h"
#import "SalesjobViewController.h"

@interface BigForumViewController ()

kBxtPropertyStrong UIButton *kBxtBigForumOne;

kBxtPropertyStrong UIButton *kBxtBigForumTwo;

@end

@implementation BigForumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"大讲堂";
    [self createUI];
}
-(void)createUI
{
    _kBxtBigForumOne = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, WIDTH, (HEIGHT-64)/2-5)];
    [_kBxtBigForumOne setBackgroundImage:[UIImage imageNamed:@"销售职"] forState:UIControlStateNormal];
    [_kBxtBigForumOne setBackgroundImage:[UIImage imageNamed:@"销售职"] forState:UIControlStateSelected];
    [_kBxtBigForumOne addTarget:self action:@selector(kBxtBigForumOneClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_kBxtBigForumOne];
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, _kBxtBigForumOne.bottom, WIDTH, 10)];
    centerView.backgroundColor = [UIColor colorWithRed:0.8916 green:0.8916 blue:0.8916 alpha:1.0];
    [self.view addSubview:centerView];
    
    _kBxtBigForumTwo = [[UIButton alloc] initWithFrame:CGRectMake(0, centerView.bottom, WIDTH, _kBxtBigForumOne.height)];
    [_kBxtBigForumTwo setBackgroundImage:[UIImage imageNamed:@"管理职"] forState:UIControlStateNormal];
     [_kBxtBigForumTwo setBackgroundImage:[UIImage imageNamed:@"管理职"] forState:UIControlStateSelected];
    [_kBxtBigForumTwo addTarget:self action:@selector(kBxtBigForumTwoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_kBxtBigForumTwo];
    
}
//销售职
-(void)kBxtBigForumOneClick
{
    SalesjobViewController *seles = [[SalesjobViewController alloc] init];
    seles.selectType = @"1";
    seles.selectTitleType = @"销售职";
    [self.navigationController pushViewController:seles animated:YES];
}
//管理职
-(void)kBxtBigForumTwoClick
{
    SalesjobViewController *seles = [[SalesjobViewController alloc] init];
    seles.selectType = @"2";
    seles.selectTitleType = @"管理职";
    [self.navigationController pushViewController:seles animated:YES];
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
