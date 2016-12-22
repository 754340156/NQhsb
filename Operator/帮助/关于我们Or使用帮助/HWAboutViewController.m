//
//  HWAboutViewController.m
//  Operator
//
//  Created by NeiQuan on 16/10/13.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWAboutViewController.h"
#import "Html5LoadAssist.h"
@interface HWAboutViewController ()
{
    UITextView   *_textView;
}
@end

@implementation HWAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.titleText;
    self.view.backgroundColor = BXT_BACKGROUND_COLOR;
    [self makeTextView];
}
#pragma mark --创建textView
-(void)makeTextView
{
    UIWebView *webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height)];
    [self.view addSubview:webView];
    
    kHtmlType type;
    if([self.titleLabel.text isEqualToString:@"关于我们"]){
        type = kHtmlTypeStateAboutUs;
    }else{
        type = kHtmlTypeStateHelp;
    }
    
    //关于我们
    [Html5LoadAssist html5LoadAssistUrlWithType:type
                                   SuccessBlock:^(NSString *url) {
                                       [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                                   } failBlock:^(NSError *error) {
                                       [self showHint:kBxtNetWorkError];
                                   }];

}


@end
