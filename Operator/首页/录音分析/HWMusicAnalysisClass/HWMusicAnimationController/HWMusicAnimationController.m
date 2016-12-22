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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text=@"录音分析";
    self.view.backgroundColor = BXT_BACKGROUND_COLOR;
    [self getQuestionDataAndPushtoAnimationVC];
}
-(void)addOwnView
{
    [self addCollectionView];
 
}
-(void)addCollectionView
{
    HWCollectionViewLineLayot *layout=[[HWCollectionViewLineLayot alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,64, WIDTH, HEIGHT-64) collectionViewLayout:layout];
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
    return _questionDataArray.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HWMusicListCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ HWMusicListCollectionViewCell class]) forIndexPath:indexPath];
    cell.indexpath=indexPath;
    cell.delegate=self;
    
    HWMusicquestionListModel *model=_questionDataArray[indexPath.item];
    cell.questionModel=model;
    
    return cell;
}
#pragma mark --当选中摸个模板时获取题库
-(void)clickansitisButtonwithindexPath:(NSIndexPath *)indexpath
{
    HWMusicquestionListModel * model =  self.questionDataArray[indexpath.row];
    if (model.isSure) {
        
        if ([self isFinish]) {
            HWMusicquestionListModel *model=_questionDataArray[_questionDataArray.count-1];
            //跳转到分析报告界面
            HWMusicquestionReportViewController *reportVC = [[HWMusicquestionReportViewController alloc] init];
            reportVC.questionlogId = model.dataId;
            [self.navigationController pushViewController:reportVC animated:YES];
        }else
        {
            [self showHint:@"您有未完成的分析，请完成分析"];
        }
        return;
    }
    
    if (model.isCache.boolValue) {
        //查看分析
        [self getCacheQuestionData:indexpath.row];
    }else
    {
        //开始分析
        [self getquestionData:indexpath.row];
    }
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
         answerVC.popUpdateBlock = ^()
         {
             model.isCache = @"1";
             [_collectionView reloadData];
         };
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
             
             HWMusicquestionListModel * footerModel = [HWMusicquestionListModel new];
             footerModel.title = @"是否生成录音分析报告";
             footerModel.isSure = YES;
             footerModel.dataId = _relevanceId;
             [_questionDataArray addObject:footerModel];
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
- (BOOL)isFinish
{
    //判断是否全部生成分析
    for (NSInteger i = 0 ; i < self.questionDataArray.count - 1; i++) {
        HWMusicquestionListModel* model = self.questionDataArray[i];
        if (!model.isCache.boolValue) {
            return NO;
        }
    }
    return YES;
}
@end
