//
//  HWAddVoiceController.m
//  Operator
//
//  Created by hai on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWAddVoiceController.h"

#import "AudioPlayViewController.h"
@interface HWAddVoiceController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSTimer  *_timer;
    
}
@property (weak, nonatomic) IBOutlet XTRecordView *RecordView;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**  录音数组 */
@property (nonatomic,strong) NSMutableArray * voiceArray;

@end

@implementation HWAddVoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"添加录音话术";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.navigationBarBackground.backgroundColor = [UIColor blackColor];
    self.leftBackImage.frame = CGRectMake(0, 19, 15, 22);
    [self.leftBackImage setImage:[UIImage imageNamed:@"返回0"]];
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];    
    // 注册一个监听事件。第三个参数的事件名， 系统用这个参数来区别不同事件。
    [notiCenter addObserver:self selector:@selector(receiveNotification:) name:@"uploadAudio" object:@"audio"];
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

#pragma mark - target
- (void)receiveNotification:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    if ([dic[@"errorMessage"] intValue] == 0) {
        AudioPlayViewController *play = [[AudioPlayViewController alloc] init];
        play.audioPath = dic[@"audioPath"];
        play.selectType = @"3";
        play.api = recordingaddwords;
        [self.navigationController pushViewController:play animated:YES];
    }else{
        [self showHint:@"上传失败，请重新上传"];
    }
}
- (void)dealloc
{
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_RecordView stopRecord];
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
    
}
#pragma mark --音频的content应该是音频的链接
-(void)addWordswithContent:(NSString *)content
{
    
}
@end
