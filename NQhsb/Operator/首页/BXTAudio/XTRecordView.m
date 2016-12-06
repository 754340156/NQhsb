//
//  XTRecordView.m
//  Operator
//
//  Created by 白小田 on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "XTRecordView.h"
#import "math.h"
#import "AddAudioViewController.h"
#import "AudioPlayViewController.h"
@implementation XTRecordView

@synthesize audioRecorder;
@synthesize audioPlayer;
@synthesize audioPath;

@synthesize isAllowUseMIC;
@synthesize isRecording;
@synthesize isRecordedWave;
- (void)awakeFromNib
{
    [self setup];
    [self checkRecord];
    [self performSelector:@selector(setupView)
               withObject:nil afterDelay:0];
}

- (void)setupView{
    scrollview = [[UIScrollView alloc] init];
    [scrollview setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100)];
    [scrollview setContentSize:scrollview.bounds.size];
    scrollview.backgroundColor = [UIColor clearColor];
    //scrollview.delegate = self;
    scrollview.pagingEnabled = NO;
    scrollview.scrollEnabled = YES;
    scrollview.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollview];
    
    waveView = [[XTRecorderWave alloc] initWithFrame:CGRectMake(0, 0, scrollview.bounds.size.width, scrollview.bounds.size.height-80)];
    waveView.intervalTime = intervalTime;
    waveView.sampleWidth = sampleWidth;
    [scrollview addSubview:waveView];
    
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-140, self.frame.size.width, 1)];
    footView.backgroundColor = [UIColor whiteColor];
    [self addSubview:footView];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 140, self.frame.size.width, 50)];
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabel setTextColor:[UIColor whiteColor]];
    [timeLabel setTextAlignment:NSTextAlignmentCenter];
    [timeLabel setFont:[UIFont systemFontOfSize:36.0f]];
    [timeLabel setText:@""];
    [self addSubview:timeLabel];
    
    actionView = [[UIView alloc] init];
    [actionView setFrame:CGRectMake((self.frame.size.width - 300)/2.0, self.frame.size.height - 80, 300, 80)];
    [actionView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:actionView];
    
    recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [recordButton setFrame:CGRectMake(120, 0, 70, 70)];
    [recordButton setImage:[UIImage imageNamed:@"组2"] forState:UIControlStateNormal];
    [recordButton setImage:[UIImage imageNamed:@"组1"] forState:UIControlStateSelected];
    [recordButton addTarget:self action:@selector(clickedRecorderButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setFrame:CGRectMake((recordButton.left - 100), 0, 70, 70)];
    [playButton setTitle:@"播放" forState:UIControlStateNormal];
    [playButton setTitle:@"停止" forState:UIControlStateSelected];
//    [playButton setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
//    [playButton setBackgroundImage:[UIImage imageNamed:@"3"] forState:UIControlStateSelected];
    [playButton setFont:[UIFont systemFontOfSize:22]];
    [playButton addTarget:self action:@selector(clickedVoicePlay:) forControlEvents:UIControlEventTouchUpInside];
    
    _finishButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_finishButton setFrame:CGRectMake(recordButton.right + 30, 0, 70, 70)];
    [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [_finishButton setFont:FontOfSize(22)];
    [_finishButton addTarget:self action:@selector(finishButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [actionView addSubview:playButton];
    [actionView addSubview:_finishButton];
    [actionView addSubview:recordButton];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) [self setup];
    return self;
}

- (void)setup {
    intervalTime = 0.025;
    sampleWidth = 0.5;
}

- (void)restRecord{
    [waveView.samples removeAllObjects];
    [waveView setNeedsDisplay];
    
    [timeLabel setText:@""];
}

- (BOOL)checkRecord{
    if ([self canRecord]) {
        isAllowUseMIC = YES;
    }else{
        isAllowUseMIC = NO;
    }
    return isAllowUseMIC;
}

- (void)startRecord
{
    if (isRecording){
        return;
    }
    if (isRecordedWave) {
        [self restRecord];
    }
    
    if (isAllowUseMIC) {
        isRecording = YES;
        NSLog(@"startRecord");
        audioRecorder = nil;
        isRecordedWave = YES;
        
        // Init audio with record capability
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        NSDictionary *recordSettings=[NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithFloat:8000],AVSampleRateKey,
                                      [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                                      [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                      [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                      nil];
        
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY_MM_dd_hh:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        audioPath = [self FilePathInLibraryWithName:[NSString stringWithFormat:@"Caches/%@.wav",dateString]];
        NSURL *url = [NSURL fileURLWithPath:audioPath];
        
        NSError *error = nil;
        audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
        [audioRecorder setMeteringEnabled:YES];
        if ([audioRecorder prepareToRecord] == YES){
            [audioRecorder record];
        }else {
            int errorCode = CFSwapInt32HostToBig ((int)[error code]);
            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
        }
        if (audioRecorder.isRecording) {
            NSLog(@"recording");
            [self initTimer];
        }
    }
}

-(void)stopRecord
{
    NSLog(@"stopRecord");
    [audioRecorder stop];
    audioRecorder=nil;
    
    isRecording = NO;
    
    [RecordingTimer invalidate];
    RecordingTimer = nil;
}

-(void)initTimer
{
    [RecordingTimer invalidate];
    RecordingTimer = nil;
    //定时器
    RecordingTimer = [NSTimer scheduledTimerWithTimeInterval:intervalTime
                                                      target:self
                                                    selector:@selector(handleMaxRecordingTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
    [RecordingTimer fire];
}

//刷新界面
-(void)handleMaxRecordingTimer:(NSTimer *)theTimer
{
    if (audioRecorder && audioRecorder.isRecording) {
        [audioRecorder updateMeters];
        float peakPowerForChannel = [audioRecorder peakPowerForChannel:0];
        float peakPower = pow(10, (0.05 * peakPowerForChannel));
        NSLog(@"peakPower   :%lf   from :%lf",peakPower,peakPowerForChannel);
        
        [waveView  addSamples:[NSNumber numberWithFloat:peakPowerForChannel]];
        
        if (floor(waveView.samples.count*sampleWidth) >= ceil(waveView.bounds.size.width)){
            CGRect rectWave = waveView.frame;
            rectWave.size.width = (waveView.samples.count + 1)*sampleWidth;
            waveView.frame = rectWave;
            
            [scrollview setContentSize:rectWave.size];
            [scrollview scrollRectToVisible:CGRectMake((waveView.samples.count - 1)*sampleWidth, 0, sampleWidth, rectWave.size.height) animated:NO];
        }
        float time = audioRecorder.currentTime;
        NSInteger time2 = time * 100;
        NSInteger timeMin = time2 / 6000;
        NSInteger timeSe = time2 % 6000;
        
        NSString *timeString;
        if (timeMin == 0) {
            timeString = [NSString stringWithFormat:@"%0.2f\"",(timeSe / 100.00)];
        }else{
            timeString = [NSString stringWithFormat:@"%ld' %0.1f\"",timeMin,(timeSe / 100.00)];
        }
        [timeLabel setText:timeString];
    }
}

- (void)drawRect:(CGRect)rect{
    [[UIColor blackColor] set];
    UIRectFill(self.bounds);
}


- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[UIDevice currentDevice].systemVersion doubleValue] > 6.9)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                } else {
                    bCanRecord = NO;
                }
            }];
        }
    }
    return bCanRecord;
}


