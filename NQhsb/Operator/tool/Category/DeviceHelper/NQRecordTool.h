//
//  NQRecordTool.h
//  Operator
//
//  Created by NeiQuan on 16/10/17.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class NQRecordTool;
@protocol NQRecordToolDelegate <NSObject>

@optional
- (void)recordTool:(NQRecordTool *)recordTool didstartRecoring:(int)no;

@end

@interface NQRecordTool : NSObject

/** 录音工具的单例 */
+ (instancetype)sharedRecordTool;

/** 开始录音 */
- (void)startRecording;

/** 停止录音 */
- (void)stopRecording;

/** 播放录音文件 */
- (void)playRecordingFile;

/** 停止播放录音文件 */
- (void)stopPlaying;

/** 销毁录音文件 */
- (void)destructionRecordingFile;

/** 录音对象 */
@property (nonatomic, strong) AVAudioRecorder *recorder;
/** 播放器对象 */
@property (nonatomic, strong) AVAudioPlayer *player;

/** 更新图片的代理 */
@property (nonatomic, assign) id<NQRecordToolDelegate> delegate;



@end
