//
//  HWPurcaseController.m
//  Operator
//
//  Created by NeiQuan on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWPurcaseController.h"
#import "HWReChargeModel.h"
#import "SYAddMoneyFirstCell.h"
#import "SYAddmoneyTwoCell.h"
#import "WXApi.h"
#import "WeiXinTool.h"
#import "payRequsestHandler.h" //微信支付相关配置-->
#import "ZhiFuBaoTool.h" //支付宝相关配置
@interface HWPurcaseController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView      *_tableView;
    UITextField      *_textField;
    NSIndexPath      *_selectedIndex;//用于记录选中
    
}
@end

@implementation HWPurcaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addOwnView];
    
    // Do any additional setup after loading the view.
}
#pragma mark --添加子类对象
-(void)addOwnView
{
    self.titleLabel.text=@"支付方式";
    [self.rightButton setHidden:NO];
    [self.rightButton setTitleColor:[UIColor blackColor ] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(postGetOrderMessage) forControlEvents:UIControlEventTouchUpInside];
    [self maketableView];
}
-(void)maketableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)  style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
}
#pragma mark --tableViewdeleGate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        static NSString *moneyFirst=@"moneyFirst";
        SYAddMoneyFirstCell *moneyCell=[tableView dequeueReusableCellWithIdentifier:moneyFirst];
        if (moneyCell==nil) {
            moneyCell =[[ NSBundle mainBundle] loadNibNamed:@"SYAddMoneyFirstCell" owner:self options:nil][0];
        }
        _textField = moneyCell.money;
        _textField.delegate=self;
        _textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        moneyCell.money.placeholder=@"请输入充值金额";
        moneyCell.money.text=[NSString stringWithFormat:@"￥%@",_purModel.price];//价格
        moneyCell.selectionStyle=UITableViewCellSelectionStyleNone;
        moneyCell.money.delegate=self;
        return moneyCell;
    }else
    {
        static NSString *AddMoneytwo=@"AddMoneytwo";
        SYAddmoneyTwoCell *cell=[ tableView dequeueReusableCellWithIdentifier:AddMoneytwo];
        if (cell==nil)
        {
            cell=[[ NSBundle mainBundle] loadNibNamed:@"SYAddmoneyTwoCell" owner:self options:nil][0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if(indexPath.row==0)
        {
            [cell.iconImage setImage:[ UIImage imageNamed:@"ICON_ZF"]];
            cell.titleName.text=@"支付宝支付";
           }else{
            [cell.iconImage setImage:[ UIImage imageNamed:@"ICON_WX"]];
             cell.titleName.text=@"微信支付";
         }
        if (_selectedIndex.row==indexPath.row)
        {
             [cell.selectionImage  setImage: [ UIImage  imageNamed:@"ICON_XZQD"]];
        }else
        {
           [cell.selectionImage  setImage: [ UIImage  imageNamed:@"ICON_WXZ"]];
        }
        
        return cell;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *view=[[ UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    [view setBackgroundColor:BXT_BACKGROUND_COLOR ];
    return view;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[[ UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    [view setBackgroundColor:BXT_BACKGROUND_COLOR];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1)return 15.0f;
    return 0.01 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) return 46;
    return 65;
    
}
#pragma mark --点击单元格事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section!=0)
    {
        _selectedIndex=indexPath;
        [_tableView reloadData];
    }

}
//cell顶格
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --请求接口获取订单什么的
-(void)postGetOrderMessage
{
    [self showHint:@"正在完善"];
    //payType 支付方式1  支付宝2微信
    [self showHudInView:self.view hint:@""];
    NSDictionary *parameters=@{@"account":[UserInfo account].account,@"token":[UserInfo account].token,@"goodsId":_purModel.dataId,@"payType":@(_selectedIndex.row)};//支付
    [NetWorkHelp  netWorkWithURLString:Userorder parameters:parameters SuccessBlock:^(NSDictionary *dic)
     {
         [self hideHud];
         if ([dic[@"code"]integerValue]==0)
         {
             
         }
       
     } failBlock:^(NSError *error)
     {
        [self hideHud];
        [self showHint:@"请检查你的网络"];
         
     }];

}
#pragma mark --发起微信支付 -->后台只返回了一个订单id-->需要自己自签名,回调地址
-(void)sendWXPurse
{
    if ([WXApi isWXAppInstalled])
    {
        //商品名称--> 价格 --订单id
       // [WeiXinTool payForWeiXin:<#(NSString *)#> itemsParce:<#(NSString *)#> orderid:<#(NSString *)#>];
        
    }
    
}
#pragma mark --支付宝支付
-(void)sendtoZhiBao
{
     //商品名称--> 价格 --订单id
   // [ZhiFuBaoTool payForZhiFuBao:<#(NSString *)#> itemsParce:<#(NSString *)#> SuccessBlock:^(NSDictionary *dic) {
        
    //}];
    
}
@end
