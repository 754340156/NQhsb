//
//  HWJobLogDetailController.m
//  Operator
//
//  Created by hai on 16/10/20.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWJobLogDetailController.h"
#import <WebKit/WebKit.h>
@interface HWJobLogDetailController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong) WKWebView * webView;
@end

@implementation HWJobLogDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightButton];
    [self setWebView];
}
#pragma mark - setup
- (void)setRightButton
{
    [self.rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setWebView
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64) configuration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://baidu.com"]];
    [self.webView loadRequest:request];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
}
#pragma mark - WkWebViewDelegate
#pragma mark - target
- (void)rightAction
{
    //去编辑
}
@end
