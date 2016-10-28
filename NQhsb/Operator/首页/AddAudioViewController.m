//
//  AddAudioViewController.m
//  Operator
//
//  Created by 白小田 on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "AddAudioViewController.h"
#import "AudioPlayViewController.h"
@interface AddAudioViewController ()

@end

@implementation AddAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"录制";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.navigationBarBackground.backgroundColor = [UIColor blackColor];
    self.leftBackImage.frame = CGRectMake(0, 0, 15, 22);
    [self.leftBackImage setImage:[UIImage imageNamed:@"返回0"]];
    
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    
    // 注册一个监听事件。第三个参数的事件名， 系统用这个参数来区别不同事件。
    [notiCenter addObserver:self selector:@selector(receiveNotification:) name:@"uploadAudio" object:@"audio"];
}
- (void)receiveNotification:(NSNotification *)noti
{
    [self showHudInView:self.view hint:nil];
    NSDictionary *dic = noti.userInfo;
    if ([dic[@"errorMessage"] intValue] == 0) {
        [self showHint:@"上传成功"];
        AudioPlayViewController *play = [[AudioPlayViewController alloc] init];
        play.audioUrl = dic[@"audioUrl"];
        play.audioPath = dic[@"audioPath"];
        [self.navigationController pushViewController:play animated:YES];
        [self hideHud];
    }else{
        [self showHint:@"上传失败，请重新上传"];
        [self hideHud];
    }
}
- (void)dealloc
{
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
