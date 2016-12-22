//
//  HWMusicquestionReportViewController.m
//  Operator
//
//  Created by 白小田 on 2016/11/4.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWMusicquestionReportViewController.h"

static NSString *const kBxtFootTitle = @"录音分析总结";

static NSInteger const kShareBtnSize = 20;   //分享按钮大小

static NSInteger const kShareBtnSpacing = 20; //分享按钮间距

@interface HWMusicquestionReportViewController ()<UIWebViewDelegate,UITextViewDelegate>

kBxtPropertyStrong UIWebView    *kBxtMyWebView;

kBxtPropertyStrong UILabel      *kBxtFootView;

kBxtPropertyStrong UITextView   *kBxtFootTextView;

@end

@implementation HWMusicquestionReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"录音分析报告";
    [self navBtn];
    [self netWorkHelp];
}
-(void)navBtn
{
    [self kBxtMyWebView];
    [self kBxtFootView];
    [self kBxtFootTextView];
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:KTabBarColor forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
}
-(UIWebView *)kBxtMyWebView
{
    if (!_kBxtMyWebView) {
        _kBxtMyWebView = [[UIWebView alloc] init];
        [_kBxtMyWebView setFrame:CGRectMake(0, 64, WIDTH, HEIGHT-HEIGHT/4.4-64)];
        [_kBxtMyWebView setDelegate:self];
        [_kBxtMyWebView setOpaque:NO];
        [_kBxtMyWebView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:_kBxtMyWebView];
    }
    return _kBxtMyWebView;
}
-(UILabel *)kBxtFootView
{
    if (!_kBxtFootView) {
        _kBxtFootView = [[UILabel alloc] init];
        [_kBxtFootView setFrame:CGRectMake(0, _kBxtMyWebView.bottom-1.5, WIDTH, 30)];
        [_kBxtFootView setBackgroundColor:[UIColor colorWithWhite:0.89 alpha:1]];
        [_kBxtFootView setFont:FontOfSize(12)];
        [_kBxtFootView setText:kBxtFootTitle];
        [self.view addSubview:_kBxtFootView];
    }
    return _kBxtFootView;
}
-(UITextView *)kBxtFootTextView
{
    if (!_kBxtFootTextView) {
        _kBxtFootTextView = [[UITextView alloc] init];
         [_kBxtFootTextView setFrame:CGRectMake(8, _kBxtFootView.bottom+5, WIDTH-16, HEIGHT-_kBxtFootView.bottom-10)];
        _kBxtFootTextView.layer.masksToBounds = YES;
        _kBxtFootTextView.layer.cornerRadius  = 3;
        _kBxtFootTextView.layer.borderWidth   = 1;
        _kBxtFootTextView.layer.shadowOpacity = 1;//阴影透明度，默认0
        _kBxtFootTextView.layer.shadowRadius  = 3;//阴影半径，默认3
        _kBxtFootTextView.layer.borderColor   = [UIColor colorWithWhite:0.628 alpha:1.000].CGColor;
        [_kBxtFootTextView setDelegate:self];
        [self.view addSubview:_kBxtFootTextView];
    }
    return _kBxtFootTextView;
}
-(void)rightButtonClick
{
    [self networkUpdateGenerate];
}
-(void)netWorkHelp
{
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                          @"questionlogId":_questionlogId};
    [NetWorkHelp netWorkWithURLString:questiongenerate
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 [self.kBxtMyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dic[@"response"][@"url"]]]];
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [self showHint:kBxtNetWorkError];
                         }];
}


- (void)networkUpdateGenerate
{
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                                 @"token":[UserInfo account].token,
                                 @"remark":_kBxtFootTextView.text,
                                 @"questionlogId":_questionlogId};
    [NetWorkHelp netWorkWithURLString:updateGenerate
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 [self showHint:@"保存成功"];
                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                 });
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [self showHint:kBxtNetWorkError];
                         }];
    
}

@end
