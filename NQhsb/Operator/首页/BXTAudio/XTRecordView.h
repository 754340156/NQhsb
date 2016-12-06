//
//  XTRecordView.h
//  Operator
//
//  Created by 白小田 on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "XTRecorderWave.h"

@interface XTRecordView : UIView
<
AVAudioPlayerDelegate
>
{
    NSTimer *RecordingTimer;
    NSTimeInterval intervalTime;
    
    UIScrollView *scrollview;
    XTRecorderWave *waveView;
    UIView  *footView;
    UILabel *timeLabel;
    
    UIView *actionView;
    UIButton *playButton;
    
    UIButton *recordButton;
    
    
    float sampleWidth;
}
@property (nonatomic, readonly, assign) BOOL isAllowUseMIC;
@property (nonatomic, readonly, assign) BOOL isRecording;
@property (nonatomic, readonly, assign) BOOL isRecordedWave;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, readonly, copy) NSString *audioPath;

@property (nonatomic, readonly, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, readonly, strong) AVAudioPlayer *audioPlayer;

- (BOOL)checkRecord;
- (void)startRecord;
- (void)stopRecord;
@end
