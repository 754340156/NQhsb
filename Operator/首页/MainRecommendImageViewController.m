//
//  MainRecommendImageViewController.m
//  Operator
//
//  Created by 白小田 on 2016/11/30.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "MainRecommendImageViewController.h"
#import <WebKit/WebKit.h>
@interface MainRecommendImageViewController ()<WKUIDelegate,WKNavigationDelegate>

kBxtPropertyStrong WKWebView *webview;

@end

@implementation MainRecommendImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createWebView];
}
-(void)createWebView
{
    _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    _webview.navigationDelegate = self;
    _webview.UIDelegate         = self;
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_kWebUrl]]];
    [self.view addSubview:_webview];
}
-(void)dealloc
{
    _webview = nil;
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
