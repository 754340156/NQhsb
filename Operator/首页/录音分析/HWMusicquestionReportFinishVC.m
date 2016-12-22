//
//  HWMusicquestionReportFinishVC.m
//  Operator
//
//  Created by zhaozhe on 16/12/20.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWMusicquestionReportFinishVC.h"

@interface HWMusicquestionReportFinishVC ()<UIWebViewDelegate>
kBxtPropertyStrong UIWebView    *kBxtMyWebView;
@end

@implementation HWMusicquestionReportFinishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"录音分析报告";
    [self navBtn];

}
-(void)navBtn
{
    [self kBxtMyWebView];
    [self setNavigation];
}
-(UIWebView *)kBxtMyWebView
{
    if (!_kBxtMyWebView) {
        _kBxtMyWebView = [[UIWebView alloc] init];
        [_kBxtMyWebView setFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
        [_kBxtMyWebView setDelegate:self];
        [_kBxtMyWebView setOpaque:NO];
        [_kBxtMyWebView setBackgroundColor:[UIColor clearColor]];
        [_kBxtMyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.loadUrl]]];
        [self.view addSubview:_kBxtMyWebView];
    }
    return _kBxtMyWebView;
}
- (void)setNavigation
{
    [self.rightButton setImage:[UIImage imageNamed:@"ICON_share"]  forState:UIControlStateNormal];
    [self.rightButton setTitleColor:KTabBarColor forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)shareAction
{
    //分享
    NSArray *arr = @[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_WechatFavorite)];
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:arr];
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
    shareObject.webpageUrl =_loadUrl;
    
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
@end
