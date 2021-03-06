//
//  SalesjobDetailViewController.m
//  Operator
//
//  Created by 白小田 on 16/10/17.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "SalesjobDetailViewController.h"
#import "DetailCell.h"
#import "Html5FootViewModel.h"
#import <AVFoundation/AVFoundation.h>
#import "DeleteNoteHintView.h"
#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


static NSString *kBxtCell = @"cell";

@interface SalesjobDetailViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AVAudioPlayerDelegate>

kBxtPropertyStrong UITableView *myMytableview;

kBxtPropertyStrong Html5FootResponse *response;

kBxtPropertyAssign NSInteger    pageIndex;

kBxtPropertyAssign NSInteger    pageSize;

kBxtPropertyStrong UIView       *footView;

kBxtPropertyStrong UITextField  *footTextField;

kBxtPropertyStrong UIButton     *audioBtn;

kBxtPropertyStrong UIButton     *collectionBtn;

kBxtPropertyNonatomic BOOL      isFootTextField;

kBxtPropertyStrong AVAudioPlayer *player;

kBxtPropertyStrong UIButton     *recordButton;

kBxtPropertyWeak   NSTimer      *timerOf60Second;

kBxtPropertyStrong UIImageView  *collectionimg;

kBxtPropertyStrong UIScrollView *myScrollView;

kBxtPropertyStrong DeleteNoteHintView * hintView;
@end

