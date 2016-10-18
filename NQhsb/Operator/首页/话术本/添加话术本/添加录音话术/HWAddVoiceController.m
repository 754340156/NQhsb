//
//  HWAddVoiceController.m
//  Operator
//
//  Created by hai on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWAddVoiceController.h"
#import "EMCDDeviceManager.h"
#import "NQRecordTool.h" //录音
@interface HWAddVoiceController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSTimer  *_timer;
    NQRecordTool *_recordTool;
    
}
/**  录音时长 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**  录音数组 */
@property (nonatomic,strong) NSMutableArray * voiceArray;

@end

@implementation HWAddVoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.title;
    
    [self makeBasic];
}
-(void)makeBasic
{
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    _recordTool=[NQRecordTool sharedRecordTool];

}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _voiceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
-(void)timerAction:(NSTimer *)timer
{
    _timeLabel.text=[NSString stringWithFormat:@"%@",timer.fireDate  ];
    
}
#pragma mark - target
- (IBAction)playAction:(id)sender
{
    [_recordTool destructionRecordingFile];//销毁上一次录制的文件
    [_recordTool startRecording];//开始录音
    
}
- (IBAction)stopAction:(id)sender
{
     [_recordTool  stopRecording];
}
#pragma mark --暂停
- (IBAction)pauseAction:(id)sender
{
   
    [_recordTool  stopRecording];
    [_recordTool  playRecordingFile];

}
#pragma mark --完成录音
- (IBAction)finishAction:(id)sender
{
    
  [_recordTool  stopRecording];
    [self  postDataToOSS];
    
    
}

#pragma mark - lazy
- (NSMutableArray *)voiceArray
{
    if (!_voiceArray) {
        _voiceArray = [NSMutableArray array];
    }
    return _voiceArray;
}
#pragma mark --先往阿里云获取存储的数据
-(void)postDataToOSS
{
    //上传数据
    [ALiYunTool asyncUploadVideoPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"lvRecord.caf"] complete:^(UploadImageState state) {
        
    }];
}
#pragma mark --音频的content应该是音频的链接
-(void)addWordswithContent:(NSString *)content
{
    
    
    
}
@end
