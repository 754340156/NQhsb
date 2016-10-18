//
//  SalesjobDetailViewController.m
//  Operator
//
//  Created by 白小田 on 16/10/17.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "SalesjobDetailViewController.h"

@interface SalesjobDetailViewController ()<UIWebViewDelegate>

@end

@implementation SalesjobDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = _kBxtTitle;
    [self kBxtWebView];
}

-(UIWebView *)kBxtWebView
{
    if (!_kBxtWebView) {
        _kBxtWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
        _kBxtWebView.backgroundColor = [UIColor whiteColor];
        _kBxtWebView.delegate = self;
        _kBxtWebView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
        [_kBxtWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_kBxtH5Url]]];//加载
        __weak UIWebView *webView = self.kBxtWebView;
        webView.delegate = self;
        __weak UIScrollView *scrollView = self.kBxtWebView.scrollView;
        // 添加下拉刷新控件
        scrollView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [webView reload];
        }];
        [self.view addSubview:_kBxtWebView];
    }
    return _kBxtWebView;
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