@implementation SalesjobDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.titleLabel.text = _kBxtTitle;
    _pageIndex = 1;
    _pageSize  = 9;
    _isFootTextField = YES;
    
    [self myMytableview];
    [self kBxtWebView];
    [self footView];
    [self defaultWork];
    [self setRightButton];


}
-(UIWebView *)kBxtWebView
{
    if (!_kBxtWebView) {
        _kBxtWebView = [[UIWebView alloc] init];
        _kBxtWebView.frame = CGRectMake(0, 64, WIDTH, HEIGHT/2);
        _kBxtWebView.backgroundColor = [UIColor whiteColor];
        _kBxtWebView.scrollView.scrollEnabled = NO;
        _kBxtWebView.delegate = self;
        _kBxtWebView.scalesPageToFit = YES;
        [_kBxtWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_kBxtH5Url]]];
    }
    return _kBxtWebView;
}
- (void)setRightButton
{
    if (self.isNotShare) return;
    [self.rightButton setImage:[UIImage imageNamed:@"ICON_share"] forState:UIControlStateNormal];
    self.rightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.rightButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showHudInView:self.view hint:nil];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    webView.userInteractionEnabled = NO;
    [_myMytableview.mj_header endRefreshing];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [timer fire];
}
- (void)timerAction:(NSTimer *)timer
{
    CGFloat sizeHeight= [[_kBxtWebView stringByEvaluatingJavaScriptFromString:@"webHeight"] floatValue];
    CGRect frame = _kBxtWebView.frame;
    _kBxtWebView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, sizeHeight - 1);
    _myMytableview.tableHeaderView = _kBxtWebView;
    if (sizeHeight) {
        [timer invalidate];
        timer = nil;
        [self hideHud];
    }
    NSLog(@"%f",sizeHeight);
    
}
-(UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc] init];
        _footView.frame = CGRectMake(0, HEIGHT-50, WIDTH, 50);
        _footView.backgroundColor = color_f5f5f5;
        [self.view addSubview:_footView];
        
        _footTextField = [[UITextField alloc] init];
        _footTextField.frame = CGRectMake(40, 10, _footView.width-80, _footView.height-20);
        _footTextField.delegate = self;
        _footTextField.borderStyle = UITextBorderStyleNone;
        _footTextField.layer.masksToBounds = YES;
        _footTextField.layer.cornerRadius  = 15;
        _footTextField.backgroundColor = [UIColor whiteColor];
        _footTextField.returnKeyType = UIReturnKeySend;
        [_footView addSubview:_footTextField];
        
        _audioBtn = [[UIButton alloc] init];
        _audioBtn.frame = CGRectMake(0, _footTextField.top, 40, 40);
        [_audioBtn addTarget:self action:@selector(audioBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:_audioBtn];
        
        UIImageView *leftimg = [[UIImageView alloc] init];
        leftimg.frame = CGRectMake(10, 0, 20, 20);
        leftimg.contentMode = UIViewContentModeCenter;
        leftimg.image = [UIImage imageNamed:@"ICON_note"];
        [_audioBtn addSubview:leftimg];
        
        UILabel *leftLb = [[UILabel alloc] init];
        leftLb.frame = CGRectMake(10, leftimg.bottom, 40, 20);
        leftLb.text = @"笔记";
        leftLb.font = FontOfSize(10);
        [_audioBtn addSubview:leftLb];
        
        _collectionBtn = [[UIButton alloc] init];
        _collectionBtn.frame = CGRectMake(_footView.width-30, _footTextField.top, 40, 40);
        [_collectionBtn addTarget:self action:@selector(collectionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:_collectionBtn];
        
        _collectionimg = [[UIImageView alloc] init];
        _collectionimg.frame = CGRectMake(0, 0, 20, 20);
        _collectionimg.image = [UIImage imageNamed:@"star_no"];
        [_collectionBtn addSubview:_collectionimg];
        
        UILabel *rightLb = [[UILabel alloc] init];
        rightLb.frame = CGRectMake(0, 20, 40, 20);
        rightLb.text  = @"收藏";
        rightLb.font  = FontOfSize(10);
        [_collectionBtn addSubview:rightLb];
        
        [self initButton];
        [_recordButton setHidden:YES];
        
    }
    return _footView;
}
- (void)initButton {
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordButton setBackgroundImage:[[UIImage imageNamed:@"btn_chatbar_press_normal" ] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [_recordButton setBackgroundImage:[[UIImage imageNamed:@"btn_chatbar_press_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
    _recordButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_recordButton setTitle:@"按住录音" forState:UIControlStateNormal];
    [_recordButton setTitleColor:KTabBarColor forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
    [_recordButton addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
    [_recordButton addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
    [_recordButton addTarget:self action:@selector(updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
    [_recordButton addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
    [_recordButton setFrame:CGRectMake(40, 5, _footView.width-80, _footView.height-10)];
    [_footView addSubview:_recordButton];
    
}
-(UITableView *)myMytableview
{
    if (!_myMytableview) {
        _myMytableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
        _myMytableview.delegate = self;
        _myMytableview.dataSource = self;
        _myMytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_myMytableview registerClass:NSClassFromString(@"DetailCell") forCellReuseIdentifier:kBxtCell];
        _myMytableview.backgroundColor = KnavColor;
        _myMytableview.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            [self netWorkHelp];
        }];
        _myMytableview.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
            _pageSize = _pageSize + 9;
            [self netWorkHelp];
        }];
        [self netWorkHelp];
        [self.view addSubview:_myMytableview];
    }
    return _myMytableview;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kBxtCell];
    cell.listModel = _response.list[indexPath.row];
    return cell.cellheight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _response.list.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kBxtCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.listModel = _response.list[indexPath.row];
    cell.kBxtAudioButton.tag = 100+indexPath.row;
    cell.kBxtDelegateButton.tag = 200+indexPath.row;
    [cell.kBxtAudioButton addTarget:self action:@selector(kBxtAudioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.kBxtAudioButton addTarget:self action:@selector(kBxtAudioButtonClickTwo:) forControlEvents:UIControlEventTouchDownRepeat];
    [cell.kBxtDelegateButton addTarget:self action:@selector(kBxtDelegateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
//切换
-(void)audioBtnClick
{
    _isFootTextField = !_isFootTextField;
    [self.view endEditing:YES];
    if (_isFootTextField) {
        [_recordButton setHidden:YES];
        [_footTextField setHidden:NO];
    }else{
        [_recordButton setHidden:NO];
        [_footTextField setHidden:YES];
    }
}
/**
 *  播放
 */
-(void)kBxtAudioButtonClick:(UIButton *)btn
{
    Html5FootList *list = _response.list[btn.tag-100];
//    list.content;   播放url
  
    NSString *urlStr = list.content;
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    NSData * audioData = [NSData dataWithContentsOfURL:url];
    
//    将数据保存到本地指定位置
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:nil];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath , @"temp"];
    [audioData writeToFile:filePath atomically:YES];
    
    //播放本地音乐
      [[LGAudioPlayer sharePlayer] playAudioWithURLString:filePath atIndex:btn.tag-100];

    
}
/**
 *  停止
 */
-(void)kBxtAudioButtonClickTwo:(UIButton *)btn
{
    [[LGAudioPlayer sharePlayer] stopAudioPlayer];
}
//收藏
-(void)collectionBtnClick
{
    [self netWorkAdd];
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
    shareObject.webpageUrl = _kBxtH5Url;
    
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
#pragma mark - Private Methods

/**
 *  开始录音
 */
- (void)startRecordVoice{
    __block BOOL isAllow = 0;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                isAllow = 1;
            } else {
                isAllow = 0;
            }
        }];
    }
    if (isAllow) {
        //		//停止播放
        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
        //		//开始录音
        [[LGSoundRecorder shareInstance] startSoundRecord:self.view recordPath:[self recordPath]];
        //开启定时器
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        _timerOf60Second = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sixtyTimeStopSendVodio) userInfo:nil repeats:YES];
    } else {
        
    }
}

