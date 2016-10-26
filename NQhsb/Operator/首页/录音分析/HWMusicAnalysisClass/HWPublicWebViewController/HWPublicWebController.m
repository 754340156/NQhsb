//
//  HWPublicWebController.m
//  Operator
//
//  Created by NeiQuan on 16/10/20.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWPublicWebController.h"
#import "Html5LoadUrl.h"

@interface HWPublicWebController ()<UIWebViewDelegate>
{
    
    UIWebView    *_webView;
    
}
@end

@implementation HWPublicWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text=@"详情";
    [self loadNetData];
    [self addWebView];
}
#pragma mark --添加
-(void)addWebView
{
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    [_webView setBackgroundColor:[UIColor whiteColor]];
    _webView.delegate=self;
    
    [self.view addSubview:_webView];
    
}
#pragma mark --webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [self showHint:@"请检查你的网络"];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self showHint:@"请检查你的网络"];
    
}
#pragma mark --加载网络数据
-(void)loadNetData
{
    [self showHudInView:self.view hint:@""];
    [Html5LoadUrl  loadUrlWithRelevanceId:_RelevanceId type:_type SuccessBlock:^(NSString *url) {
       [self hideHud];
      [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    } failBlock:^(NSError *error) {
        [self hideHud];
        [self showHint:@"请检查你的网络"];
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
