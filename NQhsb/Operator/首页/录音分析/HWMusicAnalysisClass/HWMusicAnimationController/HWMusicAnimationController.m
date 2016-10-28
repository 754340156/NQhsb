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
@interface HWMusicAnimationController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView    *_collectionView;
    UIButton            *_footButton;
}
@end

@implementation HWMusicAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text=@"录音分析";
    [self addOwnView];
}
-(void)addOwnView
{
    [self addCollectionView];
    [self addfootView];
    
}
-(void)addCollectionView
{
    HWCollectionViewLineLayot *layout=[[HWCollectionViewLineLayot alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 120, WIDTH, 200) collectionViewLayout:layout];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HWMusicListCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HWMusicListCollectionViewCell class])];
    _collectionView.showsVerticalScrollIndicator=NO;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.dataSource=self;
    _collectionView.dataSource=self;
    [self.view addSubview:_collectionView];
    
}
-(void)addfootView
{
    __weak typeof(self)weakself=self;
    _footButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_footButton setFrame:CGRectMake(20, HEIGHT-64-35, WIDTH-40, 35)];
    [_footButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_footButton setBackgroundColor:KTabBarColor];
    _footButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [_footButton setTitle:@"开始分析" forState:UIControlStateNormal];
    [_footButton addTarget:weakself action:@selector(startAnalysis) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_footButton];
    
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
    HWMusicquestionListModel *model=_questionDataArray[indexPath.item];
    cell.questionModel=model;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --开始分析问题
-(void)startAnalysis
{
   //网上实例方法  https://github.com/darren90/TFCycleScrollView/blob/master/TFCycleScrollView-2/TFCycleScrollView/TFScrollView/TFCycleScrollView.m
  //获取当前可显示的cell，计算当前选中的indexpatch
    NSArray *visibleCellIndex = [_collectionView visibleCells];
    NSArray *sortedIndexPaths = [visibleCellIndex sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSIndexPath *path1 = (NSIndexPath *)[_collectionView indexPathForCell:obj1];
        NSIndexPath *path2 = (NSIndexPath *)[_collectionView indexPathForCell:obj2];
        return [path1 compare:path2];
    }];
    
    NSInteger indexselected=0;
    for (NSInteger indeM=0; indeM<sortedIndexPaths.count; indeM++)
    {
        HWMusicListCollectionViewCell *cellpath=sortedIndexPaths[indeM];
        indexselected+=cellpath.indexpath.row;
    }
    [self getquestionData:indexselected/sortedIndexPaths.count] ;
    
}
#pragma mark --获取题库
-(void)getquestionData:(NSInteger)index
{
    HWMusicquestionListModel *model=_questionDataArray[index];
    [self showHudInView:self.view hint:@""];
    [HWHttpManger  getquestiondataId:model.dataId success:^(id result)
     {
         [self hideHud];
         NSMutableArray *dataArray=result;
         HWMusicAnswerController  *answerVC=[[HWMusicAnswerController alloc] init];
         answerVC.hidesBottomBarWhenPushed=YES;
         answerVC.dataListArray=dataArray;
         [self.navigationController pushViewController:answerVC animated:YES];
        
    } failBlock:^(NSError *error) {
        
        [self hideHud];
        [self showHint:@"请检查你的网络"];
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
