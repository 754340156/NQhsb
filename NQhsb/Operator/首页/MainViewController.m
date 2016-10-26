//
//  MainViewController.m
//  Operator
//
//  Created by 白小田 on 16/9/12.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "MainViewController.h"
#import "MainCell.h"
#import "MainTwoCell.h"
#import "MainSearchViewController.h"
#import "BigForumViewController.h"  //大讲堂
#import "HWOperationViewController.h" //话术本
#import "AudioBookViewController.h"   //录音本
#import "HWJobLogController.h"   //工作日志
#import "HWStudyPlanController.h"   //学习计划
#import "HWMusicAnalysisController.h" //录音分析
#import "UserInfo.h"
#import "HWHomeIndexModel.h"
static NSString *kBxtMainCell = @"MainCell";

static NSString *kBxtMainTwoCell = @"MainTwoCell";

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SDCycleScrollViewDelegate>

kBxtPropertyStrong UITableView *myTableview;

kBxtPropertyStrong NSMutableArray *dataArr;

kBxtPropertyStrong SDCycleScrollView *scrollView;

kBxtPropertyStrong NSArray *kBxtImageBannerArr;

kBxtPropertyStrong UITextField *searchTF;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"让电销变简单";
    [self.leftBackImage setHidden:YES];
    self.titleLabel.font = FontOfSize(13);
    [self myTableview];
    [_myTableview.mj_header beginRefreshing];
}
-(void)netWorkHelp
{
    NSDictionary  *parameters=@{@"account":[UserInfo account].account,
                                @"token":[UserInfo account].token};
    [NetWorkHelp  netWorkWithURLString:homePageIndex
                            parameters:parameters
                          SuccessBlock:^(NSDictionary *dic)
     {
         if ([dic[@"code"]integerValue]==0)
         {
             _kBxtImageBannerArr=[[HWHomeIndexBannerModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"banner"]] valueForKeyPath:@"bannerPic"];
             _dataArr=[HWHomeIndexModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"recommend"]];
             [self.leftBackImage setHidden:NO];
             [self.leftBackImage sd_setImageWithURL:[NSURL URLWithString:dic[@"response"][@"logo"]] placeholderImage:[UIImage imageNamed:@"ICON_Church"]];
             [_myTableview reloadData];
             [_myTableview .mj_header endRefreshing];
         }
         
     } failBlock:^(NSError *error)
     {
         [self showHint:@"请检查你的网络"];
         
     }];

    }
//数据源
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(UITableView *)myTableview
{
    if (!_myTableview) {
        _myTableview = [[UITableView alloc] init];
        _myTableview.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64-49);
        _myTableview.delegate = self;
        _myTableview.dataSource = self;
        [_myTableview registerNib:[UINib nibWithNibName:@"MainCell" bundle:nil] forCellReuseIdentifier:kBxtMainCell];
        [_myTableview registerNib:[UINib nibWithNibName:@"MainTwoCell" bundle:nil] forCellReuseIdentifier:kBxtMainTwoCell];
      
        _myTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self netWorkHelp];
        }];

        [self headView];
        [self.view addSubview:_myTableview];
        
    }
    return _myTableview;
}
-(void)headView
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60 + 200)];
    
    _searchTF = [[UITextField alloc] init];
    _searchTF.frame = CGRectMake(10, 10, WIDTH-20, 34);
    _searchTF.backgroundColor = BXT_BACKGROUND_COLOR;
    _searchTF.layer.masksToBounds = YES;
    _searchTF.layer.cornerRadius  = 15;
    _searchTF.placeholder = @"输入关键词";
    _searchTF.delegate = self;
    [self setTextFieldLeftPadding:_searchTF forWidth:40];
    [header addSubview:_searchTF];
    header.width = WIDTH;
    
    _scrollView = [SDCycleScrollView  cycleScrollViewWithFrame:CGRectMake(0, _searchTF.bottom+10, WIDTH, 200) delegate:self placeholderImage:[UIImage imageNamed:@"BJ_BANNER"]];
    _scrollView.imageURLStringsGroup = _kBxtImageBannerArr;
    [header addSubview:_scrollView];
    _myTableview.tableHeaderView = header;
}
-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(leftWidth/ 2, leftWidth/5, leftWidth /2.5, leftWidth /2.5)];
    leftImage.image = [UIImage imageNamed:@"Button_search"];
    [leftview addSubview:leftImage];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}
#pragma makr - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
#warning 点击图片回调
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 200;
    }else{
        return 231;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MainCell *cell = [tableView dequeueReusableCellWithIdentifier:kBxtMainCell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.kBxtBigForum addTarget:self       action:@selector(kBxtBigForumClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.kBxtOperation addTarget:self      action:@selector(kBxtOperationClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.kBxtRecording addTarget:self      action:@selector(kBxtRecordingClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.kBxtJobLog addTarget:self         action:@selector(kBxtJobLogClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.kBxtLearningPlan addTarget:self   action:@selector(kBxtStudyPlanClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.kBxtMusicAnalysis addTarget:self  action:@selector(kBxtMusicAnalysisClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        MainTwoCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:kBxtMainTwoCell];
        if (_dataArr.count!=0)
        {
            for (NSInteger indexm=0; indexm<_dataArr.count; indexm++)
            {
                HWHomeIndexModel *Model=_dataArr[indexm];
                UIImageView *imageView=cellTwo.ImageArray[indexm];
                [imageView sd_setImageWithURL:[NSURL URLWithString:Model.cover] placeholderImage:[UIImage imageNamed:@"BJ_BANNER"]];
            }
 
        }
        cellTwo.selectionStyle=UITableViewCellSelectionStyleNone;
        return cellTwo;
    }
    
}
#pragma mark - target
-(void)kBxtBigForumClick
{
    BigForumViewController *bigforum  = [[BigForumViewController alloc] init];
    bigforum.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bigforum animated:YES];
}
-(void)kBxtOperationClick
{
    HWOperationViewController *operationVC = [[HWOperationViewController alloc] init];
    operationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:operationVC animated:YES];
}
-(void)kBxtRecordingClick
{
    AudioBookViewController *audio = [[AudioBookViewController alloc] init];
    audio.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:audio animated:YES];
}
-(void)kBxtJobLogClick
{
    HWJobLogController *jobLogVC = [[HWJobLogController alloc] init];
    jobLogVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jobLogVC animated:YES];
}
-(void)kBxtStudyPlanClick
{
    HWStudyPlanController *studyPlanVC = [[HWStudyPlanController alloc] init];
    studyPlanVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:studyPlanVC animated:YES];
}
-(void)kBxtMusicAnalysisClick
{
    HWMusicAnalysisController *MusicVC = [[HWMusicAnalysisController alloc] init];
    MusicVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:MusicVC animated:YES];
}
#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    MainSearchViewController *search = [[MainSearchViewController alloc] init];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
    [textField endEditing:YES];
}

@end
