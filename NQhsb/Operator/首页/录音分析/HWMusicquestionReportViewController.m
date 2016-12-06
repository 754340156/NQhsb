//
//  HWMusicquestionReportViewController.m
//  Operator
//
//  Created by 白小田 on 2016/11/4.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWMusicquestionReportViewController.h"

static NSString *const kBxtFootTitle = @"录音分析总结";

static NSInteger const kShareBtnSize = 20;   //分享按钮大小

static NSInteger const kShareBtnSpacing = 20; //分享按钮间距

@interface HWMusicquestionReportViewController ()<UIWebViewDelegate,UITextViewDelegate>

kBxtPropertyStrong UIWebView    *kBxtMyWebView;

kBxtPropertyStrong UILabel      *kBxtFootView;

kBxtPropertyStrong UITextView   *kBxtFootTextView;

@end

@implementation HWMusicquestionReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"录音分析报告";
    [self navBtn];
}
- (void)setRightButton
{
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-kShareBtnSize-kShareBtnSpacing,
                                                                    self.navigationBarBackground.bottom+5,
                                                                    kShareBtnSize,
                                                                    kShareBtnSize)];
    [shareBtn setImage:[UIImage imageNamed:@"ICON_share"] forState:UIControlStateNormal];
    shareBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
}
-(void)navBtn
{
    [self.rightButton setHidden:NO];
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:KTabBarColor forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self kBxtMyWebView];
    [self kBxtFootView];
    [self kBxtFootTextView];
    [self setRightButton];
}
-(UIWebView *)kBxtMyWebView
{
    if (!_kBxtMyWebView) {
        _kBxtMyWebView = [[UIWebView alloc] init];
        [_kBxtMyWebView setFrame:CGRectMake(0, 64+kShareBtnSize+5, WIDTH, HEIGHT-HEIGHT/4.4-64-kShareBtnSize-5)];
        [_kBxtMyWebView setDelegate:self];
        [_kBxtMyWebView setOpaque:NO];
        [_kBxtMyWebView setBackgroundColor:[UIColor clearColor]];
        [_kBxtMyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
        [self.view addSubview:_kBxtMyWebView];
    }
    return _kBxtMyWebView;
}
-(UILabel *)kBxtFootView
{
    if (!_kBxtFootView) {
        _kBxtFootView = [[UILabel alloc] init];
        [_kBxtFootView setFrame:CGRectMake(0, _kBxtMyWebView.bottom-1.5, WIDTH, 30)];
        [_kBxtFootView setBackgroundColor:[UIColor colorWithWhite:0.89 alpha:1]];
        [_kBxtFootView setFont:FontOfSize(12)];
        [_kBxtFootView setText:kBxtFootTitle];
        [self.view addSubview:_kBxtFootView];
    }
    return _kBxtFootView;
}
-(UITextView *)kBxtFootTextView
{
    if (!_kBxtFootTextView) {
        _kBxtFootTextView = [[UITextView alloc] init];
         [_kBxtFootTextView setFrame:CGRectMake(8, _kBxtFootView.bottom+5, WIDTH-16, HEIGHT-_kBxtFootView.bottom-10)];
        _kBxtFootTextView.layer.masksToBounds = YES;
        _kBxtFootTextView.layer.cornerRadius  = 3;
        _kBxtFootTextView.layer.borderWidth   = 1;
        _kBxtFootTextView.layer.shadowOpacity = 1;//阴影透明度，默认0
        _kBxtFootTextView.layer.shadowRadius  = 3;//阴影半径，默认3
        _kBxtFootTextView.layer.borderColor   = [UIColor colorWithWhite:0.628 alpha:1.000].CGColor;
        [_kBxtFootTextView setDelegate:self];
        [self.view addSubview:_kBxtFootTextView];
    }
    return _kBxtFootTextView;
}
-(void)rightButtonClick
{
    if (_kBxtFootTextView.text) {
        [self netWorkHelp];
    }else{
        [self showHint:@"请先填写"];
    }
}
-(void)netWorkHelp
{
    NSDictionary *dic = @{@"account":[UserInfo account].account,
                          @"remark":_kBxtFootTextView.text,
                          @"questionlogId":_questionlogId};
    [NetWorkHelp netWorkWithURLString:questiongenerate
                           parameters:dic
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 [self showHint:dic[@"保存成功"]];
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [self showHint:kBxtNetWorkError];
                         }];
}
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
-(void)removePlatformProviderWithPlatformTypes:(NSArray *)platformTypeArray
{
    
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
