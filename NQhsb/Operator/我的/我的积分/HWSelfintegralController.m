//
//  HWSelfintegralController.m
//  Operator
//
//  Created by NeiQuan on 16/10/13.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWSelfintegralController.h"

@interface HWSelfintegralController ()
{
    
    UIWebView  *_webView;
}
@end

@implementation HWSelfintegralController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的积分";
    [self makeWebViews];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}
#pragma mark --创建对象
-(void)makeWebViews
{
    _webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
    [_webView setBackgroundColor:BXT_BACKGROUND_COLOR];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jianshu.com/"]]];
    [self.view addSubview:_webView];
    
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