/**
 *  录音结束
 */
- (void)confirmRecordVoice{
    if ([[LGSoundRecorder shareInstance] soundRecordTime] < 1.0f) {
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        [self showShotTimeSign];
        return;
    }
    
    if ([[LGSoundRecorder shareInstance] soundRecordTime] < 60) {
        [self sendSound];
        [[LGSoundRecorder shareInstance] stopSoundRecord:self.view];
    }
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
}

/**
 *  更新录音显示状态,手指向上滑动后 提示松开取消录音
 */
- (void)updateCancelRecordVoice {
    [[LGSoundRecorder shareInstance] readyCancelSound];
}

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecordVoice {
    [[LGSoundRecorder shareInstance] resetNormalRecord];
    
}

/**
 *  取消录音
 */
- (void)cancelRecordVoice {
    [[LGSoundRecorder shareInstance] soundRecordFailed:self.view];
}
-(void)stopRecordVoice
{
    [self cancelRecordVoice];
}
/**
 *  录音时间短
 */
- (void)showShotTimeSign {
    [[LGSoundRecorder shareInstance] showShotTimeSign:self.view];
}

- (void)sixtyTimeStopSendVodio {
    int countDown = 60 - [[LGSoundRecorder shareInstance] soundRecordTime];
    NSLog(@"countDown is %d soundRecordTime is %f",countDown,[[LGSoundRecorder shareInstance] soundRecordTime]);
    if (countDown <= 10) {
        [[LGSoundRecorder shareInstance] showCountdown:countDown - 1];
    }
    if ([[LGSoundRecorder shareInstance] soundRecordTime] >= 60 && [[LGSoundRecorder shareInstance] soundRecordTime] <= 61) {
        
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        [self.recordButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  语音文件存储路径
 *
 *  @return 路径
 */
- (NSString *)recordPath {
    NSString *filePath = [DocumentPath stringByAppendingPathComponent:@"SoundFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    return filePath;
}

#pragma mark - LGSoundRecorderDelegate

- (void)showSoundRecordFailed{
    //	[[SoundRecorder shareInstance] soundRecordFailed:self];
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
}

-(void)defaultWork
{
    NSDictionary *dic = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"dataId":_relevanceId};
    [NetWorkHelp netWorkWithURLString:details
                           parameters:dic
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 NSString *str = dic[@"response"][@"details"][@"iscoll"];
                                 if([str intValue] == 1)
                                     _collectionimg.image = [UIImage imageNamed:@"star_yes"];
                                 else
                                     _collectionimg.image = [UIImage imageNamed:@"star_no"];
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [self showHint:kBxtNetWorkError];
                         }];
}

// 发表文字说说
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    DLog(@"发表");
    if (!textField.text) {
        [self showHint:@"请先输入发表内容"];
    }else{
                NSDictionary *dic = @{@"account":[UserInfo account].account,
                                     @"token":[UserInfo account].token,
                                     @"relevanceId":_relevanceId,
                                     @"type":@"1",
                                     @"content":textField.text};
                [self netWorkCommentAddDic:dic];
                [textField endEditing:YES];
                textField.text = nil;
            }
    return YES;
}
//发表语音说说
-(void)sendSound
{

    NSString *audioUrl = [ALiYunTool asyncUploadVideoPath:[[LGSoundRecorder shareInstance] soundFilePath] complete:^(UploadImageState state) {
        
        
        if (state == UploadImageFailed) {
            [self showHint:@"上传失败"];
            return;
        }
        
    }];
    NSString *timeLength = [NSString stringWithFormat:@"%.2f",[[LGSoundRecorder shareInstance] soundRecordTime]];
    NSDictionary *dic = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"relevanceId":_relevanceId,
                          @"type":@"2",
                          @"timeLength":timeLength, //文件时长
                          @"content":audioUrl};
    [self netWorkCommentAddDic:dic];
}

