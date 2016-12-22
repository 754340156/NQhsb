//
//  MySettingViewController.m
//  Operator
//
//  Created by 白小田 on 16/9/23.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "MySettingViewController.h"

static NSString *kBxtCell = @"cell";

@interface MySettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

kBxtPropertyStrong UITableView *myTableview;

kBxtPropertyStrong NSMutableArray *kBxtTitleArr;

@end

@implementation MySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"设置";
    [self.view setBackgroundColor:BXT_BACKGROUND_COLOR];
    [self kBxtTitleArr];
    [self.view addSubview:self.myTableview];
    [self addFootView];
}
#pragma mark --添加退出登录按钮
-(void)addFootView
{
    __weak typeof(self)weakself=self;
    UIButton  *layoutButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [layoutButton setFrame:CGRectMake(0, self.view.height-150, WIDTH, 45)];
    [layoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [layoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [layoutButton addTarget:weakself action:@selector(uerLayout) forControlEvents:UIControlEventTouchUpInside];
    [layoutButton setBackgroundColor:KTabBarColor];
    [self.view addSubview: layoutButton];
    
}
-(NSMutableArray *)kBxtTitleArr
{
    if (!_kBxtTitleArr) {
        _kBxtTitleArr = [NSMutableArray arrayWithObjects:@"清理缓存",@"推送", nil];
    }
    return _kBxtTitleArr;
}
-(UITableView *)myTableview
{
    if (!_myTableview) {
        _myTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 44*2)];
        _myTableview.delegate = self;
        _myTableview.dataSource = self;
        _myTableview.rowHeight = 44;
        _myTableview.tableFooterView=[[UIView alloc] init];
        _myTableview.scrollEnabled=NO;
     
    }
    return _myTableview;
}
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBxtCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kBxtCell];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _kBxtTitleArr[indexPath.row];
    if(indexPath.row == 0)
    {
        [self cellCleanCacheTextLabel:cell];
    }
    if (indexPath.row == 1) {
        [self cellBtnAddOrCell:cell];
    }
    return cell;
}
//缓存
-(void)cellCleanCacheTextLabel:(UITableViewCell *)cell
{
    float tmpSize = [[SDImageCache sharedImageCache] getSize];
    NSString *clearCacheName = tmpSize >= 1 ?
    [NSString stringWithFormat:@"%.2fM",tmpSize / 100000]:
    [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
    UILabel *kCleanCacheLb = [[UILabel alloc] init];
    kCleanCacheLb.text = clearCacheName;
    kCleanCacheLb.textColor = color_333333;
    kCleanCacheLb.font = FontOfSize(12);
    [cell.contentView addSubview:kCleanCacheLb];
    [kCleanCacheLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(50, 27));
        make.centerY.equalTo(cell.mas_centerY);
        make.right.offset(-15);
    }];
}

//推送开关
-(void)cellBtnAddOrCell:(UITableViewCell *)cell
{
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
#warning 默认推送开着
    [pushBtn setImage:[UIImage imageNamed:@"icon_kai"] forState:UIControlStateNormal];
    [pushBtn setImage:[UIImage imageNamed:@"icon_guan"] forState:UIControlStateSelected];
    [pushBtn addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:pushBtn];
    [pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(54, 27));
        make.centerY.equalTo(cell.mas_centerY);
        make.right.offset(-20);
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"清除缓存", @"clear cache") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"Cancel")otherButtonTitles:NSLocalizedString(@"确定", @"OK"), nil];
        [alert setTag:100];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[SDImageCache sharedImageCache] clearMemory];
        DLog(@"clear disk");
        float tmpSize = [[SDImageCache sharedImageCache] getSize];
        NSString *clearCacheName = tmpSize >= 1 ?
        [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize / 100000] :
        [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
        [self showHint:[NSString stringWithFormat:@"%@成功",clearCacheName]];
        [[SDImageCache sharedImageCache] clearDisk];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [_myTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}
#pragma mark - target
- (void)pushAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (!sender.selected) {
        DLog(@"去打开推送");
    }else
    {
        DLog(@"去关闭推送");
    }
}
#pragma mark - 用户退出登录
-(void)uerLayout
{
    NSDictionary *parameters=@{@"account":[UserInfo account].account};
    [self showHudInView:self.view hint:@""];
    [NetWorkHelp  netWorkWithURLString:Userlogout parameters:parameters SuccessBlock:^(NSDictionary *dic)
     {
         [self hideHud];
         if ([dic[@"code"]integerValue]==0)
         {
             //删除
             [UserInfo removeAllcount];
             LoginViewController *login = [[LoginViewController alloc] init];
             HWNavigationController *loginNav = [[HWNavigationController alloc] initWithRootViewController:login];
             [MainWindow setRootViewController:loginNav];
             
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

@end
