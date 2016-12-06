//
//  HWMusicAnimationController.m
//  Operator
//
//  Created by NeiQuan on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWMusicAnimationController.h"
#import "HWMusicListCollectionViewCell.h"
#import "HWCollectionViewLineLayot.h"
#import "HWMusicAnalysicModel.h"
#import "HWMusicAnswerController.h" //答题
#import "HWMusicquestionReportViewController.h"
@interface HWMusicAnimationController ()<UICollectionViewDelegate,UICollectionViewDataSource,HWMusicListCollectionViewCelldelegate>
{
    UICollectionView    *_collectionView;
}
@end

@implementation HWMusicAnimationController
-(void)viewWillAppear:(BOOL)animated
{
    [self getQuestionDataAndPushtoAnimationVC];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text=@"录音分析";
    self.view.backgroundColor = BXT_BACKGROUND_COLOR;
}
-(void)addOwnView
{
    [self addCollectionView];
 
}
-(void)addCollectionView
{
    HWCollectionViewLineLayot *layout=[[HWCollectionViewLineLayot alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 120, WIDTH, HEIGHT/1.5) collectionViewLayout:layout];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HWMusicListCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HWMusicListCollectionViewCell class])];
    _collectionView.showsVerticalScrollIndicator=NO;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    [self.view addSubview:_collectionView];
    
}
-(void)setQuestionDataArray:(NSMutableArray *)questionDataArray
{
    _questionDataArray=questionDataArray;
    [_collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _questionDataArray.count+1;//5+1
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HWMusicListCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ HWMusicListCollectionViewCell class]) forIndexPath:indexPath];
    cell.indexpath=indexPath;
    cell.delegate=self;
    
    if (indexPath.row==_questionDataArray.count)
    {
        [cell.startAnsstis setTitle:@"确认" forState:UIControlStateNormal];
        cell.titleLable.text=@"是否生成录音分析报告";
    }else
    {
        HWMusicquestionListModel *model=_questionDataArray[indexPath.item];
        cell.questionModel=model;
        
    }
    return cell;
}
#pragma mark --当选中摸个模板时获取题库
-(void)clickansitisButtonwithindexPath:(NSIndexPath *)indexpath
{
    
    
    if (indexpath.row==_questionDataArray.count)//是否音乐分析生成报告
    {
        HWMusicquestionListModel *model=_questionDataArray[_questionDataArray.count-1];
       //跳转到分析报告界面
        HWMusicquestionReportViewController *reportVC = [[HWMusicquestionReportViewController alloc] init];
        [Html5LoadUrl loadUrlWithRelevanceId:model.dataId
                                        type:@"7"
                                SuccessBlock:^(NSString *url) {
                                    reportVC.loadUrl = url;
                                    reportVC.questionlogId = model.dataId;
                                    [self.navigationController pushViewController:reportVC animated:YES];
                                } failBlock:^(NSError *error) {
                                    [self showHint:kBxtNetWorkError];
                                }];
        
        
    }else
    {
        /**
         *  0 未缓存  1 已缓存    为1进入界面前要请求已缓存接口   为0不需要
         */
        HWMusicquestionListModel *model=_questionDataArray[indexpath.row];
        if (![model.isCache isEqualToString:@"1"]) {
            [self getquestionData:indexpath.row];
        }else{
            [self getCacheQuestionData:indexpath.row];
        }
      
    }
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --获取题库未缓存
-(void)getquestionData:(NSInteger)index
{
    HWMusicquestionListModel *model=_questionDataArray[index];
    [self showHudInView:self.view hint:@""];
    [HWHttpManger  getquestiondataId:model.dataId
                                type:model.isCache
                             success:^(id result)
     {
         [self hideHud];
         NSMutableArray *dataArray=result;
         HWMusicAnswerController  *answerVC=[[HWMusicAnswerController alloc] init];
         answerVC.hidesBottomBarWhenPushed=YES;
         answerVC.dataListArray=dataArray;
         answerVC.selectId = model.dataId;
         answerVC.questionlogId = _relevanceId;
//         answerVC.urlIds        = _urlids;
         [self.navigationController pushViewController:answerVC animated:YES];
        
    } failBlock:^(NSError *error) {
        
        [self hideHud];
        [self showHint:@"请检查你的网络"];
    }];
    
}
#pragma mark --获取题库已缓存
-(void)getCacheQuestionData:(NSInteger)index
{
    HWMusicquestionListModel *model=_questionDataArray[index];
    [self showHudInView:self.view hint:@""];
    [HWHttpManger  getCacheQuestiondataId:model.dataId
                            questionlogId:_relevanceId
                                  success:^(id result)
     {
         [self hideHud];
         NSMutableArray *dataArray=result;
         HWMusicAnswerController  *answerVC=[[HWMusicAnswerController alloc] init];
         answerVC.hidesBottomBarWhenPushed=YES;
         answerVC.dataListArray=dataArray;
         answerVC.selectId = model.dataId;
         answerVC.questionlogId = _relevanceId;
//         answerVC.urlIds        = _urlids;
         [self.navigationController pushViewController:answerVC animated:YES];
         
     } failBlock:^(NSError *error) {
         
         [self hideHud];
         [self showHint:@"请检查你的网络"];
     }];
}
#pragma mark --获取答题模板数据
-(void)getQuestionDataAndPushtoAnimationVC
{
    
    [self showHudInView:self.view hint:@""];

    NSDictionary *parameters=@{@"account":[UserInfo account].account,
                               @"questionlogId":_relevanceId,
                               @"token":[UserInfo account].token};
    [NetWorkHelp  netWorkWithURLString:Musicquestionchooseloglist
                            parameters:parameters
                          SuccessBlock:^(NSDictionary *dic)
     {   [self hideHud];
         if ([dic[@"code"]integerValue]==0)
         {
             
             HWMusicquestionListModel *headerModel=[HWMusicquestionListModel mj_objectWithKeyValues:dic[@"response"][@"head"]];
             
             _questionDataArray =[HWMusicquestionListModel mj_objectArrayWithKeyValuesArray:dic[@"response"][@"selectmoodule"]];
             [_questionDataArray insertObject:headerModel atIndex:0];
             [self addOwnView];
         }else
         {
             [self showHint:@"无法构建题库"];
         }
     } failBlock:^(NSError *error)
     {
         [self hideHud];
         [self showHint:kBxtNetWorkError];
     }];
    
    
    
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
