//
//  HWReChargeController.m
//  Operator
//
//  Created by NeiQuan on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWReChargeController.h"
#import "HWRechargeCollectionViewCell.h" //充值单个
#import "HWReChargeModel.h" //model
#import "HWPurcaseController.h" //支付界面
@interface HWReChargeController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView  *_collectionView;
    NSMutableArray    *_dataOrderArray;//用于数据
}
@end

@implementation HWReChargeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeBasic];
}
#pragma mark --初始化视图
-(void)makeBasic
{
    self.titleLabel.text=@"会员充值";
    _dataOrderArray=[[NSMutableArray alloc] init];
    [self addOwnCollectionView];
    [self getUerOrderData];//获取订单数据
    [self getRechargeInstructions];//获取充值说明
}
-(void)addOwnCollectionView
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize=CGSizeMake((WIDTH-40)/2.0,140 );//(WIDTH-40)/2.0
    layout.sectionInset=UIEdgeInsetsMake(3, 10, 0, 10);
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) collectionViewLayout:layout];
    
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HWRechargeCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HWRechargeCollectionViewCell class])];
    
     [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];//注册
     [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];//注册
    
    _collectionView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getUerOrderData];//获取订单信息
    }];
    [self.view addSubview:_collectionView];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataOrderArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HWRechargeCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HWRechargeCollectionViewCell class]) forIndexPath:indexPath];
    
    HWReChargeModel  *model=_dataOrderArray[indexPath.item];
    cell.chargemodel=model;
    return cell;
    
}
#pragma mark --点击输入框
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HWPurcaseController *PurcaseControllerVC=[[HWPurcaseController alloc] init];
    HWReChargeModel     *model=_dataOrderArray[indexPath.item];
    PurcaseControllerVC.purModel=model;
    [self.navigationController pushViewController:PurcaseControllerVC animated:YES];
    
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
   
    if (kind == UICollectionElementKindSectionHeader){
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(10, 2, WIDTH, 21)];
        lable.text=@"请选择充值的金额:";
        lable.font=[UIFont systemFontOfSize:14];
        [view addSubview:lable];
        return view;
            
        }else
        {
            
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
            [view setBackgroundColor:[UIColor whiteColor]];
            UILabel *alawayslable=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH-20, 21)];
            alawayslable.text=@"--------------常见问题--------------";
            alawayslable.textAlignment=NSTextAlignmentCenter;
            alawayslable.font=[UIFont systemFontOfSize:14];
            [view addSubview:alawayslable];
            
            UILabel *describelable=[[UILabel alloc] initWithFrame:CGRectMake(10, 30, WIDTH-20, 21)];
            describelable.text=@"什么是充值";
            describelable.font=[UIFont systemFontOfSize:14];
            [view addSubview:describelable];
            
            UILabel *sublielable=[[UILabel alloc] initWithFrame:CGRectMake(10, 55, WIDTH-20, 44)];
            sublielable.numberOfLines=0;
            sublielable.text=@"买卖买卖啊买东西松卖买卖啊买东西卖买卖啊买东西卖买卖啊买东西卖买卖啊买东西";
            sublielable.textColor=[UIColor grayColor];
            sublielable.font=[UIFont systemFontOfSize:14];
            [view addSubview:sublielable];
            return view;

            
        }
}- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(WIDTH, 25);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
     return CGSizeMake(WIDTH, 100);
}
#pragma mark --获取用户订单充值
-(void)getUerOrderData
{
    [HWHttpManger getUserordersuccess:^(id result)
    {
       _dataOrderArray =result;
       [_collectionView reloadData];
        [_collectionView.mj_header endRefreshing];//结束刷新
    } failBlock:^(NSError *error) {
        
        [self showHint:@"请检查你的网络"];
        
    }];
    
    
}
/**
 *  获取充值说明
 */
-(void)getRechargeInstructions
{
    NSDictionary *dic = @{@"account":[UserInfo account].account,
                          @"type":@"3"};
    [NetWorkHelp netWorkWithURLString:chainqueryInstructions
                           parameters:dic
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 DLog(@"充值说明查询成功");
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [self showHint:kBxtNetWorkError];
                         }];
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
