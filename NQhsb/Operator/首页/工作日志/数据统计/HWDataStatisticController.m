//
//  HWDataStatisticController.m
//  Operator
//
//  Created by hai on 16/10/19.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWDataStatisticController.h"
#import <WebKit/WebKit.h>
@interface HWDataStatisticController ()<WKUIDelegate,WKNavigationDelegate>
/**   */
@property (nonatomic,strong) WKWebView * webView;
@end

@implementation HWDataStatisticController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"数据统计";
    [self setWebView];
    [self setRightButton];
}
#pragma mark - setup
- (void)setWebView
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64) configuration:configuration];
    [self.view addSubview:self.webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://baidu.com"]];
    [self.webView loadRequest:request];
}
- (void)setRightButton
{
    [self.rightButton setImage:[UIImage imageNamed:@"ICON_share"] forState:UIControlStateNormal];
    self.rightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.rightButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - Target
- (void)shareAction
{
    //分享
}
#pragma mark - WKWebView

@end