- (IBAction)clickedRecorderButton:(id)sender {
    UIButton *bt = (UIButton *)sender;
    [self stopPlaying];
    if (self.isAllowUseMIC) {
        if (bt.isSelected) {
            [bt setSelected:NO];
            [self stopRecord];
        }else{
            [bt setSelected:YES];
            [self startRecord];
        }
    }
}

#pragma mark 播放

- (IBAction)clickedVoicePlay:(id)sender {
    if (audioPlayer != nil && audioPlayer.isPlaying) {
        [playButton setSelected:NO];
        [self stopPlaying];
    }else{
        if (self.isRecordedWave && !self.isRecording) {
            [playButton setSelected:YES];
            [self playRecordingWithPath:self.audioPath];
        }
    }
}
#pragma mark 完成
-(void)finishButtonClick
{
    [playButton setSelected:NO];
    [self stopRecord];
    [self stopPlaying];
    [_finishButton setSelected:YES];
    
    NSDictionary *dic = @{@"audioPath":audioPath};
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"uploadAudio" object:@"audio" userInfo:dic];
}

-(void) playRecordingWithPath:(NSString *)RecordPath{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSURL *url;
    url = [NSURL fileURLWithPath:RecordPath];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (error != nil){
        [self stopPlaying];
    }else{
        audioPlayer.numberOfLoops = 0;
        audioPlayer.delegate = self;
        [audioPlayer play];
        NSLog(@"playing");
    }
}

-(void)stopPlaying
{
    NSLog(@"stopPlaying");
    [audioPlayer stop];
    audioPlayer = nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [playButton setSelected:NO];
    audioPlayer = nil;
}

- (NSString *)FilePathInLibraryWithName:(NSString *)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *LibraryDirectory = [paths objectAtIndex:0];
    return [LibraryDirectory stringByAppendingPathComponent:name];
}

@end
