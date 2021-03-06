//
//  MyStyleViewController.m
//  Operator
//
//  Created by 白小田 on 16/9/22.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "MyStyleViewController.h"
#import "MySettingViewController.h"
#import "CSAnimationView.h"
#import "HWReSetKeyViewController.h" //修改密码
#import "YWWeakSelfInfoViewController.h" //编辑个人信息
#import "HWSelfintegralController.h" //我的积分
#import "HWReChargeController.h" //会员充值
#import "UpdateUserInfo.h"

static NSString *kBxtCell = @"cell";

@interface MyStyleViewController ()<UITableViewDelegate,UITableViewDataSource>

kBxtPropertyStrong UITableView *myTableview;

kBxtPropertyStrong NSMutableArray *kBxtTitleArr;

kBxtPropertyStrong UIView *kBxtHeadView;

kBxtPropertyStrong UIButton *kBxtHeadImageBtn;

kBxtPropertyStrong UILabel *kBxtMyNameLabel;

kBxtPropertyStrong CSAnimationView *animationView;

@end

@implementation MyStyleViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //每次视图出现都会请求一次数据
    [self loadSelfInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.titleLabel.text = @"我的";
    self.navigationBarBackground.hidden = YES;
    self.view.backgroundColor = BXT_BACKGROUND_COLOR;
    [self kBxtTitleArr];
    [self myTableview];
    [self kBxtHeadView];
}
-(NSMutableArray *)kBxtTitleArr
{
    if (!_kBxtTitleArr) {
        _kBxtTitleArr = [NSMutableArray arrayWithObjects:@"会员充值",@"我的积分",@"修改密码",@"设置", nil];
    }
    return _kBxtTitleArr;
}
-(UIView *)kBxtHeadView
{
    if (!_kBxtHeadView) {
        _kBxtHeadView = [[UIView alloc] init];
        _kBxtHeadView.frame = CGRectMake(0, 0, WIDTH, 170);
        _kBxtHeadView.backgroundColor = _myTableview.backgroundColor;
        
        _kBxtHeadImageBtn = [[UIButton alloc] init];
        _kBxtHeadImageBtn.frame = CGRectMake(WIDTH/2-30, _kBxtHeadView.height/2-30, 60, 60);
        [_kBxtHeadImageBtn addTarget:self action:@selector(pushtoWeakselfInfo) forControlEvents:UIControlEventTouchUpInside];
        _kBxtHeadImageBtn.backgroundColor = KTabBarColor;
        _kBxtHeadImageBtn.layer.masksToBounds = YES;
        _kBxtHeadImageBtn.layer.cornerRadius  = _kBxtHeadImageBtn.width/2;
        [_kBxtHeadView addSubview:_kBxtHeadImageBtn];
        
        [_kBxtHeadView addSubview:_kBxtHeadImageBtn];
        _kBxtMyNameLabel = [[UILabel alloc] init];
        _kBxtMyNameLabel.frame = CGRectMake(0, _kBxtHeadImageBtn.bottom+5, WIDTH, 20);
        _kBxtMyNameLabel.text = @"会员名称";
        _kBxtMyNameLabel.font = FontOfSize(14);
        _kBxtMyNameLabel.textAlignment = NSTextAlignmentCenter;
        [_kBxtHeadView addSubview:_kBxtMyNameLabel];
        _myTableview.tableHeaderView = _kBxtHeadView;
    }
    return _kBxtHeadView;
}
-(UITableView *)myTableview
{
    if (!_myTableview) {
        _myTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-49) style:UITableViewStylePlain];
        _myTableview.tableFooterView = [[UIView alloc] init];
        _myTableview.backgroundColor = BXT_BACKGROUND_COLOR;
        _myTableview.delegate = self;
        _myTableview.dataSource = self;
        [self.view addSubview:_myTableview];
    }
    return _myTableview;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kBxtCell];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _kBxtTitleArr[indexPath.row];
    cell.detailTextLabel.textColor = KTabBarColor;
    cell.detailTextLabel.font=[UIFont systemFontOfSize:13];
        switch (indexPath.row)
        {
            case 0:
                cell.detailTextLabel.text=[NSString stringWithFormat:@"还可以使用%@天",[UpdateUserInfo intervalSinceNow:[UserInfo account].expireTime]];
                NSLog(@"231%@",[UserInfo account].expireTime);
              
                break;
            case 1:
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@积分",[UserInfo account].integral?[UserInfo account].integral:@"0"];
                 NSLog(@"231%@",[UserInfo account].integral);
                break;
                
            default:
                break;
        }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            HWReChargeController  *ReChargeVC=[[HWReChargeController alloc] init];
            [self.navigationController pushViewController:ReChargeVC animated:YES];
        }
            break;
        case 1:{
            HWSelfintegralController *integralVC=[[HWSelfintegralController alloc] init];
            [self.navigationController pushViewController:integralVC animated:YES];
        }
            break;
        case 2:
        {
            HWReSetKeyViewController  *resetKey=[[HWReSetKeyViewController alloc] init];
            resetKey.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:resetKey animated:YES];
        }
            break;
        case 3:
        {
            MySettingViewController *mySetting = [[MySettingViewController alloc] init];
            mySetting.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:mySetting animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark --编辑用户信息
-(void)pushtoWeakselfInfo
{
    UIStoryboard *Storyboard=[UIStoryboard storyboardWithName:@"YWWeakSelfInfoStoryboard" bundle:nil];
    YWWeakSelfInfoViewController *Info=[Storyboard instantiateViewControllerWithIdentifier:@"YWWeakSelfMessage"];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:Info animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --获取用户的信息
-(void)loadSelfInfo
{
    NSDictionary *parameters=@{@"account":[UserInfo account].account,
                               @"token":[UserInfo account].token};
    
    [NetWorkHelp  netWorkWithURLString:getUserData parameters:parameters SuccessBlock:^(NSDictionary *dic)
     {
         [self hideHud];
         if ([dic[@"code"]integerValue]==0)
         {
             
             XBAccessLoginTokenResult *result = [XBAccessLoginTokenResult mj_objectWithKeyValues:dic[@"response"][@"user"]];
             [UserInfo saveAccount:result];
             _kBxtMyNameLabel.text=dic[@"response"][@"user"][@"nickname"];
             
             [_kBxtHeadImageBtn sd_setImageWithURL:[NSURL URLWithString:dic[@"response"][@"user"][@"headpic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"MINE_ICON_Unselected"]];
             [self.myTableview reloadData];
         }else
         {
             [self showHint:dic[@"errorMessage"]];
             
         }
     } failBlock:^(NSError *error)
     {
         [self hideHud];
         [self showHint:@"网络连接失败"];
     }];

    
    
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    [_animationView startCanvasAnimation];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
