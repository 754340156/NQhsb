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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_htmlUrl]];
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
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
    }];
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"话务员APP"
                                                                             descr:self.titleLabel.text
                                                                         thumImage:[UIImage imageNamed:@"ICON_T"]];
    //设置网页地址
    shareObject.webpageUrl =_htmlUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}
#pragma mark - WKWebView

@end
