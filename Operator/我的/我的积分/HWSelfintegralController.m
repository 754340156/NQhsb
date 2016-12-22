//
//  HWSelfintegralController.m
//  Operator
//
//  Created by NeiQuan on 16/10/13.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWSelfintegralController.h"
#import "Html5LoadAssist.h"

@interface HWSelfintegralController ()
{
    
    UIWebView  *_webView;
}
@end

@implementation HWSelfintegralController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"我的积分";
    self.view.backgroundColor = BXT_BACKGROUND_COLOR;
    [self showHudInView:self.view hint:@"加载中..."];
    [self netWorkHelp];
    
   
}

#pragma mark --创建对象
-(void)makeWebViews
{
    _webView=[[UIWebView alloc] initWithFrame:kCommentRect];
    [_webView setBackgroundColor:BXT_BACKGROUND_COLOR];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]]];
    [self.view addSubview:_webView];
    
}
-(void)netWorkHelp
{
    [Html5LoadAssist html5LoadAssistUrlWithType:5
                                   SuccessBlock:^(NSString *url) {
                                       _webUrl = url;
                                       [self makeWebViews];
                                       [self hideHud];
                                   } failBlock:^(NSError *error) {
                                       [self showHint:kBxtNetWorkError];
                                       [self hideHud];
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