//删除说说
-(void)kBxtDelegateButtonClick:(UIButton *)btn
{
    BXTWeakSelf;
    [[UIApplication sharedApplication].keyWindow addSubview:self.hintView];
    self.hintView.clickIsSureBlock = ^(BOOL isSure)
    {
        if (isSure) {
            Html5FootList *list = weakSelf.response.list[btn.tag-200];
            [weakSelf netWorkCommentDelegateDic:list.dataId];
        }
        [weakSelf.hintView removeFromSuperview];
    };
}

-(void)netWorkHelp
{
        NSDictionary *dic = @{@"account":[UserInfo account].account,
                                                         @"token":[UserInfo account].token,
                                                         @"relevanceId":_relevanceId,
                                                         @"pageIndex":@(_pageIndex),
                                                         @"pageSize":@(_pageSize)};
        [NetWorkHelp netWorkWithURLString:commentlist
                                     parameters:dic
                                   SuccessBlock:^(NSDictionary *dic) {
                                           if ([dic[@"code"] intValue] == 0) {
                                                   DLog(@"请求成功");
                                                   _response = [Html5FootResponse mj_objectWithKeyValues:dic[@"response"]];
                                                   [_myMytableview reloadData];
                                               }else{
                                                       [self showHint:dic[@"errorMessage"]];
                                                   }
                                           [_myMytableview.mj_header endRefreshing];
                                           [_myMytableview.mj_footer endRefreshing];
                                       } failBlock:^(NSError *error) {
                                               [self showHint:kBxtNetWorkError];
                                               [_myMytableview.mj_header endRefreshing];
                                               [_myMytableview.mj_footer endRefreshing];
                                           }];
    }

-(void)netWorkAdd
{
        NSDictionary *dic = @{@"account":[UserInfo account].account,
                                                         @"token":[UserInfo account].token,
                                                         @"relevanceId":_relevanceId,
                                                         @"type":_type};
        [NetWorkHelp netWorkWithURLString:collectionadd
                                     parameters:dic
                                   SuccessBlock:^(NSDictionary *dic) {
                                           if ([dic[@"code"] intValue] == 0) {
                                                   [self showHint:@"收藏成功"];
                                               _collectionimg.image = [UIImage imageNamed:@"star_yes"];
                                               }else{
                                                       [self showHint:dic[@"errorMessage"]];
                                                   if ([dic[@"errorMessage"] isEqualToString:@"已收藏过了"])
                                                       _collectionimg.image = [UIImage imageNamed:@"star_yes"];
                                                   else
                                                       _collectionimg.image = [UIImage imageNamed:@"star_no"];
                                                   }
                                       } failBlock:^(NSError *error) {
                                               [self showHint:@"网络连接失败"];
                                           }];
    }

-(void)netWorkCommentAddDic:(NSDictionary *)dic
{
        [_myMytableview.mj_header beginRefreshing];
        [NetWorkHelp netWorkWithURLString:commentAdd
                                     parameters:dic
                                   SuccessBlock:^(NSDictionary *dic) {
                                           if ([dic[@"code"] intValue] == 0) {
                                                   [self showHint:@"发表成功"];
                                               }else{
                                                   [self showHint:dic[@"errorMessage"]];
                                                }
                                           [self netWorkHelp];
                                       } failBlock:^(NSError *error) {
                                               [self showHint:@"网络连接错误"];
                                               [_myMytableview.mj_header endRefreshing];
                                           }];
    }

-(void)netWorkCommentDelegateDic:(NSString *)dataId
{
        [_myMytableview.mj_header beginRefreshing];
        NSDictionary *dic = @{@"account":[UserInfo account].account,
                                                         @"token":[UserInfo account].token,
                                                         @"dataId":dataId};
        [NetWorkHelp netWorkWithURLString:commentdelete
                                     parameters:dic
                                   SuccessBlock:^(NSDictionary *dic) {
                                           if ([dic[@"code"] intValue] == 0) {
                                                   [self showHint:@"删除成功"];
                                               }else{
                                                       [self showHint:dic[@"errorMessage"]];
                                                   }
                                           [self netWorkHelp];
                                       } failBlock:^(NSError *error) {
                                               [self showHint:@"网络连接错误"];
                                               [_myMytableview.mj_header endRefreshing];
                                           }];
    }
-(void)viewWillDisappear:(BOOL)animated
{
    [[LGAudioPlayer sharePlayer] stopAudioPlayer];

}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    [_kBxtWebView stringByEvaluatingJavaScriptFromString:@"shutDownaudio()"];
}
- (DeleteNoteHintView *)hintView
{
    if (!_hintView) {
        _hintView = [[DeleteNoteHintView alloc] initWithFrame:self.view.bounds];
    }
    return _hintView;
}

@end
