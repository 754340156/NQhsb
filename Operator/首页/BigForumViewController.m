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

kBxtPropertyStrong UIView   *kHeadView;

kBxtPropertyStrong UIView   *kFootView;

kBxtPropertyStrong UIView   *centerView;

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
    self.kHeadView = [[UIView alloc] init];
    _kHeadView.frame = CGRectMake(0, 64, WIDTH, (HEIGHT-64)/2-5);
    [_kHeadView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_kHeadView];
    
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, _kHeadView.bottom, WIDTH, 10)];
    _centerView.backgroundColor = [UIColor colorWithRed:0.8916 green:0.8916 blue:0.8916 alpha:1.0];
    [self.view addSubview:_centerView];
    
    self.kFootView = [[UIView alloc] init];
    [_kFootView setFrame:CGRectMake(0, _centerView.bottom, WIDTH, HEIGHT-_centerView.bottom)];
    [_kFootView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_kFootView];
    
    _kBxtBigForumOne = [[UIButton alloc] initWithFrame:CGRectMake(40, 30, _kHeadView.width-80, _kHeadView.height-60)];
    [_kBxtBigForumOne.layer setMasksToBounds:YES];
    [_kBxtBigForumOne.layer setShadowRadius:1];
    [_kBxtBigForumOne.layer setShadowColor:[UIColor blackColor].CGColor];
    [_kBxtBigForumOne setBackgroundImage:[UIImage imageNamed:@"xiaoshouzhi"] forState:UIControlStateNormal];
    [_kBxtBigForumOne setBackgroundImage:[UIImage imageNamed:@"xiaoshouzhi"] forState:UIControlStateSelected];
    [_kBxtBigForumOne addTarget:self action:@selector(kBxtBigForumOneClick) forControlEvents:UIControlEventTouchUpInside];
    [_kHeadView addSubview:_kBxtBigForumOne];
    
    _kBxtBigForumTwo = [[UIButton alloc] initWithFrame:CGRectMake(40, 30, _kFootView.width-80, _kFootView.height-60)];
    [_kBxtBigForumTwo.layer setMasksToBounds:YES];
    [_kBxtBigForumTwo.layer setShadowRadius:1];
    [_kBxtBigForumTwo.layer setShadowColor:[UIColor blackColor].CGColor];
    [_kBxtBigForumTwo setBackgroundImage:[UIImage imageNamed:@"guanlizhi"] forState:UIControlStateNormal];
     [_kBxtBigForumTwo setBackgroundImage:[UIImage imageNamed:@"guanlizhi"] forState:UIControlStateSelected];
    [_kBxtBigForumTwo addTarget:self action:@selector(kBxtBigForumTwoClick) forControlEvents:UIControlEventTouchUpInside];
    [_kFootView addSubview:_kBxtBigForumTwo];
    
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
