//
//  AudioPlayViewController.m
//  Operator
//
//  Created by 白小田 on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "AudioPlayViewController.h"
#import <AVFoundation/AVFoundation.h>

#define BoFimage        [UIImage imageNamed:@"ICON_Broadcast"]
#define ZanTimage       [UIImage imageNamed:@"icon_zanting"]

@interface AudioPlayViewController ()<AVAudioPlayerDelegate,UITextFieldDelegate,UITextViewDelegate>
kBxtPropertyStrong      AVAudioPlayer *player;
kBxtPropertyStrong      UIProgressView *progressV;      //播放进度
kBxtPropertyStrong      UISlider *volumeSlider;         //声音控制
kBxtPropertyStrong      NSTimer *timer;                 //监控音频播放进度
kBxtPropertyStrong      UIButton *playButton;           //播放按钮
kBxtPropertyStrong      UIImageView *playImage;          //播放图片
kBxtPropertyStrong      UITextField *titleContentTextTF;//标题
kBxtPropertyStrong      UITextView  *contentTextTV;     //备注内容
kBxtPropertyStrong      UILabel     *playerTimeLabel;   //播放时间
kBxtPropertyNonatomic   BOOL     isPlay;                //是否播放
@end

@implementation AudioPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self audioSession];
    [self defiultSetting];
    [self addUI];
}
-(void)defiultSetting
{
    self.titleLabel.text = @"添加录音备注";
    self.view.backgroundColor = BXT_BACKGROUND_COLOR;
    _isPlay = YES;
}
-(void)addUI
{
    [self.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:KTabBarColor forState:UIControlStateNormal];
    
    //标题
    _titleContentTextTF = [[UITextField alloc] init];
    [_titleContentTextTF setFrame:CGRectMake(20, 74, WIDTH-40, 50)];
    [_titleContentTextTF setText:@"输入标题"];
    [_titleContentTextTF setFont:FontOfSize(17)];
    [_titleContentTextTF setTextColor:[UIColor blackColor]];
    [_titleContentTextTF setDelegate:self];
    [_titleContentTextTF setBorderStyle:UITextBorderStyleNone];
    [self.view addSubview:_titleContentTextTF];
    
    //播放
    _playImage = [[UIImageView alloc] initWithImage:BoFimage];
    [_playImage setFrame:CGRectMake(20, _titleContentTextTF.bottom+10, 30, 30)];
    [self.view addSubview:_playImage];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_playButton setFrame:CGRectMake(0, _titleContentTextTF.bottom, 70, 70)];
    [_playButton setBackgroundColor:[UIColor clearColor]];
    [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
    
    //播放器背景视图
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(_playImage.right+3, _playImage.top, WIDTH-_playImage.right-23, _playImage.height)];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    //内容TextView
    _contentTextTV = [[UITextView alloc] init];
    [_contentTextTV setFrame:CGRectMake(_playImage.left, _playImage.bottom + 20, WIDTH-40, HEIGHT-64-_playImage.bottom+20)];
    [_contentTextTV setFont:FontOfSize(14)];
    [_contentTextTV setTextColor:[UIColor blackColor]];
    [_contentTextTV setDelegate:self];
    _contentTextTV.layer.masksToBounds = YES;
    _contentTextTV.layer.cornerRadius  = 3;
    _contentTextTV.layer.borderWidth   = 0.5;
    _contentTextTV.layer.borderColor   = [UIColor colorWithWhite:0.4 alpha:1].CGColor;
    [self.view addSubview:_contentTextTV];
    
    //播放器
    _player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:_audioPath] error:nil];
    _player.meteringEnabled = YES;
    _player.delegate = self;
    _player.volume = 1;//0.0-1.0之间(音量)
    _player.numberOfLoops = 0;//-1为一直循环(循环次数)
    [_player prepareToPlay];//预播放
    _player.currentTime =0.0;//可以指定从任意位置开始播放(播放位置)
    _player.meteringEnabled =YES;//开启仪表计数功能
    [_player prepareToPlay];//加载音频文件到缓存
    
    //初始化一个播放进度条
    _progressV = [[UIProgressView alloc] initWithFrame:CGRectMake(0, _playImage.height/2, WIDTH-_playImage.right-80, 20)];
    //    _progressV.backgroundColor = [UIColor redColor];
    _progressV.progressTintColor = KTabBarColor;//trackTintColor
    _progressV.trackTintColor    = [UIColor lightGrayColor];
    _progressV.progressViewStyle = UIProgressViewStyleDefault;
    [backView addSubview:_progressV];
    
    //用NSTimer来监控音频播放进度
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
                                            selector:@selector(playProgress)
                                            userInfo:nil repeats:YES];

    //初始化进度控制
    _volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, _progressV.width, backView.height)];
    _volumeSlider.minimumTrackTintColor = [UIColor clearColor];
    _volumeSlider.maximumTrackTintColor = [UIColor clearColor];
    [_volumeSlider setThumbImage:[UIImage imageNamed:@"jindutiao"] forState:UIControlStateNormal];
    [_volumeSlider addTarget:self action:@selector(volumeChange:) forControlEvents:UIControlEventValueChanged];
    [_volumeSlider addTarget:self action:@selector(volumeChangeDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    _volumeSlider.minimumValue = 0;                //设置最小
    _volumeSlider.maximumValue = 1; //设置最大
    _volumeSlider.value = _player.currentTime;
    [backView addSubview:_volumeSlider];
    
    _playerTimeLabel = [[UILabel alloc] init];
    [_playerTimeLabel setFrame:CGRectMake(_volumeSlider.right+5, 0, 55, backView.height)];
    [_playerTimeLabel setFont:FontOfSize(10)];
    NSMutableAttributedString *playerAllTimeText;
    playerAllTimeText = [BXTTextColor getAcolorfulStringWithText1:@"0.00"
                                                           Color1:KTabBarColor
                                                            Font1:FontOfSize(10)
                                                            Text2:[NSString stringWithFormat:@"%.2f",_player.duration]
                                                           Color2:[UIColor colorWithWhite:0.23 alpha:1.0]
                                                            Font2:FontOfSize(10)
                                                          AllText:[NSString stringWithFormat:@"0.00/%.2f",_player.duration]];
    [_playerTimeLabel setAttributedText:playerAllTimeText];
    [backView addSubview:_playerTimeLabel];
}
#pragma mark - 播放器方法
//播放
- (void)playButtonClick:(UIButton *)btn
{
    _isPlay = !_isPlay;
    if (!_isPlay) {
        [_playImage setImage:ZanTimage];
        NSError *playerError;
        
        if (_player == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        
        [self handleNotification:YES];
        [_player play];
        
    }else{
        [_playImage setImage:BoFimage];
        [_player pause];
    }
}
//暂停
- (void)pause
{
    _isPlay = !_isPlay;
     [_playImage setImage:BoFimage];
    [_player pause];
}
//停止
- (void)stop
{
    [self handleNotification:NO];
    _isPlay = !_isPlay;
    _progressV.progress = 0;
    _player.currentTime = 0;  //当前播放时间设置为0
    _volumeSlider.value = 0.0f;
    _progressV.progressTintColor = KTabBarColor;
    _progressV.trackTintColor    = [UIColor lightGrayColor];
    [_playImage setImage:BoFimage];
    [_player stop];
}
//播放进度条
- (void)playProgress
{
    //通过音频播放时长的百分比,给progressview进行赋值;
    float progress= _player.currentTime /_player.duration;
    [_progressV setProgress:progress animated:true];
    _volumeSlider.value = progress;
    NSMutableAttributedString *playerAllTimeText;
    playerAllTimeText = [BXTTextColor getAcolorfulStringWithText1:[NSString stringWithFormat:@"%.2f",_player.currentTime]
                                                           Color1:KTabBarColor
                                                            Font1:FontOfSize(10)
                                                            Text2:[NSString stringWithFormat:@"%.2f",_player.duration]
                                                           Color2:[UIColor colorWithWhite:0.23 alpha:1.0]
                                                            Font2:FontOfSize(10)
                                                          AllText:[NSString stringWithFormat:@"%.2f/%.2f",_player.currentTime,_player.duration]];
    [_playerTimeLabel setAttributedText:playerAllTimeText];
}
//声音开关(是否静音)
- (void)onOrOff:(UISwitch *)sender
{
    _player.volume = sender.on;
}

//播放进度控制
- (void)volumeChange:(UISlider *)sider
{
    
    float progress= _player.currentTime /_player.duration;
    [_progressV setProgress:progress animated:true];
    [_player setCurrentTime:sider.value*_player.duration];
}
//滑动结束后的操作
-(void)volumeChangeDidEnd:(UISlider *)sider
{
    
}
//开始播放后播放器的执行方法
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player;
{
    
}
//播放完成时调用的方法  (代理里的方法),需要设置代理才可以调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stop];
    NSLog(@"播放结束");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;
{
    //解码错误执行的动作
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    [_player play];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _titleContentTextTF) {
        textField.text = nil;
    }
}

-(void)rightButtonClick
{
    if (_contentTextTV.text != nil && _titleContentTextTF.text != nil) {
        [self uploadAudio];
    }else{
        [self showHint:@"请填写完整"];
    }
}
#pragma mark - 上传录音
-(void)uploadAudio
{
    [self showHudInView:self.view hint:nil];
    _audioUrl = [ALiYunTool asyncUploadVideoPath:_audioPath complete:^(UploadImageState state) {
        
        
        if (state == UploadImageFailed) {
            [self showHint:kBxtNetWorkError];
            return;
        }
        
    }];
    [self netWorkHelpSave];
}
#pragma mark - 保存录音请求
-(void)netWorkHelpSave
{
    
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"content":_audioUrl,
                          @"title":_titleContentTextTF.text,
                          @"remark":_contentTextTV.text,
                          @"wordsType":_selectType};
    [NetWorkHelp netWorkWithURLString:_api
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             [self hideHud];
                             if ([dic[@"code"] intValue] == 0) {
                                 [self showHint:@"保存成功"];
                                 int index = [[self.navigationController viewControllers]indexOfObject:self];
                                 [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [self showHint:kBxtNetWorkError];
                             [self hideHud];
                         }];
}
#pragma mark - 监听播放方式
-(void)audioSession
{
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];\
    [audioSession setActive:YES error:nil];
}
#pragma mark - 监听听筒or扬声器
- (void) handleNotification:(BOOL)state
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:state]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    
    if(state)//添加监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification"
                                                   object:nil];
    else//移除监听
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}
-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size

{
    
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
     [_player stop];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
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
