//
//  AudioPlayViewController.m
//  Operator
//
//  Created by 白小田 on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "AudioPlayViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayViewController ()<AVAudioPlayerDelegate,UITextFieldDelegate,UITextViewDelegate>
kBxtPropertyStrong      AVAudioPlayer *player;
kBxtPropertyStrong      UIProgressView *progressV;      //播放进度
kBxtPropertyStrong      UISlider *volumeSlider;         //声音控制
kBxtPropertyStrong      NSTimer *timer;                 //监控音频播放进度
kBxtPropertyStrong      UITextField *titleContentTextTF;
kBxtPropertyStrong      UITextView  *contentTextTV;
kBxtPropertyNonatomic   BOOL     isPlay;
@end

@implementation AudioPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"添加录音备注";
    _isPlay = NO;
    [self.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    _titleContentTextTF = [[UITextField alloc] init];
    [_titleContentTextTF setFrame:CGRectMake(20, 74, WIDTH-40, 60)];
    [_titleContentTextTF setText:@"输入标题"];
    [_titleContentTextTF setFont:FontOfSize(22)];
    [_titleContentTextTF setTextColor:[UIColor blackColor]];
    [_titleContentTextTF setDelegate:self];
    [_titleContentTextTF setBorderStyle:UITextBorderStyleNone];
    [self.view addSubview:_titleContentTextTF];
    
    //初始化三个button
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(20, _titleContentTextTF.bottom+10, 40, 40)];
    [button setTitle:@"播放" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(button.right, button.top, WIDTH-button.right-20, button.height)];
    backView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:backView];
    
    _contentTextTV = [[UITextView alloc] init];
    [_contentTextTV setFrame:CGRectMake(button.left, button.bottom + 20, WIDTH-40, HEIGHT-64-button.bottom+20)];
    [_contentTextTV setFont:FontOfSize(14)];
    [_contentTextTV setTextColor:[UIColor blackColor]];
    [_contentTextTV setDelegate:self];
    _contentTextTV.layer.masksToBounds = YES;
    _contentTextTV.layer.cornerRadius  = 10;
    _contentTextTV.layer.borderWidth   = 0.5;
    _contentTextTV.layer.borderColor   = [UIColor colorWithWhite:0.4 alpha:1].CGColor;
    [self.view addSubview:_contentTextTV];
    
//    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button1 setFrame:CGRectMake(100, 250, 60, 40)];
//    [button1 setTitle:@"暂停" forState:UIControlStateNormal];
//    [button1 addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button1];
//    
//    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button2 setFrame:CGRectMake(100, 280, 60, 40)];
//    [button2 setTitle:@"stop" forState:UIControlStateNormal];
//    [button2 addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button2];
    

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
    
    _player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:_audioPath] error:nil];
    
    _player.meteringEnabled = YES;

    _player.delegate = self;
    //音量
    
    _player.volume = 1;//0.0-1.0之间
    //循环次数
    
    _player.numberOfLoops = -1;//-1为一直循环
    
    //预播放
    [_player prepareToPlay];
    
    //播放位置
    
    _player.currentTime =0.0;//可以指定从任意位置开始播放
    
    //仪表计数
    _player.meteringEnabled =YES;//开启仪表计数功能
    

    
    //初始化一个播放进度条
    _progressV = [[UIProgressView alloc] initWithFrame:CGRectMake(0, button.height/2, WIDTH-button.right-20, 20)];
//    _progressV.backgroundColor = [UIColor redColor];
    _progressV.progressTintColor = [UIColor redColor];//trackTintColor
    [backView addSubview:_progressV];
    
    //用NSTimer来监控音频播放进度
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
                                                      selector:@selector(playProgress)
                                                      userInfo:nil repeats:YES];
    //初始化音量控制
    _volumeSlider = [[UISlider alloc] initWithFrame:_progressV.frame];
    _volumeSlider.thumbTintColor = [UIColor redColor];
//    _volumeSlider.continuous = YES;// 设置可连续变化
    [_volumeSlider addTarget:self action:@selector(volumeChange)
                       forControlEvents:UIControlEventValueChanged];
    //设置最小
    _volumeSlider.minimumValue = _player.duration/100;
    //设置最大
    _volumeSlider.maximumValue = _player.duration/10;
    
    _volumeSlider.continuous = YES;
    //初始化
    _volumeSlider.value = 0.0f;
    
    [backView addSubview:_volumeSlider];

    
//    //声音开关控件(静音)
//    UISwitch *swith = [[UISwitch alloc] initWithFrame:CGRectMake(100, 20, 60, 40)];
//    [swith addTarget:self action:@selector(onOrOff:) forControlEvents:UIControlEventValueChanged];
//    //默认状态为打开
//    swith.on = YES;
//    [self.view addSubview:swith];
}
//播放
- (void)play:(UIButton *)btn
{
    if (!_isPlay) {
        
        [btn setTitle:@"暂停" forState:UIControlStateNormal];
        
        NSError *playerError;
        
        if (_player == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        
        [self handleNotification:YES];
        [_player play];
        
    }else{
        [btn setTitle:@"播放" forState:UIControlStateNormal];
        [_player pause];
    }

    _isPlay = !_isPlay;
}
//暂停
- (void)pause
{
    [_player pause];
}
//停止
- (void)stop
{
    _progressV.progress = 0;
    _player.currentTime = 0;  //当前播放时间设置为0
    _volumeSlider.value = 0.0f;
    [_player stop];
}
//播放进度条
- (void)playProgress
{
    //通过音频播放时长的百分比,给progressview进行赋值;
    _progressV.progress = _player.currentTime/_player.duration;
    _volumeSlider.value = (_player.currentTime/10)/(_player.duration/10);
}
//声音开关(是否静音)
- (void)onOrOff:(UISwitch *)sender
{
    _player.volume = sender.on;
}

//播放进度控制
- (void)volumeChange
{
    [self pause];
     _player.currentTime = _volumeSlider.value;//可以指定从任意位置开始播放
    
    // 跳转到拖拽秒处
    // self.playProgress.maxValue = value / timeScale
    // value = progress.value * timeScale
//     CMTimemake(value, timeScale) =  (progress.value, 1.0)
//        // 跳转完成后
//    }];
}

//播放完成时调用的方法  (代理里的方法),需要设置代理才可以调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [_timer invalidate]; //NSTimer暂停
    [self handleNotification:NO];
    _volumeSlider.value = 0.0f;
    NSLog(@"播放结束");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;
{
    //解码错误执行的动作
}
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player;
{
    //处理中断的代码
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
    if (_contentTextTV.text != nil && _titleContentTextTF.text != nil && _audioUrl != nil) {
        [self netWorkHelpSave];
    }else{
        [self showHint:@"请填写完整"];
    }
}
-(void)netWorkHelpSave
{

    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"content":_audioUrl,
                          @"title":_titleContentTextTF.text,
                          @"remark":_contentTextTV.text,
                          @"wordsType":@"5"};
    [NetWorkHelp netWorkWithURLString:addrecording
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             if ([dic[@"code"] intValue] == 0) {
                                 [self showHint:@"保存成功"];
                                 int index = [[self.navigationController viewControllers]indexOfObject:self];
                                 [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
                             }else{
                                 [self showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             [self showHint:@"请检查网络连接"];
                         }];
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
